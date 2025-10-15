@tool
extends Node

var editor_interface: EditorInterface


# ===== INPUT SIMULATION =====

func simulate_key_press(keycode: int, pressed: bool = true) -> Dictionary:
	"""Simulate keyboard key press/release"""
	var event = InputEventKey.new()
	event.keycode = keycode
	event.pressed = pressed
	
	Input.parse_input_event(event)
	
	return {
		"success": true,
		"message": "Key %d %s" % [keycode, "pressed" if pressed else "released"]
	}


func simulate_action(action_name: String, pressed: bool = true, strength: float = 1.0) -> Dictionary:
	"""Simulate input action (like ui_accept, jump, etc.)"""
	if not InputMap.has_action(action_name):
		return {
			"success": false,
			"error": "Action '%s' not found in InputMap" % action_name
		}
	
	var event = InputEventAction.new()
	event.action = action_name
	event.pressed = pressed
	event.strength = strength
	
	Input.parse_input_event(event)
	
	return {
		"success": true,
		"message": "Action '%s' %s with strength %.2f" % [action_name, "pressed" if pressed else "released", strength]
	}


func simulate_mouse_button(button_index: int, pressed: bool = true, position: Vector2 = Vector2.ZERO) -> Dictionary:
	"""Simulate mouse button press/release"""
	var event = InputEventMouseButton.new()
	event.button_index = button_index
	event.pressed = pressed
	event.position = position
	
	Input.parse_input_event(event)
	
	return {
		"success": true,
		"message": "Mouse button %d %s at %s" % [button_index, "pressed" if pressed else "released", position]
	}


func simulate_mouse_motion(position: Vector2, relative: Vector2 = Vector2.ZERO) -> Dictionary:
	"""Simulate mouse movement"""
	var event = InputEventMouseMotion.new()
	event.position = position
	event.relative = relative
	
	Input.parse_input_event(event)
	
	return {
		"success": true,
		"message": "Mouse moved to %s (relative: %s)" % [position, relative]
	}


func get_input_actions() -> Dictionary:
	"""Get all registered input actions"""
	var actions = []
	for action in InputMap.get_actions():
		var events = []
		for event in InputMap.action_get_events(action):
			events.append({
				"type": event.get_class(),
				"description": str(event)
			})
		
		actions.append({
			"name": action,
			"events": events,
			"deadzone": InputMap.action_get_deadzone(action)
		})
	
	return {
		"success": true,
		"actions": actions
	}


# ===== RUNTIME INSPECTION =====

func get_node_properties(node_path: String) -> Dictionary:
	"""Get all properties of a node at runtime"""
	if not editor_interface:
		return {"success": false, "error": "Editor interface not available"}
	
	var edited_scene = editor_interface.get_edited_scene_root()
	if not edited_scene:
		return {"success": false, "error": "No scene currently open"}
	
	var node = edited_scene.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: %s" % node_path}
	
	var properties = []
	for prop in node.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var value = node.get(prop.name)
			properties.append({
				"name": prop.name,
				"type": type_string(prop.type),
				"value": str(value),
				"hint": prop.hint,
				"hint_string": prop.hint_string
			})
	
	return {
		"success": true,
		"node_path": node_path,
		"node_type": node.get_class(),
		"properties": properties
	}


func get_node_methods(node_path: String) -> Dictionary:
	"""Get all methods of a node"""
	if not editor_interface:
		return {"success": false, "error": "Editor interface not available"}
	
	var edited_scene = editor_interface.get_edited_scene_root()
	if not edited_scene:
		return {"success": false, "error": "No scene currently open"}
	
	var node = edited_scene.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: %s" % node_path}
	
	var methods = []
	for method in node.get_method_list():
		if method.flags & METHOD_FLAG_FROM_SCRIPT:
			methods.append({
				"name": method.name,
				"return_type": type_string(method.return.type),
				"args": method.args
			})
	
	return {
		"success": true,
		"node_path": node_path,
		"methods": methods
	}


func call_node_method(node_path: String, method_name: String, args: Array = []) -> Dictionary:
	"""Call a method on a node"""
	if not editor_interface:
		return {"success": false, "error": "Editor interface not available"}
	
	var edited_scene = editor_interface.get_edited_scene_root()
	if not edited_scene:
		return {"success": false, "error": "No scene currently open"}
	
	var node = edited_scene.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: %s" % node_path}
	
	if not node.has_method(method_name):
		return {"success": false, "error": "Method '%s' not found on node" % method_name}
	
	var result = node.callv(method_name, args)
	
	return {
		"success": true,
		"node_path": node_path,
		"method": method_name,
		"result": str(result)
	}


func get_runtime_stats() -> Dictionary:
	"""Get runtime performance statistics"""
	return {
		"success": true,
		"fps": Engine.get_frames_per_second(),
		"process_time": Performance.get_monitor(Performance.TIME_PROCESS),
		"physics_process_time": Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS),
		"objects_count": Performance.get_monitor(Performance.OBJECT_COUNT),
		"resources_count": Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT),
		"nodes_count": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"orphan_nodes": Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT),
		"memory_static": Performance.get_monitor(Performance.MEMORY_STATIC),
		"memory_dynamic": Performance.get_monitor(Performance.MEMORY_DYNAMIC),
		"memory_static_max": Performance.get_monitor(Performance.MEMORY_STATIC_MAX),
		"draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		"video_mem_used": Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED),
		"texture_mem_used": Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED),
		"physics_2d_active_objects": Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS),
		"physics_3d_active_objects": Performance.get_monitor(Performance.PHYSICS_3D_ACTIVE_OBJECTS)
	}


# ===== PLUGIN DETECTION =====

func get_installed_plugins() -> Dictionary:
	"""Get list of all installed plugins"""
	var plugins = []
	var plugins_dir = "res://addons/"
	
	var dir = DirAccess.open(plugins_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				var plugin_cfg_path = plugins_dir + file_name + "/plugin.cfg"
				if FileAccess.file_exists(plugin_cfg_path):
					var config = ConfigFile.new()
					var err = config.load(plugin_cfg_path)
					
					if err == OK:
						plugins.append({
							"name": config.get_value("plugin", "name", file_name),
							"description": config.get_value("plugin", "description", ""),
							"author": config.get_value("plugin", "author", ""),
							"version": config.get_value("plugin", "version", ""),
							"script": config.get_value("plugin", "script", ""),
							"folder": file_name,
							"enabled": EditorInterface.is_plugin_enabled(file_name) if editor_interface else false
						})
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	return {
		"success": true,
		"plugins": plugins,
		"count": plugins.size()
	}


func get_plugin_info(plugin_name: String) -> Dictionary:
	"""Get detailed information about a specific plugin"""
	var plugin_cfg_path = "res://addons/" + plugin_name + "/plugin.cfg"
	
	if not FileAccess.file_exists(plugin_cfg_path):
		return {
			"success": false,
			"error": "Plugin not found: %s" % plugin_name
		}
	
	var config = ConfigFile.new()
	var err = config.load(plugin_cfg_path)
	
	if err != OK:
		return {
			"success": false,
			"error": "Failed to load plugin config: %s" % error_string(err)
		}
	
	# Get all files in plugin directory
	var plugin_files = []
	var plugin_dir = "res://addons/" + plugin_name + "/"
	_scan_directory_recursive(plugin_dir, plugin_files)
	
	return {
		"success": true,
		"name": config.get_value("plugin", "name", plugin_name),
		"description": config.get_value("plugin", "description", ""),
		"author": config.get_value("plugin", "author", ""),
		"version": config.get_value("plugin", "version", ""),
		"script": config.get_value("plugin", "script", ""),
		"enabled": EditorInterface.is_plugin_enabled(plugin_name) if editor_interface else false,
		"files": plugin_files,
		"file_count": plugin_files.size()
	}


func _scan_directory_recursive(path: String, files: Array) -> void:
	"""Helper function to scan directory recursively"""
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name != "." and file_name != "..":
				var full_path = path + file_name
				if dir.current_is_dir():
					_scan_directory_recursive(full_path + "/", files)
				else:
					files.append(full_path)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()


# ===== AUTOMATED TESTING =====

func run_test_script(script_path: String) -> Dictionary:
	"""Execute a test script and return results"""
	if not FileAccess.file_exists(script_path):
		return {
			"success": false,
			"error": "Test script not found: %s" % script_path
		}
	
	var script = load(script_path)
	if not script:
		return {
			"success": false,
			"error": "Failed to load test script"
		}
	
	var test_instance = script.new()
	if not test_instance:
		return {
			"success": false,
			"error": "Failed to instantiate test script"
		}
	
	var results = {
		"success": true,
		"script": script_path,
		"tests_run": 0,
		"tests_passed": 0,
		"tests_failed": 0,
		"results": []
	}
	
	# Run all methods starting with "test_"
	for method in test_instance.get_method_list():
		if method.name.begins_with("test_"):
			results.tests_run += 1
			
			var test_result = {
				"name": method.name,
				"passed": false,
				"error": null
			}
			
			# Try to run the test
			var result = test_instance.call(method.name)
			if result == true or result == null:
				test_result.passed = true
				results.tests_passed += 1
			else:
				test_result.passed = false
				test_result.error = str(result)
				results.tests_failed += 1
			
			results.results.append(test_result)
	
	test_instance.free()
	
	return results


# ===== ASSET MANAGEMENT =====

func get_assets_by_type(asset_type: String) -> Dictionary:
	"""Get all assets of a specific type (texture, mesh, audio, etc.)"""
	var assets = []
	_scan_assets_recursive("res://", asset_type, assets)
	
	return {
		"success": true,
		"type": asset_type,
		"assets": assets,
		"count": assets.size()
	}


func _scan_assets_recursive(path: String, asset_type: String, assets: Array) -> void:
	"""Helper to scan for specific asset types"""
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name != "." and file_name != "..":
				var full_path = path + file_name
				
				if dir.current_is_dir():
					_scan_assets_recursive(full_path + "/", asset_type, assets)
				else:
					var extension = file_name.get_extension().to_lower()
					var matches = false
					
					match asset_type.to_lower():
						"texture", "image":
							matches = extension in ["png", "jpg", "jpeg", "svg", "webp", "bmp"]
						"mesh", "model", "3d":
							matches = extension in ["obj", "fbx", "gltf", "glb", "dae"]
						"audio", "sound":
							matches = extension in ["wav", "ogg", "mp3"]
						"script":
							matches = extension in ["gd", "cs"]
						"scene":
							matches = extension in ["tscn", "scn"]
						"material":
							matches = extension in ["tres", "res", "material"]
						"shader":
							matches = extension in ["gdshader", "shader"]
					
					if matches:
						assets.append({
							"path": full_path,
							"name": file_name,
							"extension": extension,
							"size": FileAccess.get_file_as_bytes(full_path).size() if FileAccess.file_exists(full_path) else 0
						})
			
			file_name = dir.get_next()
		
		dir.list_dir_end()


func get_asset_info(asset_path: String) -> Dictionary:
	"""Get detailed information about an asset"""
	if not FileAccess.file_exists(asset_path) and not ResourceLoader.exists(asset_path):
		return {
			"success": false,
			"error": "Asset not found: %s" % asset_path
		}
	
	var info = {
		"success": true,
		"path": asset_path,
		"exists": FileAccess.file_exists(asset_path),
		"can_load": ResourceLoader.exists(asset_path)
	}
	
	if FileAccess.file_exists(asset_path):
		info["size"] = FileAccess.get_file_as_bytes(asset_path).size()
		info["modified_time"] = FileAccess.get_modified_time(asset_path)
	
	if ResourceLoader.exists(asset_path):
		var resource = load(asset_path)
		if resource:
			info["resource_type"] = resource.get_class()
			info["resource_path"] = resource.resource_path
			
			# Type-specific information
			if resource is Texture2D:
				info["width"] = resource.get_width()
				info["height"] = resource.get_height()
			elif resource is AudioStream:
				info["length"] = resource.get_length()
			elif resource is PackedScene:
				var state = resource.get_state()
				info["node_count"] = state.get_node_count()
	
	return info
