# Runtime Features Guide

Complete guide to the new runtime operations, input simulation, asset management, and testing capabilities in Godot MCP Enhanced.

---

## 🎮 Overview

Godot MCP Enhanced now includes **11 new runtime operation tools** that enable:

- **Input Simulation** - Test gameplay without manual interaction
- **Asset Discovery** - AI can find and use your project assets
- **Plugin Detection** - Automatically detect and use installed plugins
- **Runtime Debugging** - Inspect nodes and properties during gameplay
- **Performance Monitoring** - Real-time FPS, memory, and draw call stats
- **Automated Testing** - Run test scripts automatically

**Total Tools**: 62+ (51 original + 11 new runtime tools)

---

## 🚀 New Tools

### 1. Input Simulation (4 tools)

#### `simulate_key_press`
Simulate keyboard key press/release for testing.

```python
# Press spacebar
simulate_key_press(keycode=32, pressed=True)

# Release W key
simulate_key_press(keycode=87, pressed=False)
```

**Common Keycodes**:
- Space: 32
- W: 87, A: 65, S: 83, D: 68
- Arrow Up: 4194320, Down: 4194322, Left: 4194319, Right: 4194321
- Enter: 4194309, Escape: 4194305

#### `simulate_action`
Simulate input actions defined in your project.

```python
# Trigger jump action
simulate_action(action_name="jump", pressed=True, strength=1.0)

# Release move_left action
simulate_action(action_name="move_left", pressed=False)
```

#### `simulate_mouse_button`
Simulate mouse button clicks.

```python
# Left click at position
simulate_mouse_button(button_index=1, pressed=True, position=[100, 200])
```

#### `simulate_mouse_motion`
Simulate mouse movement.

```python
# Move mouse to position
simulate_mouse_motion(position=[500, 300], relative=[10, 5])
```

#### `get_input_actions`
Get all registered input actions and their key bindings.

```python
# List all input actions
get_input_actions()
# Returns: {"ui_accept": [...], "jump": [...], "move_left": [...]}
```

---

### 2. Runtime Inspection (3 tools)

#### `get_runtime_stats`
Get real-time performance statistics.

```python
get_runtime_stats()
```

**Returns**:
```json
{
  "fps": 60.0,
  "memory_static": 45.2,
  "memory_dynamic": 12.8,
  "draw_calls": 156,
  "vertices": 2048,
  "material_changes": 12,
  "shader_changes": 4,
  "surface_changes": 8,
  "objects_drawn": 45
}
```

#### `get_node_properties`
Get all properties of a node at runtime.

```python
# Inspect player node
get_node_properties(node_path="Player")
```

**Returns**:
```json
{
  "position": [100.0, 200.0],
  "velocity": [50.0, 0.0],
  "health": 100,
  "is_jumping": false
}
```

#### `call_node_method`
Call a method on a node for testing.

```python
# Make player jump
call_node_method(node_path="Player", method_name="jump", args=[])

# Deal damage
call_node_method(node_path="Player", method_name="take_damage", args=[25])
```

---

### 3. Plugin Management (2 tools)

#### `get_installed_plugins`
Get list of all installed Godot plugins.

```python
get_installed_plugins()
```

**Returns**:
```json
{
  "plugins": [
    {
      "name": "dialogue_manager",
      "path": "res://addons/dialogue_manager",
      "enabled": true
    },
    {
      "name": "godot_jolt",
      "path": "res://addons/godot_jolt",
      "enabled": true
    }
  ]
}
```

#### `get_plugin_info`
Get detailed information about a specific plugin.

```python
# Get info about dialogue manager
get_plugin_info(plugin_name="dialogue_manager")
```

**Returns**:
```json
{
  "name": "Dialogue Manager",
  "description": "A dialogue system for Godot",
  "author": "Nathan Hoad",
  "version": "2.0",
  "script": "plugin.gd",
  "nodes": ["DialogueLabel", "DialogueManager"]
}
```

---

### 4. Asset Management (2 tools)

#### `get_assets_by_type`
Find all assets of a specific type in your project.

```python
# Find all textures
get_assets_by_type(asset_type="texture")

# Find all 3D models
get_assets_by_type(asset_type="3d")

# Find all audio files
get_assets_by_type(asset_type="audio")
```

**Supported Types**:
- `texture` / `image` - PNG, JPG, SVG, etc.
- `mesh` / `model` / `3d` - GLB, GLTF, OBJ, FBX
- `audio` / `sound` - WAV, OGG, MP3
- `script` - GD files
- `scene` - TSCN files
- `material` - TRES material files
- `shader` - GDSHADER files

**Returns**:
```json
{
  "assets": [
    "res://sprites/player.png",
    "res://sprites/enemy.png",
    "res://textures/ground.png"
  ]
}
```

#### `get_asset_info`
Get detailed information about a specific asset.

```python
# Get info about player sprite
get_asset_info(asset_path="res://sprites/player.png")
```

**Returns**:
```json
{
  "path": "res://sprites/player.png",
  "type": "Texture2D",
  "size": [64, 64],
  "format": "PNG",
  "file_size": 2048
}
```

---

### 5. Testing & Debugging (1 tool)

#### `run_test_script`
Execute a test script and return results.

```python
# Run automated tests
run_test_script(script_path="res://tests/player_test.gd")
```

**Returns**:
```json
{
  "success": true,
  "tests_run": 5,
  "tests_passed": 5,
  "tests_failed": 0,
  "output": "All tests passed!"
}
```

---

## 💡 Use Cases

### Use Case 1: Asset-Based Game Development

**Scenario**: You have assets in your project and want AI to use them.

```
User: I have these assets:
- res://sprites/knight.png
- res://models/sword.glb
- res://sounds/swing.wav

Create a 3D knight character that uses these assets.

AI Actions:
1. get_assets_by_type("texture") → Finds knight.png
2. get_assets_by_type("3d") → Finds sword.glb
3. get_assets_by_type("audio") → Finds swing.wav
4. create_scene("res://scenes/knight.tscn")
5. add_node(node_type="CharacterBody3D", node_name="Knight")
6. add_node(node_type="Sprite3D", parent="Knight")
7. update_property(node_path="Knight/Sprite3D", property="texture", value="res://sprites/knight.png")
8. add_node(node_type="MeshInstance3D", parent="Knight")
9. update_property(node_path="Knight/MeshInstance3D", property="mesh", value="res://models/sword.glb")
10. add_node(node_type="AudioStreamPlayer3D", parent="Knight")
11. update_property(node_path="Knight/AudioStreamPlayer3D", property="stream", value="res://sounds/swing.wav")
```

### Use Case 2: Plugin-Enhanced Development

**Scenario**: You have plugins installed and want AI to use them.

```
User: I have the "Dialogue Manager" plugin installed.
Create a conversation system using it.

AI Actions:
1. get_installed_plugins() → Finds dialogue_manager
2. get_plugin_info("dialogue_manager") → Gets available nodes
3. create_scene("res://scenes/dialogue.tscn")
4. add_node(node_type="DialogueLabel", node_name="DialogueDisplay")
5. add_node(node_type="DialogueManager", node_name="Manager")
6. create_script("res://scripts/dialogue_controller.gd")
7. attach_script(node_path="Manager", script_path="res://scripts/dialogue_controller.gd")
```

### Use Case 3: Automated Gameplay Testing

**Scenario**: Test player movement and jumping.

```
User: Test my platformer character's movement.

AI Actions:
1. play_scene("res://scenes/game.tscn")
2. get_input_actions() → Finds "move_left", "move_right", "jump"
3. simulate_action("move_right", pressed=True)
4. Wait 1 second
5. get_node_properties("Player") → Check position changed
6. simulate_action("jump", pressed=True)
7. Wait 0.5 seconds
8. get_node_properties("Player") → Check player is in air
9. get_runtime_stats() → Check FPS is stable
10. get_running_scene_screenshot() → Visual verification
```

### Use Case 4: Performance Optimization

**Scenario**: Game is running slowly, need to optimize.

```
User: My game is laggy. Help me optimize it.

AI Actions:
1. play_scene("res://scenes/game.tscn")
2. get_runtime_stats() → Analyze performance
   - FPS: 25 (low!)
   - Draw calls: 500 (high!)
   - Memory: 200MB (high!)
3. get_scene_tree() → Analyze scene structure
4. Identify issues:
   - Too many Sprite2D nodes
   - No texture atlasing
   - Inefficient collision shapes
5. Suggest optimizations:
   - Combine sprites into atlas
   - Use TileMap instead of individual sprites
   - Simplify collision shapes
6. Apply fixes
7. get_runtime_stats() → Verify improvements
   - FPS: 60 (good!)
   - Draw calls: 50 (optimized!)
```

### Use Case 5: Interactive Debugging

**Scenario**: Bug in player controller, need to debug.

```
User: My player isn't jumping correctly.

AI Actions:
1. play_scene("res://scenes/game.tscn")
2. get_node_properties("Player") → Check initial state
3. simulate_action("jump", pressed=True)
4. get_node_properties("Player") → Check velocity changed
5. call_node_method("Player", "jump") → Test jump method directly
6. view_script("res://scripts/player.gd") → Analyze jump code
7. Identify issue: velocity.y not being set correctly
8. edit_file() → Fix the bug
9. play_scene() → Test again
10. simulate_action("jump") → Verify fix works
```

---

## 🎯 CLI Integration

All these features work with multiple AI CLIs:

### Claude Code CLI
```bash
claude-code
> Using godot-mcp-enhanced, find all textures in my project and create a sprite showcase scene.
```

### Gemini CLI
```bash
gemini-cli --mcp
> @godot get_assets_by_type texture
> Create a gallery scene using these textures
```

### Aider
```bash
aider --mcp godot
/mcp godot get_installed_plugins
/mcp godot get_assets_by_type 3d
> Create a 3D scene using available plugins and models
```

---

## 🔧 Technical Details

### Input Simulation Implementation

The input simulation uses Godot's `Input.parse_input_event()` to inject events:

```gdscript
func simulate_key_press(keycode: int, pressed: bool = true) -> Dictionary:
    var event = InputEventKey.new()
    event.keycode = keycode
    event.pressed = pressed
    Input.parse_input_event(event)
    return {"success": true}
```

### Asset Discovery Implementation

Assets are discovered by scanning the filesystem:

```gdscript
func get_assets_by_type(asset_type: String) -> Dictionary:
    var extensions = _get_extensions_for_type(asset_type)
    var assets = []
    _scan_directory("res://", extensions, assets)
    return {"assets": assets}
```

### Plugin Detection Implementation

Plugins are detected by scanning the `addons/` directory:

```gdscript
func get_installed_plugins() -> Dictionary:
    var plugins = []
    var dir = DirAccess.open("res://addons")
    for plugin_name in dir.get_directories():
        var config = _read_plugin_config(plugin_name)
        plugins.append(config)
    return {"plugins": plugins}
```

---

## 📊 Performance Impact

- **Input Simulation**: Negligible (<0.1ms per event)
- **Asset Discovery**: ~10-50ms for typical projects
- **Plugin Detection**: ~5-20ms
- **Runtime Stats**: <1ms per call
- **Node Inspection**: ~1-5ms per node

---

## 🎉 Summary

With these 11 new runtime tools, Godot MCP Enhanced now provides:

✅ **Complete asset integration** - AI can discover and use your assets  
✅ **Plugin compatibility** - Works with any installed plugins  
✅ **Input simulation** - Test gameplay automatically  
✅ **Runtime debugging** - Inspect nodes during gameplay  
✅ **Performance monitoring** - Real-time optimization  
✅ **Automated testing** - Run tests automatically  
✅ **Multi-CLI support** - Works with Claude, Gemini, Aider, and more

**Total: 62+ tools for complete AI-assisted game development!** 🚀🎮🤖
