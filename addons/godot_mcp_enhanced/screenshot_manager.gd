@tool
extends Node

var screenshot_dir: String = "user://mcp_screenshots/"
var auto_capture_enabled: bool = true
var last_screenshot_time: int = 0
var min_screenshot_interval: int = 1000  # milliseconds

signal screenshot_captured(path: String, base64_data: String)


func _ready() -> void:
	# Ensure screenshot directory exists
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists("mcp_screenshots"):
		dir.make_dir("mcp_screenshots")
	
	print("[Screenshot Manager] Initialized, directory: ", screenshot_dir)


func capture_editor_screenshot() -> String:
	"""Capture the entire Godot editor window and return base64-encoded PNG"""
	var current_time = Time.get_ticks_msec()
	
	# Throttle screenshots to prevent spam
	if current_time - last_screenshot_time < min_screenshot_interval:
		push_warning("[Screenshot Manager] Throttling: Too soon since last screenshot")
		return _get_cached_screenshot()
	
	last_screenshot_time = current_time
	
	# Note: Editor window screenshot is not directly available in Godot 4.x
	# We capture the main viewport instead, which shows the 3D/2D editor view
	# For full editor window capture, external tools would be needed
	var viewport = Engine.get_main_loop().root
	if not viewport:
		push_error("[Screenshot Manager] Failed to get root viewport")
		return ""
	
	var img = viewport.get_texture().get_image()
	
	if img == null or img.is_empty():
		push_error("[Screenshot Manager] Failed to capture editor screenshot")
		return ""
	
	# Save to file
	var timestamp = Time.get_unix_time_from_system()
	var filename = "editor_%d.png" % timestamp
	var file_path = screenshot_dir + filename
	
	var error = img.save_png(file_path)
	if error != OK:
		push_error("[Screenshot Manager] Failed to save screenshot: ", error_string(error))
		return ""
	
	# Convert to base64
	var base64_data = _image_to_base64(img)
	
	emit_signal("screenshot_captured", file_path, base64_data)
	print("[Screenshot Manager] Editor screenshot captured: ", file_path)
	
	return base64_data


func capture_running_scene_screenshot() -> String:
	"""Capture the running game window and return base64-encoded PNG"""
	# For running scene, we capture from the main viewport
	
	var current_time = Time.get_ticks_msec()
	
	if current_time - last_screenshot_time < min_screenshot_interval:
		push_warning("[Screenshot Manager] Throttling: Too soon since last screenshot")
		return _get_cached_screenshot()
	
	last_screenshot_time = current_time
	
	# Get the main viewport which contains the running scene
	var viewport = Engine.get_main_loop().root
	if not viewport:
		push_error("[Screenshot Manager] Failed to get root viewport")
		return ""
	
	var img = viewport.get_texture().get_image()
	
	if img == null or img.is_empty():
		push_error("[Screenshot Manager] Failed to capture running scene screenshot")
		return ""
	
	# Save to file
	var timestamp = Time.get_unix_time_from_system()
	var filename = "running_scene_%d.png" % timestamp
	var file_path = screenshot_dir + filename
	
	var error = img.save_png(file_path)
	if error != OK:
		push_error("[Screenshot Manager] Failed to save screenshot: ", error_string(error))
		return ""
	
	# Convert to base64
	var base64_data = _image_to_base64(img)
	
	emit_signal("screenshot_captured", file_path, base64_data)
	print("[Screenshot Manager] Running scene screenshot captured: ", file_path)
	
	return base64_data


func capture_viewport_screenshot(viewport: Viewport) -> String:
	"""Capture a specific viewport and return base64-encoded PNG"""
	if not viewport:
		push_error("[Screenshot Manager] Invalid viewport provided")
		return ""
	
	var img = viewport.get_texture().get_image()
	
	if img == null or img.is_empty():
		push_error("[Screenshot Manager] Failed to capture viewport screenshot")
		return ""
	
	# Save to file
	var timestamp = Time.get_unix_time_from_system()
	var filename = "viewport_%d.png" % timestamp
	var file_path = screenshot_dir + filename
	
	var error = img.save_png(file_path)
	if error != OK:
		push_error("[Screenshot Manager] Failed to save screenshot: ", error_string(error))
		return ""
	
	# Convert to base64
	var base64_data = _image_to_base64(img)
	
	emit_signal("screenshot_captured", file_path, base64_data)
	print("[Screenshot Manager] Viewport screenshot captured: ", file_path)
	
	return base64_data


func auto_capture_on_scene_change(scene_root: Node) -> void:
	"""Automatically capture screenshot when scene changes (Windsurf feature)"""
	if not auto_capture_enabled:
		return
	
	print("[Screenshot Manager] Auto-capturing on scene change: ", scene_root.name if scene_root else "null")
	capture_editor_screenshot()


func auto_capture_on_error() -> void:
	"""Automatically capture screenshot when error occurs (Windsurf feature)"""
	if not auto_capture_enabled:
		return
	
	print("[Screenshot Manager] Auto-capturing on error")
	capture_editor_screenshot()


func _image_to_base64(img: Image) -> String:
	"""Convert Image to base64-encoded PNG string"""
	if img == null or img.is_empty():
		return ""
	
	# Save to buffer
	var buffer = img.save_png_to_buffer()
	if buffer.size() == 0:
		push_error("[Screenshot Manager] Failed to convert image to PNG buffer")
		return ""
	
	# Encode to base64
	var base64 = Marshalls.raw_to_base64(buffer)
	return base64


func _get_cached_screenshot() -> String:
	"""Return the most recent screenshot from disk if available"""
	var dir = DirAccess.open(screenshot_dir)
	if not dir:
		return ""
	
	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			files.append(file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	if files.size() == 0:
		return ""
	
	# Sort by timestamp (filename contains timestamp)
	files.sort()
	var latest_file = files[-1]
	
	# Load and convert to base64
	var img = Image.load_from_file(screenshot_dir + latest_file)
	if img:
		return _image_to_base64(img)
	
	return ""


func clear_old_screenshots(max_age_seconds: int = 3600) -> void:
	"""Clean up screenshots older than specified age"""
	var dir = DirAccess.open(screenshot_dir)
	if not dir:
		return
	
	var current_time = Time.get_unix_time_from_system()
	var deleted_count = 0
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			var full_path = screenshot_dir + file_name
			var modified_time = FileAccess.get_modified_time(full_path)
			
			if current_time - modified_time > max_age_seconds:
				dir.remove(file_name)
				deleted_count += 1
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	if deleted_count > 0:
		print("[Screenshot Manager] Cleaned up %d old screenshots" % deleted_count)


func set_auto_capture(enabled: bool) -> void:
	auto_capture_enabled = enabled
	print("[Screenshot Manager] Auto-capture %s" % ("enabled" if enabled else "disabled"))
