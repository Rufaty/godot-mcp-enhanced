# AI Instructions for Godot MCP Enhanced v1.0

This document provides comprehensive guidance for AI assistants using Godot MCP Enhanced to help developers build games.

**Version**: 1.0.0  
**Total Tools**: 62+  
**Supported IDEs**: Kiro IDE, Claude Code CLI, Cursor, Windsurf, Aider, Continue

---

## 🚀 What's New in v1.0

### Runtime Operations (11 New Tools)
- **Input Simulation** - Test gameplay with simulated keyboard/mouse/actions
- **Asset Discovery** - Find and use all project assets automatically
- **Plugin Detection** - Detect and use installed Godot plugins
- **Runtime Debugging** - Inspect nodes and properties during gameplay
- **Performance Monitoring** - Real-time FPS, memory, draw call stats
- **Automated Testing** - Run test scripts and verify results

### Key Capabilities
✅ Discover and use project assets (sprites, models, sounds)  
✅ Detect and integrate installed plugins  
✅ Simulate input for automated testing  
✅ Monitor performance in real-time  
✅ Debug runtime issues with live inspection  
✅ Build complete games with minimal user intervention

---

## 🎯 Core Principles

### 1. **Understand Before Acting**
- Always get project context first using `get_windsurf_context` or `get_project_info`
- Check current scene state with `get_scene_tree` before making changes
- Review existing scripts with `get_open_scripts` before creating new ones

### 2. **Incremental Development**
- Build features step-by-step, verifying each step
- Use screenshots to confirm visual changes
- Test functionality after each major change

### 3. **Error Prevention**
- Check for errors with `get_godot_errors` regularly
- Validate scene structure before adding nodes
- Verify resource paths exist before referencing them

### 4. **User Communication**
- Explain what you're doing and why
- Show progress with screenshots
- Ask for clarification when requirements are ambiguous

---

## 🛠️ Tool Usage Patterns

### Starting a New Feature

```
1. @godot get_windsurf_context
   → Understand current project state

2. @godot get_scene_tree
   → See what's already in the scene

3. @godot get_godot_errors
   → Check for existing issues

4. Plan the implementation
   → Break down into steps

5. Execute step-by-step
   → Verify each step works
```

### Creating a Complete Scene

```
1. @godot create_scene path="res://scenes/player.tscn" root_type="CharacterBody2D" root_name="Player"
   → Create the base scene

2. @godot add_node parent_path="Player" node_type="Sprite2D" node_name="Sprite"
   → Add visual component

3. @godot add_node parent_path="Player" node_type="CollisionShape2D" node_name="Collision"
   → Add physics component

4. @godot add_resource node_path="Player/Collision" property="shape" resource_type="RectangleShape2D"
   → Configure collision shape

5. @godot create_script path="res://scripts/player.gd"
   → Create the script

6. @godot attach_script node_path="Player" script_path="res://scripts/player.gd"
   → Attach script to node

7. @godot get_editor_screenshot
   → Verify the result
```

### Debugging Issues

```
1. @godot get_godot_errors
   → Get all current errors

2. @godot get_scene_tree
   → Check scene structure

3. @godot view_script path="res://scripts/problematic.gd"
   → Review the problematic script

4. @godot get_editor_screenshot
   → See visual state

5. Analyze and fix
   → Make targeted corrections

6. @godot get_godot_errors
   → Verify errors are resolved
```

---

## 🎮 Game Development Workflows

### Workflow 1: Platformer Player Character

**Goal**: Create a fully functional 2D platformer player

**Steps**:

1. **Create Player Scene**
   ```
   @godot create_scene path="res://scenes/player.tscn" root_type="CharacterBody2D" root_name="Player"
   ```

2. **Add Visual Components**
   ```
   @godot add_node parent_path="Player" node_type="Sprite2D" node_name="Sprite"
   @godot update_property node_path="Player/Sprite" property="position" value="[0, -16]"
   ```

3. **Add Physics Components**
   ```
   @godot add_node parent_path="Player" node_type="CollisionShape2D" node_name="Collision"
   @godot add_resource node_path="Player/Collision" property="shape" resource_type="RectangleShape2D" resource_properties='{"size": [32, 64]}'
   ```

4. **Add Camera**
   ```
   @godot add_node parent_path="Player" node_type="Camera2D" node_name="Camera"
   @godot update_property node_path="Player/Camera" property="enabled" value="true"
   @godot update_property node_path="Player/Camera" property="zoom" value="[2.0, 2.0]"
   ```

5. **Create Movement Script**
   ```
   @godot create_script path="res://scripts/player.gd" content='
   extends CharacterBody2D

   const SPEED = 300.0
   const JUMP_VELOCITY = -400.0

   func _physics_process(delta: float) -> void:
       # Add gravity
       if not is_on_floor():
           velocity += get_gravity() * delta

       # Handle jump
       if Input.is_action_just_pressed("ui_accept") and is_on_floor():
           velocity.y = JUMP_VELOCITY

       # Handle movement
       var direction := Input.get_axis("ui_left", "ui_right")
       if direction:
           velocity.x = direction * SPEED
       else:
           velocity.x = move_toward(velocity.x, 0, SPEED)

       move_and_slide()
   '
   ```

6. **Attach Script**
   ```
   @godot attach_script node_path="Player" script_path="res://scripts/player.gd"
   ```

7. **Verify**
   ```
   @godot get_editor_screenshot
   @godot get_godot_errors
   ```

### Workflow 2: Main Menu UI

**Goal**: Create a functional main menu

**Steps**:

1. **Create UI Scene**
   ```
   @godot create_scene path="res://scenes/ui/main_menu.tscn" root_type="Control" root_name="MainMenu"
   ```

2. **Add Background**
   ```
   @godot add_node parent_path="MainMenu" node_type="ColorRect" node_name="Background"
   @godot set_anchor_preset node_path="MainMenu/Background" preset="full_rect"
   @godot update_property node_path="MainMenu/Background" property="color" value="[0.1, 0.1, 0.18, 1.0]"
   ```

3. **Add Button Container**
   ```
   @godot add_node parent_path="MainMenu" node_type="VBoxContainer" node_name="ButtonContainer"
   @godot set_anchor_preset node_path="MainMenu/ButtonContainer" preset="center"
   @godot update_property node_path="MainMenu/ButtonContainer" property="custom_minimum_size" value="[200, 0]"
   ```

4. **Add Title**
   ```
   @godot add_node parent_path="MainMenu/ButtonContainer" node_type="Label" node_name="Title"
   @godot update_property node_path="MainMenu/ButtonContainer/Title" property="text" value="MY GAME"
   @godot update_property node_path="MainMenu/ButtonContainer/Title" property="horizontal_alignment" value="1"
   ```

5. **Add Buttons**
   ```
   @godot add_node parent_path="MainMenu/ButtonContainer" node_type="Button" node_name="StartButton"
   @godot update_property node_path="MainMenu/ButtonContainer/StartButton" property="text" value="Start Game"
   
   @godot add_node parent_path="MainMenu/ButtonContainer" node_type="Button" node_name="SettingsButton"
   @godot update_property node_path="MainMenu/ButtonContainer/SettingsButton" property="text" value="Settings"
   
   @godot add_node parent_path="MainMenu/ButtonContainer" node_type="Button" node_name="QuitButton"
   @godot update_property node_path="MainMenu/ButtonContainer/QuitButton" property="text" value="Quit"
   ```

6. **Create Menu Script**
   ```
   @godot create_script path="res://scripts/ui/main_menu.gd" content='
   extends Control

   func _ready() -> void:
       $ButtonContainer/StartButton.pressed.connect(_on_start_pressed)
       $ButtonContainer/SettingsButton.pressed.connect(_on_settings_pressed)
       $ButtonContainer/QuitButton.pressed.connect(_on_quit_pressed)

   func _on_start_pressed() -> void:
       get_tree().change_scene_to_file("res://scenes/game.tscn")

   func _on_settings_pressed() -> void:
       # TODO: Open settings menu
       pass

   func _on_quit_pressed() -> void:
       get_tree().quit()
   '
   ```

7. **Attach and Verify**
   ```
   @godot attach_script node_path="MainMenu" script_path="res://scripts/ui/main_menu.gd"
   @godot get_editor_screenshot
   ```

### Workflow 3: Enemy AI

**Goal**: Create an enemy with basic AI

**Steps**:

1. **Create Enemy Scene**
   ```
   @godot create_scene path="res://scenes/enemies/slime.tscn" root_type="CharacterBody2D" root_name="Slime"
   ```

2. **Add Components**
   ```
   @godot add_node parent_path="Slime" node_type="AnimatedSprite2D" node_name="Sprite"
   @godot add_node parent_path="Slime" node_type="CollisionShape2D" node_name="Collision"
   @godot add_resource node_path="Slime/Collision" property="shape" resource_type="CircleShape2D" resource_properties='{"radius": 16}'
   
   @godot add_node parent_path="Slime" node_type="Area2D" node_name="DetectionZone"
   @godot add_node parent_path="Slime/DetectionZone" node_type="CollisionShape2D" node_name="DetectionShape"
   @godot add_resource node_path="Slime/DetectionZone/DetectionShape" property="shape" resource_type="CircleShape2D" resource_properties='{"radius": 100}'
   ```

3. **Create AI Script**
   ```
   @godot create_script path="res://scripts/enemies/slime.gd" content='
   extends CharacterBody2D

   enum State { IDLE, PATROL, CHASE, ATTACK }

   @export var speed: float = 100.0
   @export var health: int = 50
   @export var patrol_distance: float = 200.0

   var current_state: State = State.IDLE
   var player: Node2D = null
   var patrol_origin: Vector2
   var patrol_direction: int = 1

   func _ready() -> void:
       patrol_origin = global_position
       $DetectionZone.body_entered.connect(_on_detection_zone_entered)
       $DetectionZone.body_exited.connect(_on_detection_zone_exited)

   func _physics_process(delta: float) -> void:
       match current_state:
           State.IDLE:
               _idle_state(delta)
           State.PATROL:
               _patrol_state(delta)
           State.CHASE:
               _chase_state(delta)
           State.ATTACK:
               _attack_state(delta)
       
       move_and_slide()

   func _idle_state(delta: float) -> void:
       velocity = Vector2.ZERO
       # Transition to patrol after delay
       await get_tree().create_timer(2.0).timeout
       current_state = State.PATROL

   func _patrol_state(delta: float) -> void:
       velocity.x = patrol_direction * speed
       
       # Check patrol bounds
       if abs(global_position.x - patrol_origin.x) > patrol_distance:
           patrol_direction *= -1

   func _chase_state(delta: float) -> void:
       if player:
           var direction = (player.global_position - global_position).normalized()
           velocity = direction * speed * 1.5

   func _attack_state(delta: float) -> void:
       velocity = Vector2.ZERO
       # TODO: Implement attack logic

   func _on_detection_zone_entered(body: Node2D) -> void:
       if body.is_in_group("player"):
           player = body
           current_state = State.CHASE

   func _on_detection_zone_exited(body: Node2D) -> void:
       if body == player:
           player = null
           current_state = State.PATROL

   func take_damage(amount: int) -> void:
       health -= amount
       if health <= 0:
           queue_free()
   '
   ```

4. **Attach and Verify**
   ```
   @godot attach_script node_path="Slime" script_path="res://scripts/enemies/slime.gd"
   @godot get_scene_tree
   @godot get_editor_screenshot
   ```

---

## 🧠 Advanced Reasoning Patterns

### Pattern 1: Analyze Before Implementing

When asked to add a feature:

1. **Understand the request fully**
   - What is the user trying to achieve?
   - What are the constraints?
   - What's the expected behavior?

2. **Check existing implementation**
   - What's already built?
   - What can be reused?
   - What needs to be created?

3. **Plan the approach**
   - Break into logical steps
   - Identify dependencies
   - Consider edge cases

4. **Implement incrementally**
   - One step at a time
   - Verify each step
   - Adjust based on results

### Pattern 2: Debug Systematically

When encountering errors:

1. **Gather information**
   ```
   @godot get_godot_errors
   @godot get_scene_tree
   @godot get_editor_screenshot
   ```

2. **Analyze the error**
   - What's the error message?
   - Where does it occur?
   - What's the root cause?

3. **Form hypothesis**
   - What might be wrong?
   - What would fix it?

4. **Test hypothesis**
   - Make targeted fix
   - Verify error is gone
   - Check for side effects

### Pattern 3: Optimize Performance

When improving performance:

1. **Measure current state**
   ```
   @godot get_godot_errors  # Check for performance warnings
   ```

2. **Identify bottlenecks**
   - Review scripts for inefficiencies
   - Check scene complexity
   - Look for unnecessary operations

3. **Apply optimizations**
   - Cache node references
   - Reduce draw calls
   - Optimize algorithms

4. **Verify improvements**
   - Test performance
   - Ensure functionality intact

---

## 📋 Checklists for Common Tasks

### Creating a New Game Scene

- [ ] Create scene with appropriate root node type
- [ ] Add all necessary child nodes
- [ ] Configure node properties
- [ ] Add required resources (shapes, textures, etc.)
- [ ] Create and attach scripts
- [ ] Set up signals and connections
- [ ] Test functionality
- [ ] Take screenshot for verification
- [ ] Check for errors

### Implementing Player Movement

- [ ] CharacterBody2D or RigidBody2D node
- [ ] Sprite for visuals
- [ ] CollisionShape2D for physics
- [ ] Camera2D for following
- [ ] Movement script with input handling
- [ ] Gravity implementation
- [ ] Jump mechanics
- [ ] Animation (if applicable)
- [ ] Test in play mode

### Creating UI Elements

- [ ] Control node as root
- [ ] Proper anchor settings
- [ ] Responsive layout (containers)
- [ ] Visual elements (buttons, labels, etc.)
- [ ] Script for functionality
- [ ] Signal connections
- [ ] Theme/styling
- [ ] Test different resolutions

### Adding Enemy AI

- [ ] Enemy scene with physics body
- [ ] Visual representation
- [ ] Collision detection
- [ ] Detection zone for player
- [ ] State machine for behavior
- [ ] Movement logic
- [ ] Attack logic
- [ ] Health system
- [ ] Test AI behavior

---

## 🎯 Best Practices

### 1. **Always Verify**
- Use screenshots to confirm visual changes
- Check errors after each operation
- Test functionality before moving on

### 2. **Be Descriptive**
- Use clear, descriptive names for nodes and scripts
- Add comments to complex code
- Explain your reasoning to the user

### 3. **Handle Errors Gracefully**
- Check for errors regularly
- Provide clear error messages
- Suggest fixes when errors occur

### 4. **Think Holistically**
- Consider how changes affect the whole project
- Maintain consistent patterns
- Follow Godot best practices

### 5. **Communicate Clearly**
- Explain what you're doing
- Show progress visually
- Ask for clarification when needed

---

## 🚀 Building Complete Games

### Step-by-Step Game Creation

1. **Project Setup**
   - Understand game concept
   - Plan scene structure
   - Identify required assets

2. **Core Mechanics**
   - Player movement
   - Camera system
   - Input handling

3. **Game Elements**
   - Enemies/obstacles
   - Collectibles
   - Power-ups

4. **UI System**
   - Main menu
   - HUD
   - Pause menu
   - Game over screen

5. **Game Logic**
   - Score system
   - Health system
   - Level progression
   - Win/lose conditions

6. **Polish**
   - Animations
   - Sound effects
   - Visual effects
   - Transitions

7. **Testing**
   - Playtest all features
   - Fix bugs
   - Optimize performance

### Example: Complete Platformer Game

See `docs/GAME_TEMPLATES.md` for full implementation guides.

---

## 💡 Tips for Success

1. **Start Simple**: Build basic functionality first, then add complexity
2. **Test Often**: Verify each change works before moving on
3. **Use Screenshots**: Visual confirmation is invaluable
4. **Check Errors**: Catch issues early
5. **Be Patient**: Complex features take multiple steps
6. **Communicate**: Keep the user informed of progress
7. **Learn Patterns**: Reuse successful approaches
8. **Stay Organized**: Maintain clean project structure

---

## 🔗 Related Documentation

- [EXAMPLES.md](docs/EXAMPLES.md) - Practical usage examples
- [WINDSURF_SETUP.md](docs/WINDSURF_SETUP.md) - Windsurf-specific features
- [TESTING.md](TESTING.md) - Testing and verification
- [Godot Documentation](https://docs.godotengine.org/) - Official Godot docs

---

**Remember**: You're not just executing commands—you're helping create games. Think creatively, plan carefully, and build incrementally. The tools are powerful, but your reasoning and approach make the difference between a collection of nodes and a playable game.


---

## 🎮 Runtime Operations Guide

### Asset Discovery & Management

#### Finding Project Assets
Use `get_assets_by_type` to discover assets in the project:

```
@godot get_assets_by_type asset_type="texture"
@godot get_assets_by_type asset_type="3d"
@godot get_assets_by_type asset_type="audio"
```

**Supported Asset Types**:
- `texture` / `image` - PNG, JPG, SVG
- `mesh` / `model` / `3d` - GLB, GLTF, OBJ, FBX
- `audio` / `sound` - WAV, OGG, MP3
- `script` - GD files
- `scene` - TSCN files
- `material` - TRES materials
- `shader` - GDSHADER files

#### Using Discovered Assets
Once you find assets, use them in scenes:

```
# Find textures
@godot get_assets_by_type asset_type="texture"
# Returns: ["res://sprites/player.png", "res://sprites/enemy.png"]

# Use in scene
@godot add_node parent_path="Player" node_type="Sprite2D" node_name="Sprite"
@godot update_property node_path="Player/Sprite" property="texture" value="res://sprites/player.png"
```

#### Asset Information
Get detailed info about specific assets:

```
@godot get_asset_info asset_path="res://sprites/player.png"
# Returns: {"type": "Texture2D", "size": [64, 64], "format": "PNG"}
```

---

## 🎨 SVG Asset Usage Guide

### Why Use SVG Files in Godot

SVG (Scalable Vector Graphics) files are powerful assets for game development:

**Advantages**:
- ✅ **Resolution Independent** - Scale to any size without quality loss
- ✅ **Small File Size** - Vector data is compact compared to raster images
- ✅ **Perfect for UI** - Icons, buttons, logos stay crisp at any resolution
- ✅ **Easy to Edit** - Modify colors, shapes, and styles programmatically
- ✅ **Ideal for 2D Games** - Clean, scalable game elements
- ✅ **Multi-Resolution Support** - One file works for all screen sizes

**Best Use Cases**:
- UI icons and buttons
- Logos and branding
- HUD elements
- Menu graphics
- Simple 2D game sprites
- Geometric shapes
- Symbols and indicators
- Resolution-independent backgrounds

### Discovering SVG Assets

SVG files are discovered as textures:

```
@godot get_assets_by_type asset_type="texture"
# Returns: ["res://icons/menu.svg", "res://ui/button.svg", "res://sprites/player.svg"]

@godot get_assets_by_type asset_type="image"
# Also finds SVG files along with PNG, JPG
```

### Using SVG for UI Icons

#### Example 1: Menu Icons

```
# Discover SVG icons
@godot get_assets_by_type asset_type="texture"
# Found: res://icons/play.svg, res://icons/settings.svg, res://icons/quit.svg

# Create menu with SVG icons
@godot create_scene path="res://scenes/main_menu.tscn" root_type="Control"

# Add button with SVG icon
@godot add_node node_type="Button" node_name="PlayButton"
@godot update_property node_path="PlayButton" property="text" value="Play"

# Add TextureRect for icon
@godot add_node parent_path="PlayButton" node_type="TextureRect" node_name="Icon"
@godot update_property node_path="PlayButton/Icon" property="texture" value="res://icons/play.svg"
@godot update_property node_path="PlayButton/Icon" property="expand_mode" value="1"  # Keep aspect
@godot update_property node_path="PlayButton/Icon" property="custom_minimum_size" value="[32, 32]"
```

#### Example 2: HUD Icons

```
# Create HUD with SVG icons
@godot create_scene path="res://scenes/hud.tscn" root_type="CanvasLayer"

# Health icon
@godot add_node node_type="TextureRect" node_name="HealthIcon"
@godot update_property node_path="HealthIcon" property="texture" value="res://icons/heart.svg"
@godot update_property node_path="HealthIcon" property="custom_minimum_size" value="[24, 24]"
@godot update_property node_path="HealthIcon" property="position" value="[10, 10]"

# Coin icon
@godot add_node node_type="TextureRect" node_name="CoinIcon"
@godot update_property node_path="CoinIcon" property="texture" value="res://icons/coin.svg"
@godot update_property node_path="CoinIcon" property="custom_minimum_size" value="[24, 24]"
@godot update_property node_path="CoinIcon" property="position" value="[10, 40]"
```

### Using SVG for Logos and Branding

#### Example 3: Game Logo

```
# Add scalable logo to title screen
@godot create_scene path="res://scenes/title_screen.tscn" root_type="Control"

# Add logo (SVG scales perfectly)
@godot add_node node_type="TextureRect" node_name="GameLogo"
@godot update_property node_path="GameLogo" property="texture" value="res://branding/logo.svg"
@godot update_property node_path="GameLogo" property="expand_mode" value="1"  # Keep aspect
@godot update_property node_path="GameLogo" property="stretch_mode" value="5"  # Keep aspect centered
@godot update_property node_path="GameLogo" property="custom_minimum_size" value="[400, 200]"
@godot set_anchor_preset node_path="GameLogo" preset="center_top"
```

### Using SVG for 2D Game Sprites

#### Example 4: Simple 2D Character

```
# Use SVG for clean, scalable character sprite
@godot create_scene path="res://scenes/player.tscn" root_type="CharacterBody2D"

# Add SVG sprite
@godot add_node parent_path="." node_type="Sprite2D" node_name="Sprite"
@godot update_property node_path="Sprite" property="texture" value="res://sprites/player.svg"
@godot update_property node_path="Sprite" property="scale" value="[2.0, 2.0]"  # Scale up without quality loss

# Add collision
@godot add_node parent_path="." node_type="CollisionShape2D" node_name="Collision"
@godot add_resource node_path="Collision" property="shape" resource_type="RectangleShape2D" resource_properties='{"size": [32, 64]}'
```

#### Example 5: Geometric Game Elements

```
# Use SVG for geometric shapes in puzzle game
@godot create_scene path="res://scenes/puzzle_piece.tscn" root_type="Area2D"

# Add SVG shape
@godot add_node parent_path="." node_type="Sprite2D" node_name="Shape"
@godot update_property node_path="Shape" property="texture" value="res://shapes/triangle.svg"

# SVG shapes are perfect for:
# - Puzzle pieces
# - Geometric enemies
# - Abstract game elements
# - Pattern-based games
```

### Using SVG for UI Components

#### Example 6: Button System with SVG

```
# Create reusable button with SVG background
@godot create_scene path="res://scenes/ui/custom_button.tscn" root_type="Button"

# Add SVG background
@godot add_node parent_path="." node_type="TextureRect" node_name="Background"
@godot update_property node_path="Background" property="texture" value="res://ui/button_bg.svg"
@godot update_property node_path="Background" property="expand_mode" value="1"
@godot set_anchor_preset node_path="Background" preset="full_rect"

# Add SVG icon
@godot add_node parent_path="." node_type="TextureRect" node_name="Icon"
@godot update_property node_path="Icon" property="texture" value="res://icons/action.svg"
@godot update_property node_path="Icon" property="custom_minimum_size" value="[24, 24]"
```

#### Example 7: Progress Bar with SVG

```
# Create progress bar with SVG elements
@godot create_scene path="res://scenes/ui/progress_bar.tscn" root_type="Control"

# Background (SVG)
@godot add_node node_type="TextureRect" node_name="Background"
@godot update_property node_path="Background" property="texture" value="res://ui/bar_bg.svg"
@godot update_property node_path="Background" property="expand_mode" value="1"

# Fill (SVG that can be clipped)
@godot add_node node_type="TextureProgressBar" node_name="Fill"
@godot update_property node_path="Fill" property="texture_progress" value="res://ui/bar_fill.svg"
@godot update_property node_path="Fill" property="value" value="75"
```

### SVG Best Practices

#### 1. **Sizing and Scaling**

```
# Always set custom_minimum_size for SVG textures
@godot update_property node_path="Icon" property="custom_minimum_size" value="[32, 32]"

# Use expand_mode to control scaling
@godot update_property node_path="Icon" property="expand_mode" value="1"  # Keep aspect ratio

# Scale SVG sprites without quality loss
@godot update_property node_path="Sprite" property="scale" value="[3.0, 3.0]"  # Perfect quality!
```

#### 2. **Performance Considerations**

```
# SVG files are rasterized by Godot at import time
# For best performance:
# - Use SVG for UI elements (rendered once)
# - Use SVG for static game elements
# - Consider PNG for frequently animated sprites
# - SVG is perfect for resolution-independent assets
```

#### 3. **Color Modification**

```
# Modify SVG colors with modulate
@godot update_property node_path="Icon" property="modulate" value="[1.0, 0.5, 0.5, 1.0]"  # Tint red

# Create color variants without multiple files
@godot add_node node_type="TextureRect" node_name="RedIcon"
@godot update_property node_path="RedIcon" property="texture" value="res://icons/star.svg"
@godot update_property node_path="RedIcon" property="modulate" value="[1.0, 0.0, 0.0, 1.0]"

@godot add_node node_type="TextureRect" node_name="BlueIcon"
@godot update_property node_path="BlueIcon" property="texture" value="res://icons/star.svg"
@godot update_property node_path="BlueIcon" property="modulate" value="[0.0, 0.0, 1.0, 1.0]"
```

#### 4. **Multi-Resolution Support**

```
# SVG automatically adapts to different screen sizes
# Perfect for:
# - Mobile games (various screen sizes)
# - Desktop games (different resolutions)
# - UI that needs to scale
# - High-DPI displays

# Example: Responsive UI
@godot create_scene path="res://scenes/responsive_ui.tscn" root_type="Control"

# Logo scales to screen size
@godot add_node node_type="TextureRect" node_name="Logo"
@godot update_property node_path="Logo" property="texture" value="res://branding/logo.svg"
@godot set_anchor_preset node_path="Logo" preset="center"
@godot update_property node_path="Logo" property="expand_mode" value="1"
# Will look perfect on any screen size!
```

### Complete SVG Workflow Examples

#### Workflow 1: Icon-Based Menu System

```
# 1. Discover SVG icons
@godot get_assets_by_type asset_type="texture"
# Found: play.svg, settings.svg, quit.svg, help.svg

# 2. Create menu scene
@godot create_scene path="res://scenes/icon_menu.tscn" root_type="Control"

# 3. Add VBoxContainer for buttons
@godot add_node node_type="VBoxContainer" node_name="ButtonContainer"
@godot set_anchor_preset node_path="ButtonContainer" preset="center"
@godot update_property node_path="ButtonContainer" property="custom_minimum_size" value="[200, 0]"

# 4. Create buttons with SVG icons
@godot add_node parent_path="ButtonContainer" node_type="HBoxContainer" node_name="PlayButton"
@godot add_node parent_path="ButtonContainer/PlayButton" node_type="TextureRect" node_name="Icon"
@godot update_property node_path="ButtonContainer/PlayButton/Icon" property="texture" value="res://icons/play.svg"
@godot update_property node_path="ButtonContainer/PlayButton/Icon" property="custom_minimum_size" value="[32, 32]"
@godot add_node parent_path="ButtonContainer/PlayButton" node_type="Label" node_name="Label"
@godot update_property node_path="ButtonContainer/PlayButton/Label" property="text" value="Play Game"

# Repeat for other buttons...
# Result: Professional icon-based menu that scales perfectly!
```

#### Workflow 2: HUD with SVG Elements

```
# 1. Discover HUD assets
@godot get_assets_by_type asset_type="texture"
# Found: heart.svg, shield.svg, coin.svg, star.svg

# 2. Create HUD
@godot create_scene path="res://scenes/game_hud.tscn" root_type="CanvasLayer"

# 3. Add health display
@godot add_node node_type="HBoxContainer" node_name="HealthDisplay"
@godot update_property node_path="HealthDisplay" property="position" value="[10, 10]"

@godot add_node parent_path="HealthDisplay" node_type="TextureRect" node_name="HeartIcon"
@godot update_property node_path="HealthDisplay/HeartIcon" property="texture" value="res://icons/heart.svg"
@godot update_property node_path="HealthDisplay/HeartIcon" property="custom_minimum_size" value="[24, 24]"

@godot add_node parent_path="HealthDisplay" node_type="Label" node_name="HealthValue"
@godot update_property node_path="HealthDisplay/HealthValue" property="text" value="100"

# 4. Add currency display
@godot add_node node_type="HBoxContainer" node_name="CoinDisplay"
@godot update_property node_path="CoinDisplay" property="position" value="[10, 40]"

@godot add_node parent_path="CoinDisplay" node_type="TextureRect" node_name="CoinIcon"
@godot update_property node_path="CoinDisplay/CoinIcon" property="texture" value="res://icons/coin.svg"
@godot update_property node_path="CoinDisplay/CoinIcon" property="custom_minimum_size" value="[24, 24]"

@godot add_node parent_path="CoinDisplay" node_type="Label" node_name="CoinValue"
@godot update_property node_path="CoinDisplay/CoinValue" property="text" value="0"

# Result: Clean, scalable HUD that looks great on any screen!
```

#### Workflow 3: 2D Game with SVG Sprites

```
# 1. Discover SVG game assets
@godot get_assets_by_type asset_type="texture"
# Found: player.svg, enemy.svg, platform.svg, collectible.svg

# 2. Create player with SVG
@godot create_scene path="res://scenes/player.tscn" root_type="CharacterBody2D"
@godot add_node parent_path="." node_type="Sprite2D" node_name="Sprite"
@godot update_property node_path="Sprite" property="texture" value="res://sprites/player.svg"
@godot update_property node_path="Sprite" property="scale" value="[2.0, 2.0]"

# 3. Create enemy with SVG
@godot create_scene path="res://scenes/enemy.tscn" root_type="CharacterBody2D"
@godot add_node parent_path="." node_type="Sprite2D" node_name="Sprite"
@godot update_property node_path="Sprite" property="texture" value="res://sprites/enemy.svg"
@godot update_property node_path="Sprite" property="scale" value="[1.5, 1.5]"

# 4. Create level with SVG platforms
@godot create_scene path="res://scenes/level1.tscn" root_type="Node2D"
@godot add_node node_type="StaticBody2D" node_name="Platform1"
@godot add_node parent_path="Platform1" node_type="Sprite2D" node_name="Sprite"
@godot update_property node_path="Platform1/Sprite" property="texture" value="res://sprites/platform.svg"
@godot update_property node_path="Platform1/Sprite" property="scale" value="[4.0, 1.0]"  # Stretch platform

# Result: Clean, geometric 2D game with perfect scaling!
```

### SVG Asset Organization

**Recommended Folder Structure**:
```
res://
├── icons/          # UI icons (SVG)
│   ├── menu.svg
│   ├── settings.svg
│   └── quit.svg
├── ui/             # UI components (SVG)
│   ├── button_bg.svg
│   ├── panel_bg.svg
│   └── bar_fill.svg
├── branding/       # Logos and branding (SVG)
│   ├── logo.svg
│   └── splash.svg
├── sprites/        # Game sprites (SVG for simple/geometric)
│   ├── player.svg
│   └── enemy.svg
└── shapes/         # Geometric shapes (SVG)
    ├── circle.svg
    ├── triangle.svg
    └── square.svg
```

### When to Use SVG vs PNG

**Use SVG for**:
- ✅ UI icons and buttons
- ✅ Logos and text
- ✅ HUD elements
- ✅ Simple geometric sprites
- ✅ Symbols and indicators
- ✅ Resolution-independent graphics
- ✅ Minimalist art styles

**Use PNG for**:
- ✅ Detailed pixel art
- ✅ Complex textures
- ✅ Photographic images
- ✅ Heavily animated sprites
- ✅ Particle effects
- ✅ Detailed character art

### SVG Quick Reference

| Task | Command | Notes |
|------|---------|-------|
| Find SVG files | `get_assets_by_type asset_type="texture"` | SVG included in textures |
| Add SVG to UI | `add_node node_type="TextureRect"` | Best for UI elements |
| Add SVG to game | `add_node node_type="Sprite2D"` | For game sprites |
| Set size | `update_property property="custom_minimum_size"` | Always set for SVG |
| Keep aspect | `update_property property="expand_mode" value="1"` | Prevents distortion |
| Scale up | `update_property property="scale" value="[2.0, 2.0]"` | No quality loss! |
| Change color | `update_property property="modulate"` | Tint SVG colors |

---

### Plugin Detection & Integration

#### Discovering Installed Plugins
Check what plugins are available:

```
@godot get_installed_plugins
# Returns: [{"name": "dialogue_manager", "enabled": true}, ...]
```

#### Using Plugin Features
Get plugin details and use its nodes:

```
# Get plugin info
@godot get_plugin_info plugin_name="dialogue_manager"
# Returns: {"nodes": ["DialogueLabel", "DialogueManager"], ...}

# Use plugin nodes
@godot add_node parent_path="UI" node_type="DialogueLabel" node_name="Dialogue"
```

### Input Simulation & Testing

#### Simulating Keyboard Input
Test gameplay with keyboard simulation:

```
# Press spacebar
@godot simulate_key_press keycode=32 pressed=true

# Release W key
@godot simulate_key_press keycode=87 pressed=false
```

**Common Keycodes**:
- Space: 32
- WASD: W=87, A=65, S=83, D=68
- Arrows: Up=4194320, Down=4194322, Left=4194319, Right=4194321
- Enter: 4194309, Escape: 4194305

#### Simulating Input Actions
Test with project-defined actions:

```
# Get available actions
@godot get_input_actions
# Returns: {"jump": [...], "move_left": [...], ...}

# Trigger action
@godot simulate_action action_name="jump" pressed=true strength=1.0
```

#### Testing Workflow
Complete testing workflow:

```
# 1. Start the game
@godot play_scene path="res://scenes/game.tscn"

# 2. Simulate player input
@godot simulate_action action_name="move_right" pressed=true
# Wait a moment
@godot simulate_action action_name="jump" pressed=true

# 3. Check results
@godot get_node_properties node_path="Player"
@godot get_running_scene_screenshot

# 4. Stop the game
@godot stop_running_scene
```

### Runtime Debugging

#### Inspecting Node Properties
Check node state during gameplay:

```
# Get all properties of a node
@godot get_node_properties node_path="Player"
# Returns: {"position": [100, 200], "velocity": [50, 0], "health": 100}
```

#### Calling Node Methods
Test methods directly:

```
# Call a method
@godot call_node_method node_path="Player" method_name="jump" args=[]

# Call with arguments
@godot call_node_method node_path="Player" method_name="take_damage" args=[25]
```

### Performance Monitoring

#### Getting Runtime Statistics
Monitor game performance:

```
@godot get_runtime_stats
```

**Returns**:
```json
{
  "fps": 60.0,
  "memory_static": 45.2,
  "memory_dynamic": 12.8,
  "draw_calls": 156,
  "vertices": 2048,
  "material_changes": 12
}
```

#### Performance Optimization Workflow
```
# 1. Measure baseline
@godot play_scene
@godot get_runtime_stats

# 2. Identify issues
# - Low FPS? Check draw calls and vertices
# - High memory? Check for leaks
# - Many material changes? Batch materials

# 3. Apply fixes
@godot stop_running_scene
# Make optimizations...

# 4. Verify improvements
@godot play_scene
@godot get_runtime_stats
```

### Automated Testing

#### Running Test Scripts
Execute automated tests:

```
@godot run_test_script script_path="res://tests/player_test.gd"
# Returns: {"tests_passed": 5, "tests_failed": 0, "output": "..."}
```

---

## 🎯 Advanced Workflows with Runtime Operations

### Workflow: Asset-Based Game Creation

**User Request**: "Create a game using my project assets"

**Steps**:

1. **Discover Assets**
   ```
   @godot get_assets_by_type asset_type="texture"
   @godot get_assets_by_type asset_type="audio"
   @godot get_assets_by_type asset_type="3d"
   ```

2. **Analyze Assets**
   - Identify player sprites
   - Find enemy sprites
   - Locate sound effects
   - Check for background music

3. **Create Game Structure**
   ```
   @godot create_scene path="res://scenes/game.tscn" root_type="Node2D"
   ```

4. **Use Assets in Scene**
   ```
   # Add player with discovered sprite
   @godot add_node node_type="CharacterBody2D" node_name="Player"
   @godot add_node parent_path="Player" node_type="Sprite2D" node_name="Sprite"
   @godot update_property node_path="Player/Sprite" property="texture" value="res://sprites/player.png"
   
   # Add audio with discovered sound
   @godot add_node parent_path="Player" node_type="AudioStreamPlayer2D" node_name="JumpSound"
   @godot update_property node_path="Player/JumpSound" property="stream" value="res://sounds/jump.wav"
   ```

5. **Test with Input Simulation**
   ```
   @godot play_scene
   @godot simulate_action action_name="jump"
   @godot get_running_scene_screenshot
   ```

### Workflow: Plugin-Enhanced Development

**User Request**: "Use my installed plugins to create a dialogue system"

**Steps**:

1. **Detect Plugins**
   ```
   @godot get_installed_plugins
   ```

2. **Get Plugin Details**
   ```
   @godot get_plugin_info plugin_name="dialogue_manager"
   # Returns available nodes and features
   ```

3. **Use Plugin Nodes**
   ```
   @godot create_scene path="res://scenes/dialogue.tscn" root_type="Control"
   @godot add_node node_type="DialogueLabel" node_name="DialogueDisplay"
   @godot add_node node_type="DialogueManager" node_name="Manager"
   ```

4. **Configure Plugin Features**
   ```
   @godot create_script path="res://scripts/dialogue_controller.gd"
   @godot attach_script node_path="Manager" script_path="res://scripts/dialogue_controller.gd"
   ```

### Workflow: Automated Gameplay Testing

**User Request**: "Test my platformer's movement and jumping"

**Steps**:

1. **Start Game**
   ```
   @godot play_scene path="res://scenes/game.tscn"
   ```

2. **Get Input Actions**
   ```
   @godot get_input_actions
   # Identify: move_left, move_right, jump
   ```

3. **Test Movement**
   ```
   # Test right movement
   @godot simulate_action action_name="move_right" pressed=true
   @godot get_node_properties node_path="Player"
   # Verify position changed
   
   @godot simulate_action action_name="move_right" pressed=false
   ```

4. **Test Jumping**
   ```
   @godot simulate_action action_name="jump" pressed=true
   @godot get_node_properties node_path="Player"
   # Verify velocity.y changed
   ```

5. **Visual Verification**
   ```
   @godot get_running_scene_screenshot
   ```

6. **Performance Check**
   ```
   @godot get_runtime_stats
   # Verify FPS is stable
   ```

7. **Stop Game**
   ```
   @godot stop_running_scene
   ```

### Workflow: Performance Optimization

**User Request**: "My game is laggy, help optimize it"

**Steps**:

1. **Measure Current Performance**
   ```
   @godot play_scene
   @godot get_runtime_stats
   # Note: FPS=25, draw_calls=500, memory=200MB
   ```

2. **Analyze Scene**
   ```
   @godot get_scene_tree
   # Identify: Too many Sprite2D nodes, no batching
   ```

3. **Identify Issues**
   - High draw calls → Need sprite batching
   - Many individual sprites → Use TileMap
   - Complex collision shapes → Simplify

4. **Apply Optimizations**
   ```
   @godot stop_running_scene
   # Convert sprites to TileMap
   # Simplify collision shapes
   # Enable texture atlasing
   ```

5. **Verify Improvements**
   ```
   @godot play_scene
   @godot get_runtime_stats
   # Note: FPS=60, draw_calls=50, memory=80MB ✓
   ```

---

## 🎓 Best Practices for Runtime Operations

### Asset Discovery
- **Always check assets first** before creating placeholder content
- **Use asset info** to understand dimensions and formats
- **Organize assets** by type for easier discovery

### Plugin Integration
- **Check plugin availability** before using plugin nodes
- **Read plugin documentation** via get_plugin_info
- **Test plugin features** incrementally

### Input Simulation
- **Get input actions first** to know what's available
- **Simulate realistic input** (press then release)
- **Wait between inputs** for proper testing
- **Verify results** with get_node_properties

### Performance Monitoring
- **Measure before optimizing** to establish baseline
- **Focus on bottlenecks** (low FPS, high draw calls)
- **Verify improvements** after changes
- **Monitor continuously** during development

### Automated Testing
- **Test incrementally** (one feature at a time)
- **Use visual verification** with screenshots
- **Check performance impact** of new features
- **Document test results** for user

---

## 📚 Quick Reference: Runtime Tools

| Tool | Purpose | Example |
|------|---------|---------|
| `get_assets_by_type` | Find project assets | `asset_type="texture"` |
| `get_asset_info` | Asset details | `asset_path="res://sprite.png"` |
| `get_installed_plugins` | List plugins | No args |
| `get_plugin_info` | Plugin details | `plugin_name="dialogue_manager"` |
| `simulate_key_press` | Test keyboard | `keycode=32 pressed=true` |
| `simulate_action` | Test actions | `action_name="jump"` |
| `get_input_actions` | List actions | No args |
| `get_node_properties` | Inspect node | `node_path="Player"` |
| `call_node_method` | Test method | `node_path="Player" method_name="jump"` |
| `get_runtime_stats` | Performance | No args |
| `run_test_script` | Run tests | `script_path="res://tests/test.gd"` |

---

## 🎉 Summary

With runtime operations, you can now:

✅ **Discover and use project assets automatically**  
✅ **Detect and integrate installed plugins**  
✅ **Test gameplay with input simulation**  
✅ **Debug runtime issues with live inspection**  
✅ **Monitor and optimize performance**  
✅ **Run automated tests**

**Build complete, asset-rich games with AI assistance!** 🚀🎮🤖
