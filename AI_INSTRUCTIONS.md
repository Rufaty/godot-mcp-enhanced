# AI Instructions for Godot MCP Enhanced

This document provides comprehensive guidance for AI assistants using Godot MCP Enhanced to help developers build games.

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
