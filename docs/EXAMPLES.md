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
