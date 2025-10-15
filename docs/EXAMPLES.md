# Usage Examples - Godot MCP Enhanced

Real-world examples of using Godot MCP Enhanced with Windsurf AI.

---

## 🎮 Game Development Examples

### Example 1: Create a Complete Platformer Player

```
@godot Create a complete 2D platformer player:

1. Create scene at "res://scenes/player.tscn" with CharacterBody2D root named "Player"

2. Add these child nodes:
   - Sprite2D named "Sprite" (position: 0, -16)
   - CollisionShape2D named "Collision"
   - Camera2D named "Camera" (enabled: true, zoom: 2.0)
   - AnimationPlayer named "Animations"

3. For the Collision node, add a RectangleShape2D resource with size (32, 64)

4. Create script at "res://scripts/player.gd" with:
   - Movement constants (SPEED = 300, JUMP_VELOCITY = -400)
   - Input handling for left/right movement
   - Jump with gravity
   - Use move_and_slide()

5. Show me a screenshot of the completed scene
```

**Expected Result**: Complete player scene with proper hierarchy and script ready for platformer game.

---

### Example 2: Build Main Menu UI

```
@godot Build a main menu UI:

1. Create scene "res://scenes/ui/main_menu.tscn" with Control root

2. Add full-screen ColorRect background with dark color (#1a1a2e)

3. Add centered VBoxContainer with:
   - Label "MY AWESOME GAME" (large font, centered)
   - Spacing of 20 pixels
   - Three buttons: "Start Game", "Settings", "Quit"

4. Set all anchors to center preset for responsiveness

5. Create script "res://scripts/ui/main_menu.gd" that:
   - Connects button signals
   - Starts game on "Start Game" click
   - Opens settings on "Settings" click  
   - Quits on "Quit" click

6. Show me the result with a screenshot
```

**Expected Result**: Professional-looking main menu with proper layout and functionality.

---

### Example 3: Enemy AI Setup

```
@godot Create an enemy character:

1. Scene "res://scenes/enemies/slime.tscn" with CharacterBody2D root

2. Add nodes:
   - AnimatedSprite2D for animations
   - CollisionShape2D with CircleShape2D
   - Area2D named "DetectionZone" (for player detection)
   - Timer named "AttackTimer"

3. Script "res://scripts/enemies/slime.gd" with:
   - State machine (IDLE, PATROL, CHASE, ATTACK)
   - Basic patrol behavior
   - Player detection
   - Health system (HP = 50)

4. Add detection zone collision shape

5. Show me the scene tree and script
```

**Expected Result**: Complete enemy with AI foundation ready for game logic.

---

## 🛠️ Development Workflow Examples

### Example 4: Debug Performance Issues

```
@godot I'm experiencing lag. Help me debug:

1. Get current performance metrics
2. Show me the scene tree of the current scene
3. Check for performance issues in all scripts
4. Analyze the scene for inefficient nodes (too many sprites, etc.)
5. Capture a screenshot
6. Suggest specific optimizations based on findings
```

**Expected Result**: Detailed performance analysis with actionable suggestions.

---

### Example 5: Refactor Existing Code

```
@godot Refactor my player script for better performance:

1. View the current "res://scripts/player.gd" script
2. Identify performance issues:
   - get_node calls in _process
   - String concatenation in loops
   - Unnecessary calculations
3. Refactor to cache node references
4. Add proper type hints
5. Show me the before/after comparison
6. Validate the new syntax
```

**Expected Result**: Optimized script with improved performance and code quality.

---

### Example 6: Scene Cleanup

```
@godot Clean up my scene:

1. Get the current scene tree
2. Identify nodes without scripts that might be unused
3. Find sprites without textures
4. Find collision shapes without shapes
5. List nodes with duplicate names
6. Suggest which nodes can be removed or need fixing
7. Show me a screenshot with the issues highlighted
```

**Expected Result**: List of issues with suggestions for cleanup.

---

## 🎨 Creative Examples

### Example 7: Particle Effects System

```
@godot Create a particle effects system:

1. Scene "res://scenes/effects/hit_effect.tscn" with Node2D root

2. Add GPUParticles2D nodes for:
   - Spark particles (burst effect)
   - Smoke particles (lingering effect)

3. Configure particle properties:
   - Emission shape: sphere
   - Lifetime: 0.5s
   - Initial velocity: random
   - Colors: white to orange gradient

4. Script that:
   - Plays effect when called
   - Auto-deletes after animation
   - Can be instanced anywhere

5. Show me what it looks like in the editor
```

**Expected Result**: Reusable particle effect system.

---

### Example 8: Dialog System

```
@godot Build a dialog system:

1. Scene "res://scenes/ui/dialog_box.tscn" with Control root

2. Create panel at bottom of screen with:
   - Character name label
   - Dialog text (RichTextLabel)
   - Portrait image (TextureRect)
   - Continue indicator (animated)

3. Script "res://scripts/ui/dialog_box.gd" with:
   - Queue system for multiple messages
   - Typewriter effect for text
   - Skip text on click
   - Character portrait swapping
   - Signal when dialog finishes

4. Example dialog data structure in JSON

5. Show me the UI and script
```

**Expected Result**: Complete dialog system ready for narrative games.

---

## 🔧 Advanced Examples

### Example 9: Save/Load System

```
@godot Implement a save/load system:

1. Create script "res://scripts/systems/save_manager.gd" as autoload

2. Implement:
   - Save player data (position, health, inventory)
   - Save world state (collected items, door states)
   - Save to user:// directory as JSON
   - Load game state on start
   - Multiple save slots support

3. Add encryption for save files

4. Create helper functions:
   - save_game()
   - load_game(slot)
   - delete_save(slot)
   - get_all_saves()

5. Show me the code and explain usage
```

**Expected Result**: Production-ready save/load system.

---

### Example 10: Inventory System

```
@godot Build an inventory system:

1. Scene "res://scenes/ui/inventory.tscn" with:
   - GridContainer for item slots
   - ItemSlot scenes (32 slots)
   - Item tooltip popup
   - Drag and drop support

2. Script "res://scripts/systems/inventory.gd":
   - Item data structure
   - Add/remove items
   - Stack items
   - Drag and drop logic
   - Sort inventory
   - Search/filter

3. Script "res://scripts/items/item.gd" base class:
   - Name, description, icon
   - Stack size
   - Item type enum
   - Use() virtual method

4. Example items: Potion, Sword, Shield

5. Show me the system with screenshots
```

**Expected Result**: Complete inventory system with UI and logic.

---

## 🐛 Debugging Examples

### Example 11: Track Down Null Reference Error

```
@godot I'm getting a null reference error. Help debug:

1. Get all current errors from Godot
2. Show me the stack trace
3. View the script where error occurs
4. Show me the scene tree
5. Identify which node reference is null
6. Suggest fixes with code examples
7. Capture screenshot showing the problem area
```

**Expected Result**: Root cause identified with solution.

---

### Example 12: Fix Physics Issues

```
@godot My character is falling through floors:

1. Get scene tree and show collision layers
2. Check CharacterBody2D properties
3. Verify collision shapes are not disabled
4. Check if floor detection is working
5. Show me the physics settings
6. Test with execute_editor_script to check collision
7. Suggest fixes
```

**Expected Result**: Physics issue diagnosed and resolved.

---

## 📚 Learning Examples

### Example 13: Understand Existing Code

```
@godot Explain how my code works:

1. View "res://scripts/player_controller.gd"
2. List all methods and what they do
3. Show me the node properties it accesses
4. Identify any Godot-specific patterns used
5. Suggest improvements for readability
6. Add comments explaining complex parts
```

**Expected Result**: Better understanding of existing codebase.

---

### Example 14: Learn Godot Best Practices

```
@godot Review my project for best practices:

1. Analyze project structure
2. Check script organization
3. Identify anti-patterns
4. Suggest folder structure improvements
5. Review naming conventions
6. Check for proper use of signals
7. Verify resource management
8. Performance best practices
```

**Expected Result**: Comprehensive code review with learning points.

---

## 🚀 Rapid Prototyping Examples

### Example 15: Quick Game Jam Prototype

```
@godot Speed-build a simple shooter game:

1. Player scene with:
   - Ship sprite
   - Movement (WASD)
   - Shooting (spacebar spawns bullet)

2. Bullet scene with:
   - Moves upward
   - Destroys on leaving screen

3. Enemy scene with:
   - Moves downward
   - Shoots occasionally
   - Health = 3

4. Main scene with:
   - Spawn enemies every 2 seconds
   - Score counter
   - Game over on player death

5. Simple UI with health and score

Create all scenes and scripts, then show me screenshots of each scene
```

**Expected Result**: Playable prototype in minutes.

---

## 💡 Tips for Better Results

### Be Specific
❌ "Make a player"
✅ "Create a CharacterBody2D player with sprite, collision, and camera"

### Request Verification
Always ask to see results:
- "Show me a screenshot"
- "Show me the scene tree"
- "Verify the code works"

### Iterate Incrementally
Build step-by-step:
1. Create basic structure
2. Add functionality
3. Test
4. Refine

### Use Context
Start with:
```
@godot get windsurf context
```

Then make informed changes based on your current project state.

---

## 🎯 Pro Workflows

### Workflow: Test-Driven Development

```
1. @godot create a test scene for my player
2. @godot add debug nodes to visualize collision
3. @godot execute test script to verify movement
4. @godot capture screenshot showing test results
5. @godot fix any issues found
```

### Workflow: Collaborative Development

```
1. @godot show me recent changes (get recent files)
2. @godot analyze dependencies to see what's affected
3. @godot check for errors before committing
4. @godot capture state for documentation
```

### Workflow: Performance Optimization

```
1. @godot get performance metrics during gameplay
2. @godot analyze each script for bottlenecks
3. @godot suggest optimizations
4. @godot apply changes incrementally
5. @godot re-test performance
```

---

<div align="center">

**More examples coming soon!**

Share your workflows in [Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)

[⬆ Back to Top](#usage-examples---godot-mcp-enhanced)

</div>


---

## 🎮 Runtime Operations Examples (NEW!)

### Example 16: Asset-Based Game Creation

**Scenario**: You have assets in your project and want AI to use them automatically.

```
@godot I have these assets in my project:
- res://sprites/knight.png
- res://sprites/enemy_slime.png
- res://models/sword.glb
- res://sounds/sword_swing.wav
- res://sounds/jump.wav

Create a 3D action game using these assets with:
1. A knight character using the sprite and sword model
2. Slime enemies
3. Sound effects for actions
4. Test the gameplay with input simulation
```

**AI Actions**:
```
1. @godot get_assets_by_type asset_type="texture"
   → Discovers knight.png, enemy_slime.png

2. @godot get_assets_by_type asset_type="3d"
   → Discovers sword.glb

3. @godot get_assets_by_type asset_type="audio"
   → Discovers sword_swing.wav, jump.wav

4. @godot create_scene path="res://scenes/game.tscn" root_type="Node3D"

5. Create Knight Character:
   @godot add_node node_type="CharacterBody3D" node_name="Knight"
   @godot add_node parent_path="Knight" node_type="Sprite3D" node_name="Sprite"
   @godot update_property node_path="Knight/Sprite" property="texture" value="res://sprites/knight.png"
   @godot add_node parent_path="Knight" node_type="MeshInstance3D" node_name="Sword"
   @godot update_property node_path="Knight/Sword" property="mesh" value="res://models/sword.glb"

6. Add Sound Effects:
   @godot add_node parent_path="Knight" node_type="AudioStreamPlayer3D" node_name="SwingSound"
   @godot update_property node_path="Knight/SwingSound" property="stream" value="res://sounds/sword_swing.wav"
   @godot add_node parent_path="Knight" node_type="AudioStreamPlayer3D" node_name="JumpSound"
   @godot update_property node_path="Knight/JumpSound" property="stream" value="res://sounds/jump.wav"

7. Create Enemy:
   @godot add_node node_type="CharacterBody3D" node_name="Slime"
   @godot add_node parent_path="Slime" node_type="Sprite3D" node_name="Sprite"
   @godot update_property node_path="Slime/Sprite" property="texture" value="res://sprites/enemy_slime.png"

8. Test Gameplay:
   @godot play_scene
   @godot get_input_actions
   @godot simulate_action action_name="jump" pressed=true
   @godot get_running_scene_screenshot
   @godot stop_running_scene
```

**Expected Result**: Complete 3D game using YOUR assets, not placeholders!

---

### Example 17: Plugin-Enhanced Development

**Scenario**: You have the "Dialogue Manager" plugin installed.

```
@godot I have the Dialogue Manager plugin installed.
Create a conversation system with:
1. Dialogue UI with character portraits
2. Multiple conversation branches
3. Choice system
4. Test the dialogue flow
```

**AI Actions**:
```
1. @godot get_installed_plugins
   → Discovers: dialogue_manager (enabled)

2. @godot get_plugin_info plugin_name="dialogue_manager"
   → Returns: Available nodes: DialogueLabel, DialogueManager, DialogueResource

3. @godot create_scene path="res://scenes/dialogue_ui.tscn" root_type="Control"

4. Add Plugin Nodes:
   @godot add_node node_type="DialogueLabel" node_name="DialogueDisplay"
   @godot add_node node_type="DialogueManager" node_name="Manager"
   @godot add_node node_type="TextureRect" node_name="Portrait"

5. Create Dialogue Resource:
   @godot create_script path="res://dialogues/intro.dialogue" content="
   ~ start
   Knight: Greetings, traveler!
   - Hello! => friendly
   - Who are you? => suspicious
   
   ~ friendly
   Knight: Welcome to our village!
   => END
   
   ~ suspicious
   Knight: I am the village guardian.
   => END
   "

6. Create Controller:
   @godot create_script path="res://scripts/dialogue_controller.gd"
   @godot attach_script node_path="Manager" script_path="res://scripts/dialogue_controller.gd"

7. Test Dialogue:
   @godot play_scene
   @godot simulate_key_press keycode=4194309  # Enter key
   @godot get_running_scene_screenshot
```

**Expected Result**: Complete dialogue system using YOUR plugin!

---

### Example 18: Automated Gameplay Testing

**Scenario**: Test your platformer's movement and jumping mechanics.

```
@godot Test my platformer game:
1. Test player movement (left, right)
2. Test jumping mechanics
3. Test collision detection
4. Verify performance is stable
5. Provide visual proof
```

**AI Actions**:
```
1. Start Game:
   @godot play_scene path="res://scenes/game.tscn"
   @godot get_running_scene_screenshot  # Initial state

2. Get Available Actions:
   @godot get_input_actions
   → Returns: {move_left, move_right, jump, attack}

3. Test Right Movement:
   @godot get_node_properties node_path="Player"
   → Initial position: [100, 200]
   
   @godot simulate_action action_name="move_right" pressed=true
   # Wait 1 second
   @godot get_node_properties node_path="Player"
   → New position: [250, 200] ✓ Movement works!
   
   @godot simulate_action action_name="move_right" pressed=false

4. Test Left Movement:
   @godot simulate_action action_name="move_left" pressed=true
   # Wait 1 second
   @godot get_node_properties node_path="Player"
   → Position decreased ✓
   @godot simulate_action action_name="move_left" pressed=false

5. Test Jumping:
   @godot get_node_properties node_path="Player"
   → velocity.y: 0
   
   @godot simulate_action action_name="jump" pressed=true
   @godot get_node_properties node_path="Player"
   → velocity.y: -400 ✓ Jump initiated!
   
   @godot get_running_scene_screenshot  # Player in air

6. Test Collision:
   @godot simulate_action action_name="move_right" pressed=true
   # Move towards wall
   @godot get_node_properties node_path="Player"
   → Position stopped at wall ✓ Collision works!

7. Check Performance:
   @godot get_runtime_stats
   → FPS: 60, Draw Calls: 45, Memory: 50MB ✓ Performance good!

8. Final Screenshot:
   @godot get_running_scene_screenshot
   @godot stop_running_scene
```

**Expected Result**: Complete automated test with visual proof and performance metrics!

---

### Example 19: Performance Optimization

**Scenario**: Your game is running slowly and needs optimization.

```
@godot My game is running at 25 FPS. Help me optimize it:
1. Analyze current performance
2. Identify bottlenecks
3. Apply optimizations
4. Verify improvements
```

**AI Actions**:
```
1. Measure Baseline:
   @godot play_scene path="res://scenes/game.tscn"
   @godot get_runtime_stats
   → FPS: 25 (LOW!)
   → Draw Calls: 500 (HIGH!)
   → Memory: 200MB (HIGH!)
   → Vertices: 50000 (HIGH!)

2. Analyze Scene:
   @godot stop_running_scene
   @godot get_scene_tree
   → Found: 200 individual Sprite2D nodes
   → Found: No texture atlasing
   → Found: Complex collision shapes

3. Identify Issues:
   - Too many draw calls from individual sprites
   - No sprite batching
   - Inefficient collision shapes
   - Memory leaks in scripts

4. Apply Optimizations:
   
   a) Convert sprites to TileMap:
   @godot add_node node_type="TileMap" node_name="Ground"
   # Configure tilemap with sprite atlas
   
   b) Simplify collision:
   @godot update_property node_path="Player/Collision" property="shape" value="CapsuleShape2D"
   
   c) Fix script memory leaks:
   @godot view_script path="res://scripts/enemy.gd"
   # Identify: Not freeing resources in _exit_tree()
   @godot edit_file path="res://scripts/enemy.gd" operation="insert" line=50 content="
   func _exit_tree():
       # Free resources
       if texture:
           texture = null
   "
   
   d) Enable texture filtering:
   @godot update_property node_path="Player/Sprite" property="texture_filter" value="1"

5. Verify Improvements:
   @godot play_scene
   @godot get_runtime_stats
   → FPS: 60 (GOOD! +140% improvement)
   → Draw Calls: 50 (GOOD! -90% reduction)
   → Memory: 80MB (GOOD! -60% reduction)
   → Vertices: 5000 (GOOD! -90% reduction)
   
   @godot get_running_scene_screenshot
   @godot stop_running_scene
```

**Expected Result**: Game optimized from 25 FPS to 60 FPS with visual proof!

---

### Example 20: Runtime Debugging

**Scenario**: Player isn't jumping correctly, need to debug.

```
@godot My player isn't jumping correctly. Debug the issue:
1. Inspect player state
2. Test jump method
3. Identify the bug
4. Fix it
5. Verify the fix works
```

**AI Actions**:
```
1. Start Game and Inspect:
   @godot play_scene
   @godot get_node_properties node_path="Player"
   → position: [100, 200]
   → velocity: [0, 0]
   → is_on_floor: true
   → gravity: 980

2. Test Jump Action:
   @godot simulate_action action_name="jump" pressed=true
   @godot get_node_properties node_path="Player"
   → velocity: [0, 0]  # BUG! Velocity didn't change!

3. Test Jump Method Directly:
   @godot call_node_method node_path="Player" method_name="jump" args=[]
   @godot get_node_properties node_path="Player"
   → velocity: [0, 0]  # Still not working!

4. Analyze Script:
   @godot stop_running_scene
   @godot view_script path="res://scripts/player.gd"
   
   # Found the bug:
   func jump():
       if is_on_floor():
           velocity.y = JUMP_VELOCITY  # This line exists
   
   # But JUMP_VELOCITY is defined as:
   const JUMP_VELOCITY = 400  # BUG! Should be negative!

5. Fix the Bug:
   @godot edit_file path="res://scripts/player.gd" operation="replace" 
   old_content="const JUMP_VELOCITY = 400"
   new_content="const JUMP_VELOCITY = -400"

6. Verify Fix:
   @godot play_scene
   @godot simulate_action action_name="jump" pressed=true
   @godot get_node_properties node_path="Player"
   → velocity: [0, -400]  # FIXED! Player is jumping!
   
   @godot get_running_scene_screenshot  # Player in air
   @godot stop_running_scene
```

**Expected Result**: Bug identified and fixed with visual proof!

---

### Example 21: Multi-Asset Game Prototype

**Scenario**: Rapid prototyping using all available assets.

```
@godot Create a complete game prototype using all my project assets:
1. Discover all assets (sprites, models, sounds)
2. Create a game scene using them
3. Add gameplay mechanics
4. Test everything
5. Show me the result
```

**AI Actions**:
```
1. Asset Discovery:
   @godot get_assets_by_type asset_type="texture"
   → Found: player.png, enemy1.png, enemy2.png, coin.png, background.png
   
   @godot get_assets_by_type asset_type="audio"
   → Found: jump.wav, coin.wav, hit.wav, music.ogg
   
   @godot get_assets_by_type asset_type="scene"
   → Found: player.tscn, enemy.tscn

2. Create Game Scene:
   @godot create_scene path="res://scenes/level1.tscn" root_type="Node2D"
   
   # Add background
   @godot add_node node_type="Sprite2D" node_name="Background"
   @godot update_property node_path="Background" property="texture" value="res://sprites/background.png"
   
   # Add player (use existing scene)
   @godot add_scene parent_path="." scene_path="res://scenes/player.tscn"
   
   # Add enemies
   @godot add_scene parent_path="." scene_path="res://scenes/enemy.tscn" instance_name="Enemy1"
   @godot update_property node_path="Enemy1" property="position" value="[300, 200]"
   
   @godot add_scene parent_path="." scene_path="res://scenes/enemy.tscn" instance_name="Enemy2"
   @godot update_property node_path="Enemy2" property="position" value="[500, 200]"
   
   # Add collectibles
   @godot add_node node_type="Sprite2D" node_name="Coin1"
   @godot update_property node_path="Coin1" property="texture" value="res://sprites/coin.png"
   @godot update_property node_path="Coin1" property="position" value="[200, 150]"
   
   # Add audio
   @godot add_node node_type="AudioStreamPlayer" node_name="Music"
   @godot update_property node_path="Music" property="stream" value="res://sounds/music.ogg"
   @godot update_property node_path="Music" property="autoplay" value="true"

3. Test Gameplay:
   @godot play_scene
   @godot get_input_actions
   
   # Test movement
   @godot simulate_action action_name="move_right" pressed=true
   @godot get_running_scene_screenshot
   
   # Test jumping
   @godot simulate_action action_name="jump" pressed=true
   @godot get_running_scene_screenshot
   
   # Check performance
   @godot get_runtime_stats
   → FPS: 60, Draw Calls: 25, Memory: 45MB ✓
   
   @godot stop_running_scene

4. Final Screenshot:
   @godot get_editor_screenshot
```

**Expected Result**: Complete game prototype using ALL your assets!

---

### Example 22: Plugin + Asset Integration

**Scenario**: Combine plugin features with project assets.

```
@godot I have:
- Dialogue Manager plugin installed
- Character portraits in res://portraits/
- Background music in res://music/

Create a visual novel scene with:
1. Dialogue system using the plugin
2. Character portraits from my assets
3. Background music
4. Test the dialogue flow
```

**AI Actions**:
```
1. Discover Resources:
   @godot get_installed_plugins
   → Found: dialogue_manager
   
   @godot get_assets_by_type asset_type="texture"
   → Found: portraits/knight.png, portraits/wizard.png
   
   @godot get_assets_by_type asset_type="audio"
   → Found: music/menu_theme.ogg

2. Create Scene:
   @godot create_scene path="res://scenes/visual_novel.tscn" root_type="Control"
   
   # Add background
   @godot add_node node_type="ColorRect" node_name="Background"
   @godot set_anchor_preset node_path="Background" preset="full_rect"
   @godot update_property node_path="Background" property="color" value="[0.1, 0.1, 0.2, 1.0]"
   
   # Add character portraits
   @godot add_node node_type="TextureRect" node_name="LeftPortrait"
   @godot update_property node_path="LeftPortrait" property="texture" value="res://portraits/knight.png"
   @godot update_property node_path="LeftPortrait" property="position" value="[50, 100]"
   
   @godot add_node node_type="TextureRect" node_name="RightPortrait"
   @godot update_property node_path="RightPortrait" property="texture" value="res://portraits/wizard.png"
   @godot update_property node_path="RightPortrait" property="position" value="[600, 100]"
   
   # Add dialogue system (plugin nodes)
   @godot add_node node_type="DialogueLabel" node_name="DialogueText"
   @godot add_node node_type="DialogueManager" node_name="Manager"
   
   # Add music
   @godot add_node node_type="AudioStreamPlayer" node_name="BGM"
   @godot update_property node_path="BGM" property="stream" value="res://music/menu_theme.ogg"
   @godot update_property node_path="BGM" property="autoplay" value="true"

3. Create Dialogue:
   @godot create_script path="res://dialogues/chapter1.dialogue" content="
   ~ start
   Knight: The ancient evil has awakened!
   Wizard: We must gather the sacred artifacts.
   - Let's go! => quest_start
   - Tell me more. => more_info
   
   ~ quest_start
   Knight: To the mountains!
   => END
   
   ~ more_info
   Wizard: The artifacts are scattered across the realm.
   => quest_start
   "

4. Test Dialogue:
   @godot play_scene
   @godot get_running_scene_screenshot  # Initial state
   
   @godot simulate_key_press keycode=4194309  # Enter - advance dialogue
   @godot get_running_scene_screenshot
   
   @godot simulate_key_press keycode=4194309  # Enter - advance again
   @godot get_running_scene_screenshot
   
   @godot stop_running_scene
```

**Expected Result**: Visual novel scene combining plugin features with your assets!

---

## 💡 Tips for Runtime Operations

### Asset Discovery
- **Always check assets first** before creating placeholder content
- Use `get_assets_by_type` to see what's available
- Use `get_asset_info` to understand asset properties

### Plugin Integration
- Check `get_installed_plugins` to see what's available
- Use `get_plugin_info` to understand plugin features
- Test plugin nodes incrementally

### Input Simulation
- Get `get_input_actions` first to know what's available
- Simulate realistic input (press then release)
- Use `get_node_properties` to verify results
- Always get screenshots for visual proof

### Performance Testing
- Measure baseline with `get_runtime_stats` first
- Make one change at a time
- Verify improvements after each change
- Monitor continuously during development

### Debugging
- Start with `get_node_properties` to inspect state
- Use `call_node_method` to test methods directly
- Get screenshots to visualize issues
- Check `get_runtime_stats` for performance impact

---

## 🎯 Pro Tips

### Combine Multiple Features
```
@godot Create a complete game:
1. Discover all my assets
2. Detect installed plugins
3. Build a game scene using both
4. Test with input simulation
5. Monitor performance
6. Show me screenshots at each step
```

### Iterative Testing
```
@godot Test my game incrementally:
1. Test movement → screenshot
2. Test jumping → screenshot
3. Test combat → screenshot
4. Check performance after each test
```

### Asset-Driven Development
```
@godot Analyze my assets and suggest a game genre:
1. List all textures
2. List all sounds
3. List all models
4. Suggest what type of game I can make
5. Create a prototype
```

---

<div align="center">

**With runtime operations, AI can now build complete, asset-rich games with minimal intervention!** 🚀🎮🤖

</div>
