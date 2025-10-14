@tool
extends Node

var editor_interface: EditorInterface

signal script_created(path: String)
signal script_modified(path: String)


func get_open_scripts() -> Dictionary:
	"""Get list of all open scripts with their contents"""
	var script_editor = editor_interface.get_script_editor()
	if not script_editor:
		return {"success": false, "error": "Script editor not available"}
	
	var open_scripts = script_editor.get_open_scripts()
	var scripts_data = []
	
	for script in open_scripts:
		if script is Script:
			var script_info = {
				"path": script.resource_path,
				"language": script.get_language().get_name() if script.get_language() else "Unknown",
				"content": script.source_code,
				"has_source_code": script.has_source_code()
			}
			scripts_data.append(script_info)
	
	return {"success": true, "data": scripts_data}


func get_open_script_names() -> Array:
	"""Get simplified list of open script paths (for Windsurf context)"""
	var script_editor = editor_interface.get_script_editor()
	if not script_editor:
		return []
	
	var open_scripts = script_editor.get_open_scripts()
	var names = []
	
	for script in open_scripts:
		if script is Script:
			names.append(script.resource_path)
	
	return names


func get_current_script_content() -> String:
	"""Get content of currently active script (for Windsurf live preview)"""
	var script_editor = editor_interface.get_script_editor()
	if not script_editor:
		return ""
	
	var current_script = script_editor.get_current_script()
	if current_script and current_script is Script:
		return current_script.source_code
	
	return ""


func view_script(params: Dictionary) -> Dictionary:
	"""View and activate a script in the editor"""
	var script_path = params.get("script_path", "")
	
	if not script_path.begins_with("res://"):
		script_path = "res://" + script_path
	
	if not FileAccess.file_exists(script_path):
		return {"success": false, "error": "Script not found: " + script_path}
	
	# Load script
	var script = load(script_path)
	if not script:
		return {"success": false, "error": "Failed to load script: " + script_path}
	
	# Open in script editor
	editor_interface.edit_script(script)
	editor_interface.set_main_screen_editor("Script")
	
	print("[Script Operations] Viewing script: ", script_path)
	return {"success": true, "data": {"path": script_path, "content": script.source_code}}


func create_script(params: Dictionary) -> Dictionary:
	"""Create a new GDScript file"""
	var script_path = params.get("script_path", "")
	var content = params.get("content", "extends Node\n\n\nfunc _ready() -> void:\n\tpass\n")
	var base_type = params.get("base_type", "Node")
	
	if not script_path.begins_with("res://"):
		script_path = "res://" + script_path
	
	if not script_path.ends_with(".gd"):
		script_path += ".gd"
	
	# Check if script already exists
	if FileAccess.file_exists(script_path):
		return {"success": false, "error": "Script already exists: " + script_path}
	
	# Create directory if needed
	var dir_path = script_path.get_base_dir()
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(dir_path):
		dir.make_dir_recursive(dir_path)
	
	# If content doesn't start with extends, add it
	if not content.begins_with("extends") and not content.begins_with("@tool"):
		content = "extends " + base_type + "\n\n" + content
	
	# Write script file
	var file = FileAccess.open(script_path, FileAccess.WRITE)
	if not file:
		return {"success": false, "error": "Failed to create script file: " + script_path}
	
	file.store_string(content)
	file.close()
	
	# Refresh filesystem
	editor_interface.get_resource_filesystem().scan()
	
	emit_signal("script_created", script_path)
	print("[Script Operations] Created script: ", script_path)
	
	return {"success": true, "data": {"path": script_path}}


func attach_script(params: Dictionary) -> Dictionary:
	"""Attach a script to a node"""
	var node_path = params.get("node_path", "")
	var script_path = params.get("script_path", "")
	
	if not script_path.begins_with("res://"):
		script_path = "res://" + script_path
	
	# Get current scene root
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	# Get target node
	var node = root.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: " + node_path}
	
	# Check if script exists
	if not FileAccess.file_exists(script_path):
		return {"success": false, "error": "Script not found: " + script_path}
	
	# Load and attach script
	var script = load(script_path)
	if not script:
		return {"success": false, "error": "Failed to load script: " + script_path}
	
	node.set_script(script)
	
	print("[Script Operations] Attached script to node: ", node_path)
	return {"success": true, "data": {"node_path": node_path, "script_path": script_path}}


func edit_file(params: Dictionary) -> Dictionary:
	"""Edit a file using find and replace"""
	var file_path = params.get("file_path", "")
	var find_text = params.get("find", "")
	var replace_text = params.get("replace", "")
	var regex_mode = params.get("regex", false)
	
	if not file_path.begins_with("res://"):
		file_path = "res://" + file_path
	
	if not FileAccess.file_exists(file_path):
		return {"success": false, "error": "File not found: " + file_path}
	
	# Read file
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return {"success": false, "error": "Failed to open file: " + file_path}
	
	var content = file.get_as_text()
	file.close()
	
	# Perform replacement
	var new_content = content
	var replacements = 0
	
	if regex_mode:
		var regex = RegEx.new()
		var compile_error = regex.compile(find_text)
		if compile_error != OK:
			return {"success": false, "error": "Invalid regex pattern: " + find_text}
		
		var matches = regex.search_all(content)
		replacements = matches.size()
		new_content = regex.sub(content, replace_text, true)
	else:
		replacements = content.count(find_text)
		new_content = content.replace(find_text, replace_text)
	
	# Write modified content
	file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		return {"success": false, "error": "Failed to write file: " + file_path}
	
	file.store_string(new_content)
	file.close()
	
	# Refresh filesystem
	editor_interface.get_resource_filesystem().scan()
	
	emit_signal("script_modified", file_path)
	print("[Script Operations] Edited file: ", file_path, " (", replacements, " replacements)")
	
	return {"success": true, "data": {"replacements": replacements, "path": file_path}}


func execute_editor_script(code: String) -> Dictionary:
	"""Execute arbitrary GDScript code in the editor context"""
	if code.strip_edges() == "":
		return {"success": false, "error": "Empty code provided"}
	
	# Create a temporary script
	var script = GDScript.new()
	script.source_code = """
extends Node

func execute():
	""" + code.indent("\t") + """
	return {"success": true, "message": "Code executed"}
"""
	
	var error = script.reload()
	if error != OK:
		return {"success": false, "error": "Script compilation failed: " + error_string(error)}
	
	# Create instance and execute
	var instance = script.new()
	if not instance:
		return {"success": false, "error": "Failed to create script instance"}
	
	var result = null
	if instance.has_method("execute"):
		result = instance.call("execute")
	
	instance.free()
	
	print("[Script Operations] Executed editor script")
	return result if result else {"success": true, "message": "Code executed"}


func validate_gdscript_syntax(code: String) -> Dictionary:
	"""Validate GDScript syntax without execution (Windsurf feature)"""
	var script = GDScript.new()
	script.source_code = code
	
	var error = script.reload()
	
	if error != OK:
		return {
			"success": false,
			"valid": false,
			"error": error_string(error)
		}
	
	return {
		"success": true,
		"valid": true,
		"message": "Syntax is valid"
	}


func get_script_methods(script_path: String) -> Dictionary:
	"""Get list of methods defined in a script (Windsurf feature for context)"""
	if not script_path.begins_with("res://"):
		script_path = "res://" + script_path
	
	if not FileAccess.file_exists(script_path):
		return {"success": false, "error": "Script not found: " + script_path}
	
	var script = load(script_path)
	if not script or not script is Script:
		return {"success": false, "error": "Not a valid script: " + script_path}
	
	var methods = []
	for method in script.get_script_method_list():
		methods.append({
			"name": method.name,
			"args": method.args,
			"return_type": method.return if "return" in method else null
		})
	
	return {"success": true, "data": methods}


func get_script_properties(script_path: String) -> Dictionary:
	"""Get list of properties defined in a script"""
	if not script_path.begins_with("res://"):
		script_path = "res://" + script_path
	
	if not FileAccess.file_exists(script_path):
		return {"success": false, "error": "Script not found: " + script_path}
	
	var script = load(script_path)
	if not script or not script is Script:
		return {"success": false, "error": "Not a valid script: " + script_path}
	
	var properties = []
	for prop in script.get_script_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			properties.append({
				"name": prop.name,
				"type": prop.type,
				"hint": prop.hint
			})
	
	return {"success": true, "data": properties}


func format_gdscript(code: String) -> Dictionary:
	"""Basic GDScript formatting (Windsurf feature)"""
	# Simple formatting rules
	var lines = code.split("\n")
	var formatted_lines = []
	var indent_level = 0
	
	for line in lines:
		var trimmed = line.strip_edges()
		
		# Decrease indent for closing braces, end statements
		if trimmed.begins_with("}") or trimmed.begins_with("return") or trimmed.begins_with("pass"):
			indent_level = max(0, indent_level - 1)
		
		# Add indentation
		var formatted_line = "\t".repeat(indent_level) + trimmed
		formatted_lines.append(formatted_line)
		
		# Increase indent for opening statements
		if trimmed.ends_with(":") or trimmed.ends_with("{"):
			indent_level += 1
	
	var formatted_code = "\n".join(formatted_lines)
	
	return {"success": true, "data": {"formatted_code": formatted_code}}
