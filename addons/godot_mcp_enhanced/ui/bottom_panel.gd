@tool
extends PanelContainer

signal config_changed(new_config: Dictionary)
signal server_restart_requested()

var current_config: Dictionary = {}
var request_count: int = 0
var last_request_time: float = 0.0

@onready var status_label = $MarginContainer/VBoxContainer/Header/StatusContainer/StatusLabel
@onready var status_indicator = $MarginContainer/VBoxContainer/Header/StatusContainer/StatusIndicator
@onready var restart_button = $MarginContainer/VBoxContainer/Header/ButtonsContainer/RestartButton
@onready var test_button = $MarginContainer/VBoxContainer/Header/ButtonsContainer/TestButton
@onready var port_label = $MarginContainer/VBoxContainer/InfoSection/PortInfo/PortLabel
@onready var requests_label = $MarginContainer/VBoxContainer/InfoSection/StatsInfo/RequestsLabel
@onready var uptime_label = $MarginContainer/VBoxContainer/InfoSection/StatsInfo/UptimeLabel
@onready var config_text = $MarginContainer/VBoxContainer/ConfigSection/ScrollContainer/ConfigText
@onready var copy_kiro_button = $MarginContainer/VBoxContainer/ConfigSection/ButtonsContainer/CopyKiroButton
@onready var copy_windsurf_button = $MarginContainer/VBoxContainer/ConfigSection/ButtonsContainer/CopyWindsurfButton
@onready var copy_cursor_button = $MarginContainer/VBoxContainer/ConfigSection/ButtonsContainer/CopyCursorButton
@onready var edit_config_button = $MarginContainer/VBoxContainer/ConfigSection/ButtonsContainer/EditConfigButton
@onready var docs_button = $MarginContainer/VBoxContainer/QuickLinks/DocsButton
@onready var github_button = $MarginContainer/VBoxContainer/QuickLinks/GitHubButton
@onready var kiro_guide_button = $MarginContainer/VBoxContainer/QuickLinks/KiroGuideButton
@onready var windsurf_guide_button = $MarginContainer/VBoxContainer/QuickLinks/WindsurfGuideButton
@onready var ai_instructions_button = $MarginContainer/VBoxContainer/QuickLinks/AIInstructionsButton

var start_time: float = 0.0


func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	
	start_time = Time.get_ticks_msec() / 1000.0
	
	# Connect signals
	restart_button.pressed.connect(_on_restart_pressed)
	test_button.pressed.connect(_on_test_pressed)
	copy_kiro_button.pressed.connect(_on_copy_kiro_pressed)
	copy_windsurf_button.pressed.connect(_on_copy_windsurf_pressed)
	copy_cursor_button.pressed.connect(_on_copy_cursor_pressed)
	edit_config_button.pressed.connect(_on_edit_config_pressed)
	docs_button.pressed.connect(_on_docs_pressed)
	github_button.pressed.connect(_on_github_pressed)
	kiro_guide_button.pressed.connect(_on_kiro_guide_pressed)
	windsurf_guide_button.pressed.connect(_on_windsurf_guide_pressed)
	ai_instructions_button.pressed.connect(_on_ai_instructions_pressed)
	
	# Start update timer
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_update_stats)
	add_child(timer)
	timer.start()


func update_config_display(config: Dictionary) -> void:
	current_config = config
	var formatted_config = JSON.stringify(config, "\t", false)
	config_text.text = formatted_config
	
	# Update port display
	var port = config.get("GDAI_MCP_SERVER_PORT", "3571")
	port_label.text = "Port: " + str(port)


func update_server_status(is_running: bool) -> void:
	if is_running:
		status_label.text = "● Server Running"
		status_label.modulate = Color(0.3, 1.0, 0.3)  # Bright green
		status_indicator.modulate = Color(0.3, 1.0, 0.3)
		restart_button.disabled = false
		test_button.disabled = false
	else:
		status_label.text = "● Server Stopped"
		status_label.modulate = Color(1.0, 0.3, 0.3)  # Bright red
		status_indicator.modulate = Color(1.0, 0.3, 0.3)
		restart_button.disabled = true
		test_button.disabled = true


func increment_request_count() -> void:
	request_count += 1
	last_request_time = Time.get_ticks_msec() / 1000.0
	_update_stats()


func _update_stats() -> void:
	# Update request count
	requests_label.text = "Requests: " + str(request_count)
	
	# Update uptime
	var uptime = Time.get_ticks_msec() / 1000.0 - start_time
	var hours = int(uptime / 3600)
	var minutes = int((uptime - hours * 3600) / 60)
	var seconds = int(uptime - hours * 3600 - minutes * 60)
	uptime_label.text = "Uptime: %02d:%02d:%02d" % [hours, minutes, seconds]


func _on_restart_pressed() -> void:
	print("[MCP Enhanced] Restarting server...")
	emit_signal("server_restart_requested")
	request_count = 0
	start_time = Time.get_ticks_msec() / 1000.0


func _on_test_pressed() -> void:
	print("[MCP Enhanced] Testing server connection...")
	var port = current_config.get("GDAI_MCP_SERVER_PORT", "3571")
	var url = "http://127.0.0.1:" + str(port) + "/project_info"
	print("[MCP Enhanced] Test URL: " + url)
	print("[MCP Enhanced] Try accessing this URL in your browser or with curl")
	OS.shell_open(url)


func _on_copy_kiro_pressed() -> void:
	var python_path = "path/to/python/.venv/Scripts/python.exe"  # User needs to update
	var cwd_path = "path/to/godot-mcp-enhanced/python"  # User needs to update
	
	var mcp_config = {
		"mcpServers": {
			"godot-mcp-enhanced": {
				"command": python_path,
				"args": ["-m", "mcp_server"],
				"cwd": cwd_path,
				"env": current_config
			}
		}
	}
	
	DisplayServer.clipboard_set(JSON.stringify(mcp_config, "\t", false))
	print("[MCP Enhanced] Kiro IDE configuration copied to clipboard!")
	print("[MCP Enhanced] Remember to update the 'command' and 'cwd' paths!")


func _on_copy_windsurf_pressed() -> void:
	var python_path = "path/to/python/.venv/Scripts/python.exe"
	var cwd_path = "path/to/godot-mcp-enhanced/python"
	
	var mcp_config = {
		"mcpServers": {
			"godot-mcp-enhanced": {
				"command": python_path,
				"args": ["-m", "mcp_server"],
				"cwd": cwd_path,
				"env": current_config
			}
		}
	}
	
	DisplayServer.clipboard_set(JSON.stringify(mcp_config, "\t", false))
	print("[MCP Enhanced] Windsurf configuration copied to clipboard!")
	print("[MCP Enhanced] Remember to update the 'command' and 'cwd' paths!")


func _on_copy_cursor_pressed() -> void:
	var python_path = "path/to/python/.venv/Scripts/python.exe"
	var cwd_path = "path/to/godot-mcp-enhanced/python"
	
	var mcp_config = {
		"mcpServers": {
			"godot-mcp-enhanced": {
				"command": python_path,
				"args": ["-m", "mcp_server"],
				"cwd": cwd_path,
				"env": current_config
			}
		}
	}
	
	DisplayServer.clipboard_set(JSON.stringify(mcp_config, "\t", false))
	print("[MCP Enhanced] Cursor configuration copied to clipboard!")
	print("[MCP Enhanced] Remember to update the 'command' and 'cwd' paths!")


func _on_edit_config_pressed() -> void:
	var config_path = ProjectSettings.globalize_path("res://godot_mcp_config.json")
	OS.shell_open(config_path)


func _on_docs_pressed() -> void:
	OS.shell_open("https://github.com/Rufaty/godot-mcp-enhanced")


func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/Rufaty/godot-mcp-enhanced")


func _on_kiro_guide_pressed() -> void:
	OS.shell_open("https://github.com/Rufaty/godot-mcp-enhanced/blob/main/docs/KIRO_SETUP.md")


func _on_windsurf_guide_pressed() -> void:
	OS.shell_open("https://github.com/Rufaty/godot-mcp-enhanced/blob/main/docs/WINDSURF_SETUP.md")


func _on_ai_instructions_pressed() -> void:
	OS.shell_open("https://github.com/Rufaty/godot-mcp-enhanced/blob/main/AI_INSTRUCTIONS.md")
