@tool
extends Node

var editor_interface: EditorInterface
var error_log: Array = []
var output_log: Array = []
var max_log_entries: int = 1000

signal error_captured(error: Dictionary)
signal output_captured(message: String)


func _ready() -> void:
	# Connect to EditorInterface signals for error monitoring
	print("[Debugger Integration] Initialized")


func get_errors() -> Dictionary:
	"""Get all captured errors, logs, and debugger output"""
	var errors_data = {
		"script_errors": _get_script_errors(),
		"runtime_errors": error_log.duplicate(),
		"output_logs": output_log.duplicate(),
		"stack_trace": _get_current_stack_trace()
	}
	
	return {"success": true, "data": errors_data}


func get_recent_errors(count: int = 5) -> Array:
	"""Get recent errors for Windsurf context"""
	var recent = error_log.duplicate()
	recent.reverse()
	
	if recent.size() > count:
		recent.resize(count)
	
	return recent


func _get_script_errors() -> Array:
	"""Get script compilation errors from the editor"""
	var script_errors = []
	
	# Try to access script editor for errors
	var script_editor = editor_interface.get_script_editor()
	if script_editor:
		# Get open scripts and check for errors
		var open_scripts = script_editor.get_open_scripts()
		for script in open_scripts:
			if script is Script:
				var error = script.reload()
				if error != OK:
					script_errors.append({
						"type": "script_error",
						"path": script.resource_path,
						"error": error_string(error),
						"timestamp": Time.get_unix_time_from_system()
					})
	
	return script_errors


func _get_current_stack_trace() -> Array:
	"""Get current stack trace if available"""
	var stack = []
	
	# Get stack from current execution
	var current_stack = get_stack()
	for frame in current_stack:
		stack.append({
			"function": frame.function,
			"source": frame.source,
			"line": frame.line
		})
	
	return stack


func capture_error(error_message: String, error_type: String = "runtime", source: String = "", line: int = 0) -> void:
	"""Capture an error message"""
	var error_data = {
		"type": error_type,
		"message": error_message,
		"source": source,
		"line": line,
		"timestamp": Time.get_unix_time_from_system(),
		"time_formatted": Time.get_datetime_string_from_system()
	}
	
	error_log.append(error_data)
	
	# Limit log size
	if error_log.size() > max_log_entries:
		error_log.pop_front()
	
	emit_signal("error_captured", error_data)
	print("[Debugger Integration] Error captured: ", error_message)


func capture_output(message: String) -> void:
	"""Capture output log message"""
	var log_entry = {
		"message": message,
		"timestamp": Time.get_unix_time_from_system(),
		"time_formatted": Time.get_datetime_string_from_system()
	}
	
	output_log.append(log_entry)
	
	# Limit log size
	if output_log.size() > max_log_entries:
		output_log.pop_front()
	
	emit_signal("output_captured", message)


func clear_logs() -> Dictionary:
	"""Clear all captured logs"""
	error_log.clear()
	output_log.clear()
	print("[Debugger Integration] Logs cleared")
	return {"success": true, "message": "Logs cleared"}


func get_debugger_state() -> Dictionary:
	"""Get current debugger state (Windsurf feature)"""
	var is_playing = editor_interface.is_playing_scene()
	
	var state = {
		"is_playing": is_playing,
		"is_paused": false,  # EditorInterface doesn't expose pause state directly
		"current_scene": "",
		"breakpoints": []
	}
	
	if is_playing:
		# Try to get current running scene info
		var edited_scene = editor_interface.get_edited_scene_root()
		if edited_scene:
			state["current_scene"] = edited_scene.scene_file_path
	
	return {"success": true, "data": state}


func get_performance_metrics() -> Dictionary:
	"""Get performance metrics (Windsurf feature for optimization)"""
	var metrics = {
		"fps": Engine.get_frames_per_second(),
		"frame_time": Performance.get_monitor(Performance.TIME_PROCESS),
		"physics_time": Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS),
		"objects": Performance.get_monitor(Performance.OBJECT_COUNT),
		"resources": Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT),
		"nodes": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"orphan_nodes": Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT),
		"memory": {
			"static": Performance.get_monitor(Performance.MEMORY_STATIC),
			"dynamic": Performance.get_monitor(Performance.MEMORY_STATIC_MAX),
			"message_buffer": Performance.get_monitor(Performance.MEMORY_MESSAGE_BUFFER_MAX)
		},
		"render": {
			"vertices": Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
			"draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
		}
	}
	
	return {"success": true, "data": metrics}


func monitor_scene_errors() -> Dictionary:
	"""Real-time error monitoring for current scene (Windsurf streaming feature)"""
	var scene_errors = []
	
	var root = editor_interface.get_edited_scene_root()
	if root:
		# Check for common scene issues
		scene_errors.extend(_check_missing_scripts(root))
		scene_errors.extend(_check_invalid_nodes(root))
		scene_errors.extend(_check_resource_issues(root))
	
	return {"success": true, "data": scene_errors}


func _check_missing_scripts(node: Node) -> Array:
	"""Check for nodes with missing scripts"""
	var issues = []
	
	var script = node.get_script()
	if script and not script.has_source_code():
		issues.append({
			"type": "missing_script",
			"node": node.get_path(),
			"message": "Node has script reference but script has no source code"
		})
	
	for child in node.get_children():
		issues.append_array(_check_missing_scripts(child))
	
	return issues


func _check_invalid_nodes(node: Node) -> Array:
	"""Check for invalid node configurations"""
	var issues = []
	
	# Check CollisionShape2D/3D without shape
	if node is CollisionShape2D and node.shape == null:
		issues.append({
			"type": "missing_resource",
			"node": node.get_path(),
			"message": "CollisionShape2D missing shape resource"
		})
	elif node is CollisionShape3D and node.shape == null:
		issues.append({
			"type": "missing_resource",
			"node": node.get_path(),
			"message": "CollisionShape3D missing shape resource"
		})
	
	# Check Sprite2D/3D without texture
	if node is Sprite2D and node.texture == null:
		issues.append({
			"type": "missing_resource",
			"node": node.get_path(),
			"message": "Sprite2D missing texture"
		})
	elif node is Sprite3D and node.texture == null:
		issues.append({
			"type": "missing_resource",
			"node": node.get_path(),
			"message": "Sprite3D missing texture"
		})
	
	for child in node.get_children():
		issues.append_array(_check_invalid_nodes(child))
	
	return issues


func _check_resource_issues(node: Node) -> Array:
	"""Check for resource loading issues"""
	var issues = []
	
	# Get all properties that are resources
	for prop in node.get_property_list():
		if prop.type == TYPE_OBJECT and prop.usage & PROPERTY_USAGE_STORAGE:
			var resource = node.get(prop.name)
			if resource is Resource and not resource.resource_path.is_empty():
				if not FileAccess.file_exists(resource.resource_path):
					issues.append({
						"type": "missing_file",
						"node": node.get_path(),
						"property": prop.name,
						"path": resource.resource_path,
						"message": "Resource file not found: " + resource.resource_path
					})
	
	for child in node.get_children():
		issues.append_array(_check_resource_issues(child))
	
	return issues


func get_profiler_data() -> Dictionary:
	"""Get profiler data for performance analysis (Windsurf feature)"""
	# Note: Full profiler access requires EditorProfiler which is not easily accessible
	# We provide basic performance data instead
	
	var profiler_data = {
		"enabled": false,
		"message": "Full profiler data requires running game. Use performance metrics instead.",
		"basic_metrics": get_performance_metrics()["data"]
	}
	
	return {"success": true, "data": profiler_data}


func analyze_script_performance(script_path: String) -> Dictionary:
	"""Analyze script for potential performance issues (Windsurf feature)"""
	if not script_path.begins_with("res://"):
		script_path = "res://" + script_path
	
	if not FileAccess.file_exists(script_path):
		return {"success": false, "error": "Script not found: " + script_path}
	
	var file = FileAccess.open(script_path, FileAccess.READ)
	if not file:
		return {"success": false, "error": "Failed to open script"}
	
	var content = file.get_as_text()
	file.close()
	
	var issues = []
	
	# Check for common performance issues
	if "_process" in content and "delta" in content:
		issues.append({
			"type": "performance_hint",
			"severity": "info",
			"message": "Script uses _process. Consider using signals or timers for non-continuous logic."
		})
	
	if "_physics_process" in content:
		issues.append({
			"type": "performance_hint",
			"severity": "info",
			"message": "Script uses _physics_process. Ensure physics calculations are necessary every frame."
		})
	
	# Check for string operations in loops
	if "for " in content and ("+" in content or "str(" in content):
		issues.append({
			"type": "performance_warning",
			"severity": "warning",
			"message": "Possible string concatenation in loop. Consider using Array.join() or StringBuilder pattern."
		})
	
	# Check for get_node calls
	var get_node_count = content.count("get_node")
	if get_node_count > 5:
		issues.append({
			"type": "performance_hint",
			"severity": "info",
			"message": "Multiple get_node calls detected (%d). Consider caching node references in _ready()." % get_node_count
		})
	
	return {
		"success": true,
		"data": {
			"path": script_path,
			"issues": issues,
			"issue_count": issues.size()
		}
	}
