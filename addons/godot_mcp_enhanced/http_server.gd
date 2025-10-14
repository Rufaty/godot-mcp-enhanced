@tool
extends Node

var tcp_server: TCPServer
var port: int = 3571
var routes: Dictionary = {}
var is_running: bool = false

signal request_received(method: String, path: String, params: Dictionary)
signal server_started(port: int)
signal server_stopped()


func _ready() -> void:
	tcp_server = TCPServer.new()


func start_server(server_port: int) -> bool:
	port = server_port
	var error = tcp_server.listen(port, "127.0.0.1")
	
	if error != OK:
		push_error("[HTTP Server] Failed to start server on port %d: %s" % [port, error_string(error)])
		return false
	
	is_running = true
	set_process(true)
	emit_signal("server_started", port)
	print("[HTTP Server] Started on port %d" % port)
	return true


func stop_server() -> void:
	if tcp_server.is_listening():
		tcp_server.stop()
	
	is_running = false
	set_process(false)
	emit_signal("server_stopped")
	print("[HTTP Server] Stopped")


func register_route(route_path: String, handler: Callable) -> void:
	routes[route_path] = handler
	print("[HTTP Server] Registered route: %s" % route_path)


func _process(_delta: float) -> void:
	if not is_running:
		return
	
	if tcp_server.is_connection_available():
		var client = tcp_server.take_connection()
		_handle_client(client)


func _handle_client(client: StreamPeerTCP) -> void:
	# Wait for data (with timeout)
	var max_wait = 100  # milliseconds
	var wait_time = 0
	
	while client.get_available_bytes() == 0 and wait_time < max_wait:
		await get_tree().create_timer(0.01).timeout
		wait_time += 10
	
	if client.get_available_bytes() == 0:
		client.disconnect_from_host()
		return
	
	# Read HTTP request
	var request_text = ""
	while client.get_available_bytes() > 0:
		request_text += client.get_string(client.get_available_bytes())
		await get_tree().create_timer(0.001).timeout
	
	# Parse HTTP request
	var parsed = _parse_http_request(request_text)
	if not parsed:
		_send_response(client, 400, {"error": "Bad Request"})
		return
	
	var method = parsed.method
	var path = parsed.path
	var params = parsed.params
	
	emit_signal("request_received", method, path, params)
	
	# Handle request
	if routes.has(path):
		var handler = routes[path]
		var result = await handler.call(params) if handler.is_valid() else {"error": "Invalid handler"}
		_send_response(client, 200, result)
	else:
		_send_response(client, 404, {"error": "Route not found", "path": path})


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
	await get_tree().create_timer(0.1).timeout
	client.disconnect_from_host()


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
