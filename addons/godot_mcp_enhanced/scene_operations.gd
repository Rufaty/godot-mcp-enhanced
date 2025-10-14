@tool
extends Node

var editor_interface: EditorInterface

signal scene_modified(scene_path: String)
signal node_added(node_path: String)
signal node_deleted(node_path: String)


func get_scene_tree() -> Dictionary:
	"""Get recursive tree view of all nodes in current scene"""
	var root = editor_interface.get_edited_scene_root()
	
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var tree_data = _build_node_tree(root)
	return {"success": true, "data": tree_data}


func _build_node_tree(node: Node, depth: int = 0) -> Dictionary:
	"""Recursively build node tree structure"""
	var node_data = {
		"name": node.name,
		"type": node.get_class(),
		"path": str(node.get_path()),
		"visible": node.get("visible") if "visible" in node else null,
		"script": node.get_script().resource_path if node.get_script() else null,
		"children": []
	}
	
	# Add position for 2D/3D nodes
	if node is Node2D:
		node_data["position"] = {"x": node.position.x, "y": node.position.y}
		node_data["rotation"] = node.rotation
		node_data["scale"] = {"x": node.scale.x, "y": node.scale.y}
	elif node is Node3D:
		var pos = node.position
		node_data["position"] = {"x": pos.x, "y": pos.y, "z": pos.z}
		var rot = node.rotation
		node_data["rotation"] = {"x": rot.x, "y": rot.y, "z": rot.z}
		var scl = node.scale
		node_data["scale"] = {"x": scl.x, "y": scl.y, "z": scl.z}
	
	# Add Control-specific properties
	if node is Control:
		node_data["size"] = {"x": node.size.x, "y": node.size.y}
		node_data["anchor_left"] = node.anchor_left
		node_data["anchor_top"] = node.anchor_top
		node_data["anchor_right"] = node.anchor_right
		node_data["anchor_bottom"] = node.anchor_bottom
	
	# Recursively add children
	for child in node.get_children():
		node_data["children"].append(_build_node_tree(child, depth + 1))
	
	return node_data


func get_compact_scene_tree() -> Dictionary:
	"""Get simplified scene tree for Windsurf live preview"""
	var root = editor_interface.get_edited_scene_root()
	
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var tree_data = _build_compact_node_tree(root)
	return {"success": true, "data": tree_data}


func _build_compact_node_tree(node: Node) -> Dictionary:
	"""Build compact tree with only essential info"""
	var data = {
		"name": node.name,
		"type": node.get_class(),
		"children": []
	}
	
	for child in node.get_children():
		data["children"].append(_build_compact_node_tree(child))
	
	return data


func get_scene_file_content() -> String:
	"""Get raw content of current scene file"""
	var current_scene = editor_interface.get_edited_scene_root()
	if not current_scene:
		return ""
	
	var scene_path = current_scene.scene_file_path
	if scene_path == "":
		return ""
	
	var file = FileAccess.open(scene_path, FileAccess.READ)
	if not file:
		return ""
	
	var content = file.get_as_text()
	file.close()
	return content


func create_scene(scene_path: String, root_type: String = "Node2D") -> Dictionary:
	"""Create a new scene with specified root node type"""
	if not scene_path.begins_with("res://"):
		scene_path = "res://" + scene_path
	
	if not scene_path.ends_with(".tscn"):
		scene_path += ".tscn"
	
	# Check if scene already exists
	if FileAccess.file_exists(scene_path):
		return {"success": false, "error": "Scene already exists: " + scene_path}
	
	# Create root node
	var root_node = _create_node_by_type(root_type)
	if not root_node:
		return {"success": false, "error": "Failed to create node of type: " + root_type}
	
	# Create packed scene
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(root_node)
	
	if result != OK:
		root_node.queue_free()
		return {"success": false, "error": "Failed to pack scene: " + error_string(result)}
	
	# Save scene
	var error = ResourceSaver.save(packed_scene, scene_path)
	root_node.queue_free()
	
	if error != OK:
		return {"success": false, "error": "Failed to save scene: " + error_string(error)}
	
	# Refresh filesystem
	editor_interface.get_resource_filesystem().scan()
	
	print("[Scene Operations] Created scene: ", scene_path)
	return {"success": true, "data": {"scene_path": scene_path}}


func open_scene(scene_path: String) -> Dictionary:
	"""Open a scene in the editor"""
	if not scene_path.begins_with("res://"):
		scene_path = "res://" + scene_path
	
	if not FileAccess.file_exists(scene_path):
		return {"success": false, "error": "Scene not found: " + scene_path}
	
	# open_scene_from_path returns void in Godot 4.x
	editor_interface.open_scene_from_path(scene_path)
	
	# Verify it opened by checking if current scene matches
	await Engine.get_main_loop().process_frame
	var current = editor_interface.get_edited_scene_root()
	if current and current.scene_file_path == scene_path:
		print("[Scene Operations] Opened scene: ", scene_path)
		return {"success": true, "data": {"scene_path": scene_path}}
	else:
		return {"success": false, "error": "Failed to open scene (could not verify)"}


func delete_scene(scene_path: String) -> Dictionary:
	"""Delete a scene file"""
	if not scene_path.begins_with("res://"):
		scene_path = "res://" + scene_path
	
	if not FileAccess.file_exists(scene_path):
		return {"success": false, "error": "Scene not found: " + scene_path}
	
	var dir = DirAccess.open("res://")
	var error = dir.remove(scene_path)
	
	if error != OK:
		return {"success": false, "error": "Failed to delete scene: " + error_string(error)}
	
	editor_interface.get_resource_filesystem().scan()
	
	print("[Scene Operations] Deleted scene: ", scene_path)
	return {"success": true, "data": {"scene_path": scene_path}}


func add_scene_as_child(scene_path: String, parent_node_path: String) -> Dictionary:
	"""Add a scene as a child node to parent"""
	if not scene_path.begins_with("res://"):
		scene_path = "res://" + scene_path
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	# Get parent node
	var parent = root.get_node_or_null(parent_node_path) if parent_node_path else root
	if not parent:
		return {"success": false, "error": "Parent node not found: " + parent_node_path}
	
	# Load scene
	var scene = load(scene_path)
	if not scene:
		return {"success": false, "error": "Failed to load scene: " + scene_path}
	
	var instance = scene.instantiate()
	parent.add_child(instance)
	instance.owner = root
	
	emit_signal("node_added", str(instance.get_path()))
	print("[Scene Operations] Added scene as child: ", scene_path)
	
	return {"success": true, "data": {"node_path": str(instance.get_path())}}


func play_scene(scene_path: String = "") -> Dictionary:
	"""Play scene in Godot"""
	if scene_path != "" and not scene_path.begins_with("res://"):
		scene_path = "res://" + scene_path
	
	if scene_path != "":
		editor_interface.play_custom_scene(scene_path)
	else:
		editor_interface.play_current_scene()
	
	print("[Scene Operations] Playing scene: ", scene_path if scene_path else "current")
	return {"success": true}


func stop_running_scene() -> Dictionary:
	"""Stop the currently running scene"""
	editor_interface.stop_playing_scene()
	print("[Scene Operations] Stopped running scene")
	return {"success": true}


func add_node(params: Dictionary) -> Dictionary:
	"""Add a node to the current scene"""
	var node_type = params.get("node_type", "")
	var node_name = params.get("node_name", "")
	var parent_path = params.get("parent_node_path", "")
	var properties = params.get("properties", {})
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	# Get parent node
	var parent = root.get_node_or_null(parent_path) if parent_path else root
	if not parent:
		return {"success": false, "error": "Parent node not found: " + parent_path}
	
	# Create node
	var new_node = _create_node_by_type(node_type)
	if not new_node:
		return {"success": false, "error": "Failed to create node of type: " + node_type}
	
	new_node.name = node_name
	parent.add_child(new_node)
	new_node.owner = root
	
	# Set properties
	for prop_name in properties:
		if prop_name in new_node:
			new_node.set(prop_name, properties[prop_name])
	
	emit_signal("node_added", str(new_node.get_path()))
	print("[Scene Operations] Added node: ", new_node.get_path())
	
	return {"success": true, "data": {"node_path": str(new_node.get_path())}}


func delete_node(params: Dictionary) -> Dictionary:
	"""Delete a node from the scene"""
	var node_path = params.get("node_path", "")
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var node = root.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: " + node_path}
	
	if node == root:
		return {"success": false, "error": "Cannot delete root node"}
	
	emit_signal("node_deleted", node_path)
	node.queue_free()
	
	print("[Scene Operations] Deleted node: ", node_path)
	return {"success": true}


func duplicate_node(params: Dictionary) -> Dictionary:
	"""Duplicate an existing node"""
	var node_path = params.get("node_path", "")
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var node = root.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: " + node_path}
	
	var duplicate = node.duplicate(DUPLICATE_USE_INSTANTIATION)
	node.get_parent().add_child(duplicate)
	duplicate.owner = root
	
	emit_signal("node_added", str(duplicate.get_path()))
	print("[Scene Operations] Duplicated node: ", node_path)
	
	return {"success": true, "data": {"node_path": str(duplicate.get_path())}}


func move_node(params: Dictionary) -> Dictionary:
	"""Move a node to a different parent"""
	var node_path = params.get("node_path", "")
	var new_parent_path = params.get("new_parent_path", "")
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var node = root.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: " + node_path}
	
	var new_parent = root.get_node_or_null(new_parent_path)
	if not new_parent:
		return {"success": false, "error": "New parent not found: " + new_parent_path}
	
	node.reparent(new_parent)
	
	print("[Scene Operations] Moved node: ", node_path, " to ", new_parent_path)
	return {"success": true, "data": {"node_path": str(node.get_path())}}


func update_property(params: Dictionary) -> Dictionary:
	"""Update a property of a node"""
	var node_path = params.get("node_path", "")
	var property_name = params.get("property", "")
	var property_value = params.get("value")
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var node = root.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: " + node_path}
	
	if not property_name in node:
		return {"success": false, "error": "Property not found: " + property_name}
	
	node.set(property_name, property_value)
	
	emit_signal("scene_modified", "")
	print("[Scene Operations] Updated property: ", node_path, ".", property_name)
	
	return {"success": true}


func add_resource(params: Dictionary) -> Dictionary:
	"""Add a resource to a node property"""
	var node_path = params.get("node_path", "")
	var resource_type = params.get("resource_type", "")
	var property_name = params.get("property", "")
	var resource_properties = params.get("resource_properties", {})
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var node = root.get_node_or_null(node_path)
	if not node:
		return {"success": false, "error": "Node not found: " + node_path}
	
	# Create resource
	var resource = ClassDB.instantiate(resource_type)
	if not resource:
		return {"success": false, "error": "Failed to create resource of type: " + resource_type}
	
	# Set resource properties
	for prop in resource_properties:
		if prop in resource:
			resource.set(prop, resource_properties[prop])
	
	# Assign to node
	node.set(property_name, resource)
	
	emit_signal("scene_modified", "")
	print("[Scene Operations] Added resource: ", resource_type, " to ", node_path)
	
	return {"success": true}


func set_anchor_preset(params: Dictionary) -> Dictionary:
	"""Set anchor preset for Control node"""
	var node_path = params.get("node_path", "")
	var preset = params.get("preset", "top_left")
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var node = root.get_node_or_null(node_path)
	if not node or not node is Control:
		return {"success": false, "error": "Node is not a Control: " + node_path}
	
	var preset_value = _get_anchor_preset_value(preset)
	node.set_anchors_preset(preset_value)
	
	print("[Scene Operations] Set anchor preset: ", preset, " for ", node_path)
	return {"success": true}


func set_anchor_values(params: Dictionary) -> Dictionary:
	"""Set precise anchor values for Control node"""
	var node_path = params.get("node_path", "")
	
	var root = editor_interface.get_edited_scene_root()
	if not root:
		return {"success": false, "error": "No scene currently open"}
	
	var node = root.get_node_or_null(node_path)
	if not node or not node is Control:
		return {"success": false, "error": "Node is not a Control: " + node_path}
	
	if params.has("anchor_left"):
		node.anchor_left = params["anchor_left"]
	if params.has("anchor_top"):
		node.anchor_top = params["anchor_top"]
	if params.has("anchor_right"):
		node.anchor_right = params["anchor_right"]
	if params.has("anchor_bottom"):
		node.anchor_bottom = params["anchor_bottom"]
	
	print("[Scene Operations] Set anchor values for ", node_path)
	return {"success": true}


func _create_node_by_type(type_name: String) -> Node:
	"""Create a node instance by type name"""
	if ClassDB.class_exists(type_name):
		return ClassDB.instantiate(type_name)
	return null


func _get_anchor_preset_value(preset_name: String) -> int:
	"""Convert preset name to Control.LayoutPreset enum"""
	match preset_name:
		"top_left": return Control.PRESET_TOP_LEFT
		"top_right": return Control.PRESET_TOP_RIGHT
		"bottom_left": return Control.PRESET_BOTTOM_LEFT
		"bottom_right": return Control.PRESET_BOTTOM_RIGHT
		"center_left": return Control.PRESET_CENTER_LEFT
		"center_top": return Control.PRESET_CENTER_TOP
		"center_right": return Control.PRESET_CENTER_RIGHT
		"center_bottom": return Control.PRESET_CENTER_BOTTOM
		"center": return Control.PRESET_CENTER
		"left_wide": return Control.PRESET_LEFT_WIDE
		"top_wide": return Control.PRESET_TOP_WIDE
		"right_wide": return Control.PRESET_RIGHT_WIDE
		"bottom_wide": return Control.PRESET_BOTTOM_WIDE
		"vcenter_wide": return Control.PRESET_VCENTER_WIDE
		"hcenter_wide": return Control.PRESET_HCENTER_WIDE
		"full_rect": return Control.PRESET_FULL_RECT
		_: return Control.PRESET_TOP_LEFT
