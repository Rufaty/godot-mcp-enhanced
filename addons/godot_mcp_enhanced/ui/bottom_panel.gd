@tool
extends PanelContainer

signal config_changed(new_config: Dictionary)
signal server_restart_requested()

var current_config: Dictionary = {}

@onready var status_label = $MarginContainer/VBoxContainer/ServerStatus/StatusLabel
@onready var start_stop_button = $MarginContainer/VBoxContainer/ServerStatus/StartStopButton
@onready var config_text = $MarginContainer/VBoxContainer/ConfigSection/ConfigText
@onready var copy_config_button = $MarginContainer/VBoxContainer/ConfigSection/ConfigButtons/CopyConfigButton
@onready var edit_config_button = $MarginContainer/VBoxContainer/ConfigSection/ConfigButtons/EditConfigButton
@onready var docs_button = $MarginContainer/VBoxContainer/QuickLinks/DocsButton
@onready var github_button = $MarginContainer/VBoxContainer/QuickLinks/GitHubButton
@onready var windsurf_guide_button = $MarginContainer/VBoxContainer/QuickLinks/WindsurfGuideButton


func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	
	# Connect signals
	start_stop_button.pressed.connect(_on_start_stop_pressed)
	copy_config_button.pressed.connect(_on_copy_config_pressed)
	edit_config_button.pressed.connect(_on_edit_config_pressed)
	docs_button.pressed.connect(_on_docs_pressed)
	github_button.pressed.connect(_on_github_pressed)
	windsurf_guide_button.pressed.connect(_on_windsurf_guide_pressed)


func update_config_display(config: Dictionary) -> void:
	current_config = config
	config_text.text = JSON.stringify(config, "\t")


func update_server_status(is_running: bool) -> void:
	if is_running:
		status_label.text = "Running on port " + str(current_config.get("GDAI_MCP_SERVER_PORT", "3571"))
		status_label.modulate = Color.GREEN
		start_stop_button.text = "Stop Server"
	else:
		status_label.text = "Stopped"
		status_label.modulate = Color.RED
		start_stop_button.text = "Start Server"


func _on_start_stop_pressed() -> void:
	emit_signal("server_restart_requested")


func _on_copy_config_pressed() -> void:
	# Generate MCP server config for Windsurf
	var mcp_config = {
		"godot-mcp-enhanced": {
			"command": "python",
			"args": [
				"-m",
				"mcp_server"
			],
			"env": current_config
		}
	}
	
	DisplayServer.clipboard_set(JSON.stringify(mcp_config, "\t"))
	print("[MCP Enhanced] Configuration copied to clipboard")


func _on_edit_config_pressed() -> void:
	var config_path = ProjectSettings.globalize_path("res://godot_mcp_config.json")
	OS.shell_open(config_path)


func _on_docs_pressed() -> void:
	OS.shell_open("https://github.com/your-repo/godot-mcp-enhanced/docs")


func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/your-repo/godot-mcp-enhanced")


func _on_windsurf_guide_pressed() -> void:
	OS.shell_open("https://github.com/your-repo/godot-mcp-enhanced/docs/windsurf-setup.md")
