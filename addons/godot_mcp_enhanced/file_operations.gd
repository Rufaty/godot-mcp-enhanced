@tool
extends Node

signal file_system_changed()


## Normalizes a project path and refuses anything that escapes res://.
## Returns an empty string when the path is unsafe.
func _safe_project_path(raw_path: String) -> String:
	var path := raw_path.strip_edges()
	if path.is_empty():
		return ""
	if not path.begins_with("res://"):
		path = "res://" + path
	# simplify_path collapses ".." and "." segments; if any survive, or the
	# result no longer sits under res://, reject it.
	path = path.simplify_path()
	if not path.begins_with("res://") or ".." in path:
		return ""
	return path


## Removes Godot sidecar files (.uid since 4.4, .import for imported assets)
## that belong to a deleted file. Leaving them behind produces
## "invalid UID" warnings on the next editor start.
func _remove_sidecars(file_path: String) -> Array:
	var removed := []
	var dir = DirAccess.open("res://")
	for suffix in [".uid", ".import"]:
		var sidecar: String = file_path + suffix
		if FileAccess.file_exists(sidecar):
			if dir.remove(sidecar) == OK:
				removed.append(sidecar)
	return removed


## Ask the editor to reimport specific assets. Wraps
## EditorFileSystem.reimport_files, which is how the 4.x import
## pipeline refreshes textures, audio, and models after external edits.
func reimport_assets(paths: Array) -> Dictionary:
	var safe_paths := PackedStringArray()
	for p in paths:
		var safe := _safe_project_path(str(p))
		if safe.is_empty():
			return {"success": false, "error": "Unsafe or invalid path: " + str(p)}
		if not FileAccess.file_exists(safe):
			return {"success": false, "error": "File not found: " + safe}
		safe_paths.append(safe)
	
	if safe_paths.is_empty():
		return {"success": false, "error": "No paths given"}
	
	var fs := EditorInterface.get_resource_filesystem()
	fs.reimport_files(safe_paths)
	return {"success": true, "data": {"reimported": safe_paths}}


## Reads the .import sidecar of an asset so a client can inspect importer
## type and settings without parsing the file itself.
func get_import_info(asset_path: String) -> Dictionary:
	var safe := _safe_project_path(asset_path)
	if safe.is_empty():
		return {"success": false, "error": "Unsafe or invalid path: " + asset_path}
	
	var import_path := safe + ".import"
	if not FileAccess.file_exists(import_path):
		return {"success": false, "error": "No .import sidecar for " + safe + " (not an imported asset)"}
	
	var cfg := ConfigFile.new()
	if cfg.load(import_path) != OK:
		return {"success": false, "error": "Could not parse " + import_path}
	
	var info := {
		"path": safe,
		"importer": cfg.get_value("remap", "importer", ""),
		"type": cfg.get_value("remap", "type", ""),
		"uid": cfg.get_value("remap", "uid", ""),
		"params": {}
	}
	if cfg.has_section("params"):
		for key in cfg.get_section_keys("params"):
			info["params"][key] = cfg.get_value("params", key)
	return {"success": true, "data": info}


func get_filesystem_tree(path: String = "res://", filters: Array = []) -> Dictionary:
	"""Get recursive tree view of project filesystem"""
	var tree = _build_directory_tree(path, filters)
	return tree


func _build_directory_tree(path: String, filters: Array, depth: int = 0, max_depth: int = 10) -> Dictionary:
	"""Recursively build directory tree"""
	if depth > max_depth:
		return {"name": "...", "type": "truncated"}
	
	var dir = DirAccess.open(path)
	if not dir:
		return {"error": "Cannot open directory: " + path}
	
	var tree = {
		"name": path.get_file() if path != "res://" else "Project Root",
		"path": path,
		"type": "directory",
		"children": []
	}
	
	# List files and directories
	var items = []
	dir.list_dir_begin()
	var item_name = dir.get_next()
	
	while item_name != "":
		# Skip hidden files and .godot directory
		if not item_name.begins_with("."):
			var item_path = path.path_join(item_name)
			var is_dir = dir.current_is_dir()
			
			# Apply filters
			if filters.size() > 0 and not is_dir:
				var passes_filter = false
				for filter in filters:
					if item_name.ends_with(filter):
						passes_filter = true
						break
				if not passes_filter:
					item_name = dir.get_next()
					continue
			
			if is_dir:
				items.append({
					"name": item_name,
					"path": item_path,
					"type": "directory",
					"is_dir": true
				})
			else:
				var file_size = 0
				var f = FileAccess.open(item_path, FileAccess.READ)
				if f:
					file_size = f.get_length()
					f.close()
				items.append({
					"name": item_name,
					"path": item_path,
					"type": _get_file_type(item_name),
					"size": file_size,
					"is_dir": false
				})
		
		item_name = dir.get_next()
	
	dir.list_dir_end()
	
	# Sort: directories first, then files
	items.sort_custom(func(a, b): 
		if a.is_dir and not b.is_dir:
			return true
		elif not a.is_dir and b.is_dir:
			return false
		else:
			return a.name < b.name
	)
	
	# Build children
	for item in items:
		if item.is_dir:
			tree["children"].append(_build_directory_tree(item.path, filters, depth + 1, max_depth))
		else:
			tree["children"].append({
				"name": item.name,
				"path": item.path,
				"type": item.type,
				"size": item.size
			})
	
	return tree


func get_quick_project_overview() -> Dictionary:
	"""Get quick overview of project structure (Windsurf feature)"""
	var overview = {
		"total_scenes": 0,
		"total_scripts": 0,
		"total_assets": 0,
		"directories": []
	}
	
	_count_project_files("res://", overview)
	
	return overview


func _count_project_files(path: String, counts: Dictionary) -> void:
	"""Recursively count project files"""
	var dir = DirAccess.open(path)
	if not dir:
		return
	
	dir.list_dir_begin()
	var item_name = dir.get_next()
	
	while item_name != "":
		if not item_name.begins_with("."):
			var item_path = path.path_join(item_name)
			
			if dir.current_is_dir():
				counts["directories"].append(item_name)
				_count_project_files(item_path, counts)
			else:
				if item_name.ends_with(".tscn") or item_name.ends_with(".scn"):
					counts["total_scenes"] += 1
				elif item_name.ends_with(".gd") or item_name.ends_with(".cs"):
					counts["total_scripts"] += 1
				else:
					counts["total_assets"] += 1
		
		item_name = dir.get_next()
	
	dir.list_dir_end()


func search_files(query: String, search_path: String = "res://") -> Array:
	"""Fuzzy search for files matching query"""
	var results = []
	_search_files_recursive(search_path, query.to_lower(), results)
	
	# Sort by relevance (exact matches first, then contains)
	results.sort_custom(func(a, b):
		var a_name = a.name.to_lower()
		var b_name = b.name.to_lower()
		var query_lower = query.to_lower()
		
		var a_exact = a_name == query_lower
		var b_exact = b_name == query_lower
		
		if a_exact and not b_exact:
			return true
		elif b_exact and not a_exact:
			return false
		
		var a_starts = a_name.begins_with(query_lower)
		var b_starts = b_name.begins_with(query_lower)
		
		if a_starts and not b_starts:
			return true
		elif b_starts and not a_starts:
			return false
		
		return a_name < b_name
	)
	
	return results


func _search_files_recursive(path: String, query: String, results: Array, max_results: int = 50) -> void:
	"""Recursively search files"""
	if results.size() >= max_results:
		return
	
	var dir = DirAccess.open(path)
	if not dir:
		return
	
	dir.list_dir_begin()
	var item_name = dir.get_next()
	
	while item_name != "" and results.size() < max_results:
		if not item_name.begins_with("."):
			var item_path = path.path_join(item_name)
			
			if dir.current_is_dir():
				_search_files_recursive(item_path, query, results, max_results)
			else:
				# Fuzzy match
				if _fuzzy_match(item_name.to_lower(), query):
					results.append({
						"name": item_name,
						"path": item_path,
						"type": _get_file_type(item_name),
						"directory": path
					})
		
		item_name = dir.get_next()
	
	dir.list_dir_end()


func _fuzzy_match(text: String, pattern: String) -> bool:
	"""Simple fuzzy matching"""
	if pattern in text:
		return true
	
	# Check if pattern characters appear in order
	var pattern_idx = 0
	for i in range(text.length()):
		if pattern_idx < pattern.length() and text[i] == pattern[pattern_idx]:
			pattern_idx += 1
	
	return pattern_idx == pattern.length()


func _get_file_type(filename: String) -> String:
	"""Get file type from extension"""
	var ext = filename.get_extension().to_lower()
	
	match ext:
		"tscn", "scn": return "scene"
		"gd": return "gdscript"
		"cs": return "csharp"
		"tres", "res": return "resource"
		"png", "jpg", "jpeg", "webp", "svg": return "texture"
		"wav", "ogg", "mp3": return "audio"
		"glb", "gltf", "obj", "fbx": return "3d_model"
		"gdshader", "shader": return "shader"
		"txt", "md", "json", "cfg": return "text"
		_: return "file"


func uid_to_project_path(uid: String) -> String:
	"""Convert Godot UID to project path"""
	if not uid.begins_with("uid://"):
		return ""
	
	# Use ResourceLoader to convert UID to path
	var path = ResourceUID.get_id_path(ResourceUID.text_to_id(uid))
	return path


func project_path_to_uid(path: String) -> String:
	"""Convert project path to Godot UID"""
	if not path.begins_with("res://"):
		path = "res://" + path
	
	if not FileAccess.file_exists(path):
		return ""
	
	# Get UID for the resource
	var uid_int = ResourceLoader.get_resource_uid(path)
	if uid_int == ResourceUID.INVALID_ID:
		return ""
	
	return ResourceUID.id_to_text(uid_int)


func get_file_content(file_path: String) -> Dictionary:
	"""Get content of a file"""
	file_path = _safe_project_path(file_path)
	if file_path.is_empty():
		return {"success": false, "error": "Unsafe or invalid path"}
	
	if not FileAccess.file_exists(file_path):
		return {"success": false, "error": "File not found: " + file_path}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return {"success": false, "error": "Failed to open file: " + file_path}
	
	var content = file.get_as_text()
	file.close()
	
	return {"success": true, "data": {"path": file_path, "content": content}}


func create_directory(dir_path: String) -> Dictionary:
	"""Create a directory"""
	dir_path = _safe_project_path(dir_path)
	if dir_path.is_empty():
		return {"success": false, "error": "Unsafe or invalid path"}
	
	var dir = DirAccess.open("res://")
	if dir.dir_exists(dir_path):
		return {"success": false, "error": "Directory already exists: " + dir_path}
	
	var error = dir.make_dir_recursive(dir_path)
	if error != OK:
		return {"success": false, "error": "Failed to create directory: " + error_string(error)}
	
	emit_signal("file_system_changed")
	return {"success": true, "data": {"path": dir_path}}


func delete_file(file_path: String) -> Dictionary:
	"""Delete a file plus its .uid/.import sidecars"""
	file_path = _safe_project_path(file_path)
	if file_path.is_empty():
		return {"success": false, "error": "Unsafe or invalid path"}
	
	if not FileAccess.file_exists(file_path):
		return {"success": false, "error": "File not found: " + file_path}
	
	var dir = DirAccess.open("res://")
	var error = dir.remove(file_path)
	
	if error != OK:
		return {"success": false, "error": "Failed to delete file: " + error_string(error)}
	
	var removed_sidecars := _remove_sidecars(file_path)
	
	emit_signal("file_system_changed")
	return {"success": true, "data": {"path": file_path, "removed_sidecars": removed_sidecars}}


func rename_file(old_path: String, new_path: String) -> Dictionary:
	"""Rename or move a file, carrying .uid/.import sidecars along"""
	old_path = _safe_project_path(old_path)
	new_path = _safe_project_path(new_path)
	if old_path.is_empty() or new_path.is_empty():
		return {"success": false, "error": "Unsafe or invalid path"}
	
	if not FileAccess.file_exists(old_path):
		return {"success": false, "error": "File not found: " + old_path}
	
	var dir = DirAccess.open("res://")
	var error = dir.rename(old_path, new_path)
	
	if error != OK:
		return {"success": false, "error": "Failed to rename file: " + error_string(error)}
	
	# Since Godot 4.4, scripts and shaders keep their identity through a .uid
	# sidecar. Moving the file without the sidecar breaks references.
	var moved_sidecars := []
	for suffix in [".uid", ".import"]:
		var old_sidecar: String = old_path + suffix
		if FileAccess.file_exists(old_sidecar):
			if dir.rename(old_sidecar, new_path + suffix) == OK:
				moved_sidecars.append(new_path + suffix)
	
	emit_signal("file_system_changed")
	return {"success": true, "data": {"old_path": old_path, "new_path": new_path, "moved_sidecars": moved_sidecars}}


func get_recent_files(count: int = 10) -> Array:
	"""Get recently modified files (Windsurf feature)"""
	var files = []
	_get_all_files("res://", files)
	
	# Sort by modification time
	files.sort_custom(func(a, b):
		return a.modified > b.modified
	)
	
	if files.size() > count:
		files.resize(count)
	
	return files


func _get_all_files(path: String, results: Array) -> void:
	"""Get all files recursively with metadata"""
	var dir = DirAccess.open(path)
	if not dir:
		return
	
	dir.list_dir_begin()
	var item_name = dir.get_next()
	
	while item_name != "":
		if not item_name.begins_with("."):
			var item_path = path.path_join(item_name)
			
			if dir.current_is_dir():
				_get_all_files(item_path, results)
			else:
				results.append({
					"name": item_name,
					"path": item_path,
					"type": _get_file_type(item_name),
					"modified": FileAccess.get_modified_time(item_path)
				})
		
		item_name = dir.get_next()
	
	dir.list_dir_end()


func analyze_project_dependencies() -> Dictionary:
	"""Analyze project dependencies (Windsurf feature for understanding codebase)"""
	var dependencies = {
		"scenes": {},
		"scripts": {},
		"resources": {}
	}
	
	# Scan all scene files for dependencies
	var scenes = []
	_find_files_by_extension("res://", ".tscn", scenes)
	
	for scene_path in scenes:
		var deps = _get_file_dependencies(scene_path)
		dependencies["scenes"][scene_path] = deps
	
	return {"success": true, "data": dependencies}


func _find_files_by_extension(path: String, extension: String, results: Array) -> void:
	"""Find all files with specific extension"""
	var dir = DirAccess.open(path)
	if not dir:
		return
	
	dir.list_dir_begin()
	var item_name = dir.get_next()
	
	while item_name != "":
		if not item_name.begins_with("."):
			var item_path = path.path_join(item_name)
			
			if dir.current_is_dir():
				_find_files_by_extension(item_path, extension, results)
			elif item_name.ends_with(extension):
				results.append(item_path)
		
		item_name = dir.get_next()
	
	dir.list_dir_end()


func _get_file_dependencies(file_path: String) -> Array:
	"""Get dependencies of a file"""
	var deps = []
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if not file:
		return deps
	
	var content = file.get_as_text()
	file.close()
	
	# Simple regex-based dependency detection
	# Look for res:// paths and uid:// references
	var regex_res = RegEx.new()
	regex_res.compile("res://[^\"\\s]+")
	
	var matches = regex_res.search_all(content)
	for match_obj in matches:
		var dep_path = match_obj.get_string()
		if not dep_path in deps:
			deps.append(dep_path)
	
	return deps


func get_installed_plugins() -> Dictionary:
	"""Get list of all installed plugins with their information"""
	var plugins = []
	var addons_path = "res://addons/"
	
	var dir = DirAccess.open(addons_path)
	if not dir:
		return {"success": false, "error": "Cannot access addons directory"}
	
	dir.list_dir_begin()
	var plugin_dir = dir.get_next()
	
	while plugin_dir != "":
		if dir.current_is_dir() and not plugin_dir.begins_with("."):
			var plugin_cfg_path = addons_path.path_join(plugin_dir).path_join("plugin.cfg")
			
			if FileAccess.file_exists(plugin_cfg_path):
				var plugin_info = _parse_plugin_cfg(plugin_cfg_path, plugin_dir)
				if plugin_info:
					plugins.append(plugin_info)
		
		plugin_dir = dir.get_next()
	
	dir.list_dir_end()
	
	return {"success": true, "data": {"plugins": plugins, "count": plugins.size()}}


func _parse_plugin_cfg(cfg_path: String, plugin_dir: String) -> Dictionary:
	"""Parse plugin.cfg file and extract information"""
	var config = ConfigFile.new()
	var err = config.load(cfg_path)
	
	if err != OK:
		return {}
	
	var plugin_info = {
		"directory": plugin_dir,
		"path": "res://addons/" + plugin_dir,
		"name": config.get_value("plugin", "name", plugin_dir),
		"description": config.get_value("plugin", "description", ""),
		"author": config.get_value("plugin", "author", ""),
		"version": config.get_value("plugin", "version", ""),
		"script": config.get_value("plugin", "script", ""),
		"enabled": EditorInterface.is_plugin_enabled(plugin_dir) if EditorInterface else false
	}
	
	return plugin_info
