@tool
extends Node
## Minimal HTTP server for the MCP bridge.
##
## Binds to 127.0.0.1 only. Every request must carry the auth token that the
## plugin generates on first run (header "X-MCP-Token" or query param "token").
## Host header is validated to block DNS rebinding from a browser tab.

signal request_received(method: String, path: String, params: Dictionary)
signal server_started(port: int)
signal server_stopped()

const BIND_ADDRESS := "127.0.0.1"
const MAX_BODY_BYTES := 8 * 1024 * 1024  # 8 MiB. Screenshots move the other way, so requests stay small.
const CLIENT_TIMEOUT_SEC := 10.0

var port: int = 3571
var auth_token: String = ""
var is_running: bool = false

var tcp_server: TCPServer
var poll_timer: Timer
var request_count: int = 0

var routes: Dictionary = {}

# Each pending client accumulates bytes until the full request (headers +
# Content-Length body) has arrived. Entries: { peer, buffer, deadline }.
var _pending: Array[Dictionary] = []


func _ready() -> void:
	if tcp_server == null:
		tcp_server = TCPServer.new()
	if poll_timer == null:
		poll_timer = Timer.new()
		poll_timer.wait_time = 0.01
		poll_timer.timeout.connect(_poll)
		add_child(poll_timer)


func start_server(server_port: int, token: String) -> bool:
	if tcp_server == null:
		tcp_server = TCPServer.new()
	if poll_timer == null:
		poll_timer = Timer.new()
		poll_timer.wait_time = 0.01
		poll_timer.timeout.connect(_poll)
		add_child(poll_timer)

	port = server_port
	auth_token = token

	var error := tcp_server.listen(port, BIND_ADDRESS)
	if error != OK:
		push_error("[MCP] Could not listen on %s:%d (%s)" % [BIND_ADDRESS, port, error_string(error)])
		return false

	is_running = true
	poll_timer.start()
	server_started.emit(port)
	print("[MCP] HTTP bridge listening on %s:%d" % [BIND_ADDRESS, port])
	return true


func stop_server() -> void:
	if tcp_server and tcp_server.is_listening():
		tcp_server.stop()
	if poll_timer:
		poll_timer.stop()
	for entry in _pending:
		entry.peer.disconnect_from_host()
	_pending.clear()
	is_running = false
	server_stopped.emit()
	print("[MCP] HTTP bridge stopped")


func register_route(route_path: String, handler: Callable) -> void:
	routes[route_path] = handler


func _poll() -> void:
	if not is_running:
		return

	while tcp_server and tcp_server.is_connection_available():
		var peer := tcp_server.take_connection()
		if peer:
			_pending.append({
				"peer": peer,
				"buffer": PackedByteArray(),
				"deadline": Time.get_ticks_msec() + int(CLIENT_TIMEOUT_SEC * 1000.0),
			})

	var finished: Array[int] = []
	for i in _pending.size():
		if _pump_client(_pending[i]):
			finished.append(i)
	for i in range(finished.size() - 1, -1, -1):
		_pending.remove_at(finished[i])


## Returns true when the client is done and can be dropped from the queue.
func _pump_client(entry: Dictionary) -> bool:
	var peer: StreamPeerTCP = entry.peer
	peer.poll()
	var status := peer.get_status()

	if status != StreamPeerTCP.STATUS_CONNECTED:
		peer.disconnect_from_host()
		return true

	if Time.get_ticks_msec() > int(entry.deadline):
		_send_response(peer, 408, {"error": "Request timeout"})
		return true

	var available := peer.get_available_bytes()
	if available > 0:
		var chunk = peer.get_data(available)
		if chunk[0] == OK:
			entry.buffer.append_array(chunk[1])

	if entry.buffer.size() > MAX_BODY_BYTES:
		_send_response(peer, 413, {"error": "Request too large"})
		return true

	var raw: String = entry.buffer.get_string_from_utf8()
	var header_end := raw.find("\r\n\r\n")
	var separator_len := 4
	if header_end == -1:
		header_end = raw.find("\n\n")
		separator_len = 2
	if header_end == -1:
		return false  # Headers not complete yet.

	var head := raw.substr(0, header_end)
	var body := raw.substr(header_end + separator_len)
	var parsed := _parse_head(head)
	if parsed.is_empty():
		_send_response(peer, 400, {"error": "Bad request"})
		return true

	var content_length := int(parsed.headers.get("content-length", "0"))
	if content_length > MAX_BODY_BYTES:
		_send_response(peer, 413, {"error": "Request too large"})
		return true
	if body.to_utf8_buffer().size() < content_length:
		return false  # Body not complete yet.

	request_count += 1
	_dispatch(peer, parsed, body)
	return true


func _dispatch(peer: StreamPeerTCP, parsed: Dictionary, body: String) -> void:
	# Host check: refuse anything that is not loopback. A malicious web page
	# can make a browser send requests to 127.0.0.1, but DNS rebinding also
	# lets it fake a "real" hostname. Rejecting foreign Host values kills that.
	var host: String = parsed.headers.get("host", "")
	if not _is_loopback_host(host):
		_send_response(peer, 403, {"error": "Forbidden host"})
		return

	# Browsers always attach an Origin header to cross-site requests.
	# Direct clients (the Python bridge, curl) do not. Reject anything with one.
	if parsed.headers.has("origin"):
		_send_response(peer, 403, {"error": "Cross-origin requests are not allowed"})
		return

	# Token check.
	var provided: String = parsed.headers.get("x-mcp-token", parsed.params.get("token", ""))
	if auth_token.is_empty() or not _tokens_match(provided, auth_token):
		_send_response(peer, 401, {"error": "Missing or invalid token. Pass it in the X-MCP-Token header."})
		return

	var params: Dictionary = parsed.params
	if not body.strip_edges().is_empty():
		var json := JSON.new()
		if json.parse(body) == OK and json.get_data() is Dictionary:
			var body_params: Dictionary = json.get_data()
			for key in body_params:
				params[key] = body_params[key]

	request_received.emit(parsed.method, parsed.path, params)

	if routes.has(parsed.path):
		var handler: Callable = routes[parsed.path]
		if handler.is_valid():
			_respond_async(peer, handler, params)
		else:
			_send_response(peer, 500, {"error": "Handler is no longer valid"})
	else:
		_send_response(peer, 404, {"error": "Route not found", "path": parsed.path})


func _respond_async(peer: StreamPeerTCP, handler: Callable, params: Dictionary) -> void:
	var result = await handler.call(params)
	_send_response(peer, 200, result)


func _parse_head(head: String) -> Dictionary:
	var lines := head.split("\n")
	if lines.is_empty():
		return {}

	var request_parts := lines[0].strip_edges().split(" ")
	if request_parts.size() < 2:
		return {}

	var method := request_parts[0]
	var full_path := request_parts[1]
	var path := full_path
	var query := ""
	if "?" in full_path:
		var split := full_path.split("?", true, 1)
		path = split[0]
		query = split[1] if split.size() > 1 else ""

	var headers := {}
	for i in range(1, lines.size()):
		var line := lines[i].strip_edges()
		if line.is_empty():
			break
		if ":" in line:
			var kv := line.split(":", true, 1)
			headers[kv[0].strip_edges().to_lower()] = kv[1].strip_edges()

	var params := {}
	if not query.is_empty():
		for pair in query.split("&"):
			if "=" in pair:
				var kv := pair.split("=", true, 1)
				params[kv[0].uri_decode()] = kv[1].uri_decode() if kv.size() > 1 else ""

	return {"method": method, "path": path, "headers": headers, "params": params}


func _is_loopback_host(host: String) -> bool:
	var name := host
	if name.begins_with("["):
		var close := name.find("]")
		if close == -1:
			return false
		name = name.substr(1, close - 1)
	elif ":" in name:
		name = name.split(":")[0]
	return name == "127.0.0.1" or name == "localhost" or name == "::1"


## Length-constant comparison so response timing leaks nothing useful.
func _tokens_match(a: String, b: String) -> bool:
	var a_bytes := a.to_utf8_buffer()
	var b_bytes := b.to_utf8_buffer()
	if a_bytes.size() != b_bytes.size():
		return false
	var diff := 0
	for i in a_bytes.size():
		diff |= a_bytes[i] ^ b_bytes[i]
	return diff == 0


func _send_response(peer: StreamPeerTCP, status_code: int, data: Variant) -> void:
	var body_bytes := JSON.stringify(data).to_utf8_buffer()
	var head := "HTTP/1.1 %d %s\r\n" % [status_code, _status_text(status_code)]
	head += "Content-Type: application/json; charset=utf-8\r\n"
	head += "Content-Length: %d\r\n" % body_bytes.size()
	head += "Connection: close\r\n\r\n"
	peer.put_data(head.to_utf8_buffer())
	peer.put_data(body_bytes)
	# Give the OS a beat to flush before closing.
	var tree := get_tree()
	if tree:
		tree.create_timer(0.1).timeout.connect(func(): peer.disconnect_from_host())
	else:
		peer.disconnect_from_host()


func _status_text(code: int) -> String:
	match code:
		200: return "OK"
		400: return "Bad Request"
		401: return "Unauthorized"
		403: return "Forbidden"
		404: return "Not Found"
		408: return "Request Timeout"
		413: return "Payload Too Large"
		500: return "Internal Server Error"
		_: return "Error"
