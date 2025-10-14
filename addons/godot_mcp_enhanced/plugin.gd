@tool
extends EditorPlugin

const HTTPServer = preload("res://addons/godot_mcp_enhanced/http_server.gd")
const ScreenshotManager = preload("res://addons/godot_mcp_enhanced/screenshot_manager.gd")
const SceneOperations = preload("res://addons/godot_mcp_enhanced/scene_operations.gd")
const ScriptOperations = preload("res://addons/godot_mcp_enhanced/script_operations.gd")
const DebuggerIntegration = preload("res://addons/godot_mcp_enhanced/debugger_integration.gd")
const FileOperations = preload("res://addons/godot_mcp_enhanced/file_operations.gd")

var http_server: Node
var screenshot_manager: Node
var scene_operations: Node
var script_operations: Node
var debugger_integration: Node
var file_operations: Node

var bottom_panel: Control
var config: Dictionary = {}
var config_path: String = "res://godot_mcp_config.json"


func _enter_tree() -> void:
	print("[Godot MCP Enhanced] Initializing plugin...")
	
	# Load configuration
	_load_config()
	
	# Initialize core systems
	http_server = HTTPServer.new()
	http_server.name = "MCPHTTPServer"
	add_child(http_server)
	
	screenshot_manager = ScreenshotManager.new()
	screenshot_manager.name = "MCPScreenshotManager"
	add_child(screenshot_manager)
	
	scene_operations = SceneOperations.new()
	scene_operations.name = "MCPSceneOperations"
	scene_operations.editor_interface = get_editor_interface()
	add_child(scene_operations)
	
	script_operations = ScriptOperations.new()
	script_operations.name = "MCPScriptOperations"
	script_operations.editor_interface = get_editor_interface()
	add_child(script_operations)
	
	debugger_integration = DebuggerIntegration.new()
	debugger_integration.name = "MCPDebuggerIntegration"
	debugger_integration.editor_interface = get_editor_interface()
	add_child(debugger_integration)
	
	file_operations = FileOperations.new()
	file_operations.name = "MCPFileOperations"
	add_child(file_operations)
	
	# Connect HTTP server to operation handlers
	_setup_http_routes()
	
	# Create bottom panel UI
	_create_bottom_panel()
	
	# Start HTTP server
	var port = int(config.get("GDAI_MCP_SERVER_PORT", 3571))
	print("[Godot MCP Enhanced] Attempting to start HTTP server on port %d..." % port)
	
	var success = http_server.start_server(port)
	
	if success:
		print("[Godot MCP Enhanced] ✓ HTTP Server started successfully on port %d" % port)
		# Update UI status
		if bottom_panel:
			bottom_panel.update_server_status(true)
	else:
		push_error("[Godot MCP Enhanced] ✗ Failed to start HTTP server on port %d!" % port)
		push_error("[Godot MCP Enhanced] Port may already be in use or blocked by firewall")
		push_error("[Godot MCP Enhanced] Try changing GDAI_MCP_SERVER_PORT in godot_mcp_config.json")
		# Update UI status
		if bottom_panel:
			bottom_panel.update_server_status(false)
	
	print("[Godot MCP Enhanced] Plugin initialization complete")


func _exit_tree() -> void:
	print("[Godot MCP Enhanced] Shutting down plugin...")
	
	# Stop HTTP server
	if http_server:
		http_server.stop_server()
	
	# Remove bottom panel
	if bottom_panel:
		remove_control_from_bottom_panel(bottom_panel)
		bottom_panel.queue_free()
	
	# Clean up nodes
	for child in [http_server, screenshot_manager, scene_operations, 
				  script_operations, debugger_integration, file_operations]:
		if child:
			child.queue_free()
	
	print("[Godot MCP Enhanced] Plugin shutdown complete")


func _load_config() -> void:
	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		if file:
			var json_text = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var error = json.parse(json_text)
			if error == OK:
				config = json.get_data()
				print("[Godot MCP Enhanced] Configuration loaded from ", config_path)
			else:
				push_error("[Godot MCP Enhanced] Failed to parse config: " + json.get_error_message())
	else:
		# Create default config
		config = {
			"GDAI_MCP_SERVER_PORT": "3571",
			"GDAI_RUNTIME_SERVER_PORT": "3572",
			"AUTO_SCREENSHOT": true,
			"SCREENSHOT_ON_SCENE_CHANGE": true,
			"SCREENSHOT_ON_ERROR": true
		}
		_save_config()


func _save_config() -> void:
	var file = FileAccess.open(config_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(config, "\t"))
		file.close()
		print("[Godot MCP Enhanced] Configuration saved to ", config_path)


func _setup_http_routes() -> void:
	# Project tools
	http_server.register_route("/api/project/info", _handle_get_project_info)
	http_server.register_route("/api/project/filesystem", _handle_get_filesystem_tree)
	http_server.register_route("/api/project/search_files", _handle_search_files)
	http_server.register_route("/api/project/uid_to_path", _handle_uid_to_project_path)
	http_server.register_route("/api/project/path_to_uid", _handle_project_path_to_uid)
	
	# Scene tools
	http_server.register_route("/api/scene/tree", _handle_get_scene_tree)
	http_server.register_route("/api/scene/file_content", _handle_get_scene_file_content)
	http_server.register_route("/api/scene/create", _handle_create_scene)
	http_server.register_route("/api/scene/open", _handle_open_scene)
	http_server.register_route("/api/scene/delete", _handle_delete_scene)
	http_server.register_route("/api/scene/add_scene", _handle_add_scene)
	http_server.register_route("/api/scene/play", _handle_play_scene)
	http_server.register_route("/api/scene/stop", _handle_stop_running_scene)
	
	# Node tools
	http_server.register_route("/api/node/add", _handle_add_node)
	http_server.register_route("/api/node/delete", _handle_delete_node)
	http_server.register_route("/api/node/duplicate", _handle_duplicate_node)
	http_server.register_route("/api/node/move", _handle_move_node)
	http_server.register_route("/api/node/update_property", _handle_update_property)
	http_server.register_route("/api/node/add_resource", _handle_add_resource)
	http_server.register_route("/api/node/set_anchor_preset", _handle_set_anchor_preset)
	http_server.register_route("/api/node/set_anchor_values", _handle_set_anchor_values)
	
	# Script tools
	http_server.register_route("/api/script/get_open_scripts", _handle_get_open_scripts)
	http_server.register_route("/api/script/view", _handle_view_script)
	http_server.register_route("/api/script/create", _handle_create_script)
	http_server.register_route("/api/script/attach", _handle_attach_script)
	http_server.register_route("/api/script/edit_file", _handle_edit_file)
	
	# Editor tools
	http_server.register_route("/api/editor/errors", _handle_get_godot_errors)
	http_server.register_route("/api/editor/screenshot", _handle_get_editor_screenshot)
	http_server.register_route("/api/editor/running_scene_screenshot", _handle_get_running_scene_screenshot)
	http_server.register_route("/api/editor/execute_script", _handle_execute_editor_script)
	http_server.register_route("/api/editor/clear_logs", _handle_clear_output_logs)
	
	# Windsurf-specific tools
	http_server.register_route("/api/windsurf/context", _handle_get_windsurf_context)
	http_server.register_route("/api/windsurf/live_preview", _handle_get_live_preview)


func _create_bottom_panel() -> void:
	bottom_panel = preload("res://addons/godot_mcp_enhanced/ui/bottom_panel.tscn").instantiate()
	add_control_to_bottom_panel(bottom_panel, "MCP Enhanced")
	
	# Connect signals
	bottom_panel.connect("config_changed", _on_config_changed)
	bottom_panel.connect("server_restart_requested", _on_server_restart_requested)
	
	# Update UI with current config
	bottom_panel.update_config_display(config)


# HTTP Route Handlers - Project Tools
func _handle_get_project_info(params: Dictionary) -> Dictionary:
	var project_info = {
		"name": ProjectSettings.get_setting("application/config/name", "Unknown Project"),
		"version": ProjectSettings.get_setting("application/config/version", "1.0"),
		"godot_version": Engine.get_version_info(),
		"project_path": ProjectSettings.globalize_path("res://"),
		"main_scene": ProjectSettings.get_setting("application/run/main_scene", ""),
		"features": ProjectSettings.get_setting("application/config/features", []),
		"auto_accept_quit": ProjectSettings.get_setting("application/config/auto_accept_quit", true)
	}
	return {"success": true, "data": project_info}


func _handle_get_filesystem_tree(params: Dictionary) -> Dictionary:
	var filters = params.get("filters", [])
	var tree = file_operations.get_filesystem_tree("res://", filters)
	return {"success": true, "data": tree}


func _handle_search_files(params: Dictionary) -> Dictionary:
	var query = params.get("query", "")
	var results = file_operations.search_files(query)
	return {"success": true, "data": results}


func _handle_uid_to_project_path(params: Dictionary) -> Dictionary:
	var uid = params.get("uid", "")
	var path = file_operations.uid_to_project_path(uid)
	return {"success": true, "data": {"path": path}}


func _handle_project_path_to_uid(params: Dictionary) -> Dictionary:
	var path = params.get("path", "")
	var uid = file_operations.project_path_to_uid(path)
	return {"success": true, "data": {"uid": uid}}


# HTTP Route Handlers - Scene Tools
func _handle_get_scene_tree(params: Dictionary) -> Dictionary:
	var tree = scene_operations.get_scene_tree()
	return {"success": true, "data": tree}


func _handle_get_scene_file_content(params: Dictionary) -> Dictionary:
	var content = scene_operations.get_scene_file_content()
	return {"success": true, "data": {"content": content}}


func _handle_create_scene(params: Dictionary) -> Dictionary:
	var scene_path = params.get("scene_path", "")
	var root_type = params.get("root_type", "Node2D")
	var result = scene_operations.create_scene(scene_path, root_type)
	return result


func _handle_open_scene(params: Dictionary) -> Dictionary:
	var scene_path = params.get("scene_path", "")
	var result = scene_operations.open_scene(scene_path)
	return result


func _handle_delete_scene(params: Dictionary) -> Dictionary:
	var scene_path = params.get("scene_path", "")
	var result = scene_operations.delete_scene(scene_path)
	return result


func _handle_add_scene(params: Dictionary) -> Dictionary:
	var scene_path = params.get("scene_path", "")
	var parent_node = params.get("parent_node", "")
	var result = scene_operations.add_scene_as_child(scene_path, parent_node)
	return result


func _handle_play_scene(params: Dictionary) -> Dictionary:
	var scene_path = params.get("scene_path", "")
	var result = scene_operations.play_scene(scene_path)
	return result


func _handle_stop_running_scene(params: Dictionary) -> Dictionary:
	var result = scene_operations.stop_running_scene()
	return result


# HTTP Route Handlers - Node Tools
func _handle_add_node(params: Dictionary) -> Dictionary:
	return scene_operations.add_node(params)


func _handle_delete_node(params: Dictionary) -> Dictionary:
	return scene_operations.delete_node(params)


func _handle_duplicate_node(params: Dictionary) -> Dictionary:
	return scene_operations.duplicate_node(params)


func _handle_move_node(params: Dictionary) -> Dictionary:
	return scene_operations.move_node(params)


func _handle_update_property(params: Dictionary) -> Dictionary:
	return scene_operations.update_property(params)


func _handle_add_resource(params: Dictionary) -> Dictionary:
	return scene_operations.add_resource(params)


func _handle_set_anchor_preset(params: Dictionary) -> Dictionary:
	return scene_operations.set_anchor_preset(params)


func _handle_set_anchor_values(params: Dictionary) -> Dictionary:
	return scene_operations.set_anchor_values(params)


# HTTP Route Handlers - Script Tools
func _handle_get_open_scripts(params: Dictionary) -> Dictionary:
	return script_operations.get_open_scripts()


func _handle_view_script(params: Dictionary) -> Dictionary:
	return script_operations.view_script(params)


func _handle_create_script(params: Dictionary) -> Dictionary:
	return script_operations.create_script(params)


func _handle_attach_script(params: Dictionary) -> Dictionary:
	return script_operations.attach_script(params)


func _handle_edit_file(params: Dictionary) -> Dictionary:
	return script_operations.edit_file(params)


# HTTP Route Handlers - Editor Tools
func _handle_get_godot_errors(params: Dictionary) -> Dictionary:
	return debugger_integration.get_errors()


func _handle_get_editor_screenshot(params: Dictionary) -> Dictionary:
	var screenshot_data = screenshot_manager.capture_editor_screenshot()
	return {"success": true, "data": {"screenshot": screenshot_data}}


func _handle_get_running_scene_screenshot(params: Dictionary) -> Dictionary:
	var screenshot_data = screenshot_manager.capture_running_scene_screenshot()
	return {"success": true, "data": {"screenshot": screenshot_data}}


func _handle_execute_editor_script(params: Dictionary) -> Dictionary:
	var code = params.get("code", "")
	return script_operations.execute_editor_script(code)


func _handle_clear_output_logs(params: Dictionary) -> Dictionary:
	return debugger_integration.clear_logs()


# Windsurf-specific handlers
func _handle_get_windsurf_context(params: Dictionary) -> Dictionary:
	var context = {
		"current_scene": get_editor_interface().get_edited_scene_root().get_name() if get_editor_interface().get_edited_scene_root() else null,
		"open_scripts": script_operations.get_open_script_names(),
		"recent_errors": debugger_integration.get_recent_errors(5),
		"project_structure": file_operations.get_quick_project_overview(),
		"editor_state": {
			"playing": get_editor_interface().is_playing_scene(),
			"distraction_free": get_editor_interface().is_distraction_free_mode_enabled()
		}
	}
	return {"success": true, "data": context}


func _handle_get_live_preview(params: Dictionary) -> Dictionary:
	var preview_data = {
		"screenshot": screenshot_manager.capture_editor_screenshot(),
		"scene_tree": scene_operations.get_compact_scene_tree(),
		"current_script": script_operations.get_current_script_content()
	}
	return {"success": true, "data": preview_data}


# Signal handlers
func _on_config_changed(new_config: Dictionary) -> void:
	config = new_config
	_save_config()


func _on_server_restart_requested() -> void:
	print("[Godot MCP Enhanced] ========================================")
	print("[Godot MCP Enhanced] Restarting server...")
	
	# Stop server
	http_server.stop_server()
	if bottom_panel:
		bottom_panel.update_server_status(false)
	
	print("[Godot MCP Enhanced] Server stopped, waiting 1 second...")
	await get_tree().create_timer(1.0).timeout
	
	# Start server
	var port = int(config.get("GDAI_MCP_SERVER_PORT", 3571))
	print("[Godot MCP Enhanced] Starting server on port %d..." % port)
	
	var success = http_server.start_server(port)
	
	if success:
		print("[Godot MCP Enhanced] ✓ Server restarted successfully on port %d" % port)
		if bottom_panel:
			bottom_panel.update_server_status(true)
	else:
		push_error("[Godot MCP Enhanced] ✗ Failed to restart server on port %d!" % port)
		push_error("[Godot MCP Enhanced] Check if port is already in use")
		if bottom_panel:
			bottom_panel.update_server_status(false)
	
	print("[Godot MCP Enhanced] ========================================")
