@tool
extends Node

# Debug mode - set to true for verbose logging
const DEBUG = true

var tcp_server: TCPServer
var port: int = 3571
var routes: Dictionary = {}
var is_running: bool = false
var poll_timer: Timer
var pending_clients: Array[StreamPeerTCP] = []

# Debug counters
var poll_count: int = 0
var connection_count: int = 0
var request_count: int = 0
var debug_timer: Timer

signal request_received(method: String, path: String, params: Dictionary)
signal server_started(port: int)
signal server_stopped()


func debug_log(message: String) -> void:
	if DEBUG:
		print("[HTTP Server DEBUG] " + message)


func _ready() -> void:
	debug_log("_ready() called")
	
	# Don't overwrite tcp_server if it already exists (might be listening!)
	if tcp_server == null:
		tcp_server = TCPServer.new()
		debug_log("TCPServer created")
	else:
		debug_log("TCPServer already exists, not overwriting")
	
	# Don't overwrite poll_timer if it already exists (might be running!)
	if poll_timer == null:
		poll_timer = Timer.new()
		poll_timer.wait_time = 0.01  # Poll every 10ms
		poll_timer.timeout.connect(_poll_connections)
		add_child(poll_timer)
		debug_log("Poll timer created and added")
	else:
		debug_log("Poll timer already exists, not overwriting")
	
	# Create debug status timer
	if DEBUG:
		debug_timer = Timer.new()
		debug_timer.wait_time = 5.0  # Status every 5 seconds
		debug_timer.timeout.connect(_print_debug_status)
		add_child(debug_timer)
		debug_timer.start()
		debug_log("Debug timer started")


func start_server(server_port: int) -> bool:
	debug_log("start_server() called with port: " + str(server_port))
	
	# Ensure tcp_server is initialized (in case _ready hasn't been called yet)
	if tcp_server == null:
		debug_log("tcp_server was null, creating new one")
		tcp_server = TCPServer.new()
	
	# Ensure poll_timer is initialized
	if poll_timer == null:
		debug_log("poll_timer was null, creating new one")
		poll_timer = Timer.new()
		poll_timer.wait_time = 0.01
		poll_timer.timeout.connect(_poll_connections)
		add_child(poll_timer)
	
	port = server_port
	debug_log("Attempting to listen on 127.0.0.1:" + str(port))
	var error = tcp_server.listen(port, "127.0.0.1")
	
	if error != OK:
		debug_log("FAILED to listen: " + error_string(error))
		push_error("[HTTP Server] Failed to start server on port %d: %s" % [port, error_string(error)])
		return false
	
	debug_log("Successfully listening on port " + str(port))
	is_running = true
	poll_timer.start()
	debug_log("Poll timer started")
	emit_signal("server_started", port)
	print("[HTTP Server] Started on port %d" % port)
	print("[HTTP Server] Polling for connections every 10ms")
	debug_log("Server fully started and ready")
	return true


func stop_server() -> void:
	if tcp_server and tcp_server.is_listening():
		tcp_server.stop()
	
	if poll_timer:
		poll_timer.stop()
	
	is_running = false
	emit_signal("server_stopped")
	print("[HTTP Server] Stopped")


func register_route(route_path: String, handler: Callable) -> void:
	routes[route_path] = handler
	print("[HTTP Server] Registered route: %s" % route_path)


func _poll_connections() -> void:
	poll_count += 1
	
	if not is_running:
		debug_log("Poll #" + str(poll_count) + " - Server not running, skipping")
		return
	
	# Only log every 100 polls to avoid spam
	if poll_count % 100 == 0:
		debug_log("Poll #" + str(poll_count) + " - Checking for connections...")
	
	# Accept new connections
	if tcp_server and tcp_server.is_connection_available():
		connection_count += 1
		debug_log("CONNECTION AVAILABLE! (#" + str(connection_count) + ")")
		var client = tcp_server.take_connection()
		debug_log("Client taken, status: " + str(client.get_status()))
		pending_clients.append(client)
		print("[HTTP Server] New connection accepted (#" + str(connection_count) + ")")
	
	# Process pending clients
	if pending_clients.size() > 0:
		debug_log("Processing " + str(pending_clients.size()) + " pending clients")
	
	var clients_to_remove = []
	for i in range(pending_clients.size()):
		var client = pending_clients[i]
		if _try_handle_client(client):
			clients_to_remove.append(i)
	
	# Remove processed clients (in reverse to maintain indices)
	for i in range(clients_to_remove.size() - 1, -1, -1):
		pending_clients.remove_at(clients_to_remove[i])


func _print_debug_status() -> void:
	debug_log("=== STATUS REPORT ===")
	debug_log("Running: " + str(is_running))
	debug_log("Poll count: " + str(poll_count))
	debug_log("Connections accepted: " + str(connection_count))
	debug_log("Requests processed: " + str(request_count))
	debug_log("Pending clients: " + str(pending_clients.size()))
	if tcp_server:
		debug_log("TCP Server listening: " + str(tcp_server.is_listening()))
	debug_log("====================")


func _try_handle_client(client: StreamPeerTCP) -> bool:
	# Poll the client
	client.poll()
	var status = client.get_status()
	var bytes_available = client.get_available_bytes()
	
	debug_log("Client status: " + str(status) + ", bytes available: " + str(bytes_available))
	
	# Check if data is available
	if bytes_available == 0:
		# Check if client is still connected
		if status != StreamPeerTCP.STATUS_CONNECTED:
			debug_log("Client disconnected, removing")
			client.disconnect_from_host()
			return true  # Remove this client
		debug_log("No data yet, keeping client in queue")
		return false  # Keep waiting for data
	
	# Data is available, process it
	debug_log("Data available! Processing request...")
	request_count += 1
	_handle_client_request(client)
	debug_log("Request processed (#" + str(request_count) + ")")
	return true  # Remove this client after handling


func _handle_client_request(client: StreamPeerTCP) -> void:
	# Read all available HTTP request data
	var request_text = ""
	var bytes_available = client.get_available_bytes()
	debug_log("Reading " + str(bytes_available) + " bytes from client")
	
	if bytes_available > 0:
		request_text = client.get_string(bytes_available)
		debug_log("Request text length: " + str(request_text.length()))
		debug_log("First 100 chars: " + request_text.substr(0, 100))
	
	# Parse HTTP request
	var parsed = _parse_http_request(request_text)
	if not parsed:
		_send_response(client, 400, {"error": "Bad Request"})
		return
	
	var method = parsed.method
	var path = parsed.path
	var params = parsed.params
	
	emit_signal("request_received", method, path, params)
	
	# Handle request asynchronously
	if routes.has(path):
		var handler = routes[path]
		if handler.is_valid():
			# Call handler asynchronously and send response when done
			_call_handler_async(client, handler, params)
		else:
			_send_response(client, 500, {"error": "Invalid handler"})
	else:
		_send_response(client, 404, {"error": "Route not found", "path": path})


func _call_handler_async(client: StreamPeerTCP, handler: Callable, params: Dictionary) -> void:
	var result = await handler.call(params)
	_send_response(client, 200, result)


func _parse_http_request(request: String) -> Dictionary:
	var lines = request.split("\n")
	if lines.size() == 0:
		return {}
	
	# Parse request line
	var request_line = lines[0].strip_edges()
	var parts = request_line.split(" ")
	if parts.size() < 2:
		return {}
	
	var method = parts[0]
	var full_path = parts[1]
	
	# Split path and query string
	var path = full_path
	var query_string = ""
	if "?" in full_path:
		var split = full_path.split("?", true, 1)
		path = split[0]
		query_string = split[1] if split.size() > 1 else ""
	
	# Parse headers
	var headers = {}
	var body_start = 1
	for i in range(1, lines.size()):
		var line = lines[i].strip_edges()
		if line == "":
			body_start = i + 1
			break
		
		if ":" in line:
			var header_parts = line.split(":", true, 1)
			var key = header_parts[0].strip_edges().to_lower()
			var value = header_parts[1].strip_edges()
			headers[key] = value
	
	# Parse body (JSON)
	var params = {}
	if body_start < lines.size():
		var body = "\n".join(lines.slice(body_start))
		body = body.strip_edges()
		
		if body != "":
			var json = JSON.new()
			var error = json.parse(body)
			if error == OK:
				params = json.get_data()
	
	# Parse query string parameters
	if query_string != "":
		var query_params = query_string.split("&")
		for param in query_params:
			if "=" in param:
				var kv = param.split("=", true, 1)
				var key = _url_decode(kv[0])
				var value = _url_decode(kv[1]) if kv.size() > 1 else ""
				params[key] = value
	
	return {
		"method": method,
		"path": path,
		"headers": headers,
		"params": params
	}


func _send_response(client: StreamPeerTCP, status_code: int, data: Variant) -> void:
	var status_text = _get_status_text(status_code)
	var json_data = JSON.stringify(data)
	
	var response = "HTTP/1.1 %d %s\r\n" % [status_code, status_text]
	response += "Content-Type: application/json\r\n"
	response += "Content-Length: %d\r\n" % json_data.length()
	response += "Access-Control-Allow-Origin: *\r\n"
	response += "Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n"
	response += "Access-Control-Allow-Headers: Content-Type\r\n"
	response += "Connection: close\r\n"
	response += "\r\n"
	response += json_data
	
	client.put_data(response.to_utf8_buffer())
	# Disconnect after a short delay to ensure data is sent
	get_tree().create_timer(0.1).timeout.connect(func(): client.disconnect_from_host())


func _get_status_text(code: int) -> String:
	match code:
		200: return "OK"
		201: return "Created"
		400: return "Bad Request"
		404: return "Not Found"
		500: return "Internal Server Error"
		_: return "Unknown"


func _url_decode(text: String) -> String:
	var result = text.replace("+", " ")
	
	# Handle percent encoding
	var regex = RegEx.new()
	regex.compile("%([0-9A-Fa-f]{2})")
	
	var matches = regex.search_all(result)
	for match_obj in matches:
		var hex_str = match_obj.get_string(1)
		var char_code = hex_str.hex_to_int()
		var char = char(char_code)
		result = result.replace(match_obj.get_string(), char)
	
	return result
