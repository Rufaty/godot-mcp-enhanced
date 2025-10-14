# Kiro IDE Setup Guide - Godot MCP Enhanced

Complete guide for using Godot MCP Enhanced with Kiro IDE.

---

## 🎯 Why Kiro + Godot MCP Enhanced?

Kiro IDE provides excellent AI assistance capabilities, and when combined with Godot MCP Enhanced, you get:

- **Real-time Godot Integration** - AI sees and modifies your game as you build
- **Visual Feedback** - Screenshots show AI exactly what you're working on
- **Complete Control** - 40+ tools for every aspect of game development
- **Smart Context** - AI understands your project structure and state

---

## 📦 Prerequisites

Before starting, ensure you have:

1. **Kiro IDE** installed and running
2. **Godot Engine 4.2+** installed
3. **Python 3.10+** installed
4. **uv** package manager installed

```bash
# Check Python version
python --version

# Install uv (if not installed)
# Windows
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## 🚀 Installation Steps

### Step 1: Install Godot Plugin

1. Download the latest release from [GitHub](https://github.com/Rufaty/godot-mcp-enhanced/releases)
2. Extract and copy `addons/godot_mcp_enhanced/` to your Godot project's `res://addons/` directory
3. Open your project in Godot
4. Go to **Project → Project Settings → Plugins**
5. Enable "Godot MCP Enhanced"
6. Verify the "MCP Enhanced" tab appears in the bottom panel

### Step 2: Install Python MCP Server

```bash
cd path/to/godot-mcp-enhanced/python
uv venv
uv pip install -e .
```

### Step 3: Configure Kiro IDE

#### Option A: Workspace Configuration (Recommended)

Create `.kiro/settings/mcp.json` in your Godot project root:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "D:/CascadeProjects/godot-mcp-enhanced/python/.venv/Scripts/python.exe",
      "args": [
        "-m",
        "mcp_server"
      ],
      "cwd": "D:/CascadeProjects/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true",
        "SCREENSHOT_ON_ERROR": "true",
        "SCREENSHOT_ON_SCENE_CHANGE": "true",
        "GODOT_EXECUTABLE": "D:/Godot 4.5/Godot_v4.5-stable_win64.exe"
      }
    }
  }
}
```

**Important**: Update these paths to match your installation:
- `command`: Path to Python in your virtual environment
- `cwd`: Path to the python directory
- `GODOT_EXECUTABLE`: Path to your Godot executable

#### Option B: User Configuration (Global)

Edit `~/.kiro/settings/mcp.json` (same format as above).

**Note**: Workspace configuration takes precedence over user configuration.

### Step 4: Start the Server

1. Open your Godot project
2. Click on the "MCP Enhanced" tab in Godot's bottom panel
3. Click "Start Server"
4. Verify it shows "Running on port 3571"

### Step 5: Test in Kiro

1. Restart Kiro IDE
2. Open your Godot project in Kiro
3. Try a test command:
   ```
   @godot get_project_info
   ```

**Expected Result**: JSON response with your project information

---

## 🎨 Kiro-Specific Features

### 1. Context-Aware Assistance

Kiro can understand your entire project context:

```
@godot get_windsurf_context
```

This returns:
- Current scene information
- Open scripts
- Recent errors
- Project structure
- Editor state

### 2. Visual Feedback

Request screenshots to help AI understand visual issues:

```
@godot get_editor_screenshot
```

Or get everything at once:

```
@godot get_live_preview
```

### 3. Intelligent Code Generation

Kiro can generate complete game features:

```
Create a complete 2D platformer player with:
- CharacterBody2D with sprite and collision
- Movement with WASD
- Jump with spacebar
- Camera that follows the player
- Smooth animations

@godot [Kiro will use multiple tools automatically]
```

---

## 💡 Pro Tips for Kiro Users

### Tip 1: Use Descriptive Requests

❌ Bad:
```
Make a player
```

✅ Good:
```
Create a 2D platformer player scene at res://scenes/player.tscn with:
- CharacterBody2D root node
- Sprite2D for visuals
- CollisionShape2D with RectangleShape2D
- Camera2D that follows the player
- Movement script with WASD controls and jump
```

### Tip 2: Request Visual Confirmation

Always ask to see the results:

```
@godot create the player scene, then show me a screenshot
```

### Tip 3: Leverage Context

Start complex tasks by getting context:

```
@godot get_windsurf_context

Now based on the current project state, add an enemy system with:
- Enemy scene with AI
- Spawning system
- Health and damage
```

### Tip 4: Incremental Development

Build features step-by-step:

```
1. @godot create the basic enemy scene
2. Show me the scene tree
3. @godot add movement AI to the enemy
4. @godot add player detection
5. @godot add attack behavior
6. Show me a screenshot of the final result
```

### Tip 5: Use Error Checking

Regularly check for issues:

```
@godot check for errors and show me any problems
```

---

## 🔧 Configuration Options

### Environment Variables

You can customize behavior with these environment variables in your `mcp.json`:

```json
{
  "env": {
    "GDAI_MCP_SERVER_PORT": "3571",
    "GDAI_RUNTIME_SERVER_PORT": "3572",
    "AUTO_SCREENSHOT": "true",
    "SCREENSHOT_ON_ERROR": "true",
    "SCREENSHOT_ON_SCENE_CHANGE": "true",
    "GODOT_EXECUTABLE": "path/to/godot.exe",
    "GODOT_CONSOLE_EXECUTABLE": "path/to/godot_console.exe"
  }
}
```

### Auto-Screenshot Settings

- `AUTO_SCREENSHOT`: Enable automatic screenshots (default: true)
- `SCREENSHOT_ON_ERROR`: Capture screenshot when errors occur (default: true)
- `SCREENSHOT_ON_SCENE_CHANGE`: Capture when scene changes (default: true)

### Godot Executable Paths

- `GODOT_EXECUTABLE`: Path to standard Godot executable
- `GODOT_CONSOLE_EXECUTABLE`: Path to console version (for debugging)

---

## 🎮 Example Workflows

### Workflow 1: Create a Complete Game Scene

```
@godot I want to create a main game scene. Here's what I need:

1. Create scene at res://scenes/game.tscn with Node2D root
2. Add a TileMap for the level
3. Add a player instance from res://scenes/player.tscn
4. Add a CanvasLayer with HUD
5. Add a score label and health bar to the HUD
6. Create a game manager script that handles:
   - Score tracking
   - Health management
   - Game over conditions
7. Show me the final scene tree and a screenshot
```

### Workflow 2: Debug and Fix Issues

```
@godot I'm getting errors. Help me debug:

1. Get all current errors
2. Show me the scene tree
3. Show me a screenshot of the editor
4. Analyze the errors and suggest fixes
5. Apply the fixes
6. Verify errors are resolved
```

### Workflow 3: Add New Feature

```
@godot Add a collectible coin system:

1. Create a coin scene with Area2D
2. Add sprite and collision
3. Add collection script that:
   - Detects player
   - Adds to score
   - Plays sound
   - Removes coin
4. Create a coin spawner script
5. Add coins to the game scene
6. Test and show me the result
```

---

## 🐛 Troubleshooting

### Issue: Kiro doesn't detect the MCP server

**Solutions**:
1. Check `.kiro/settings/mcp.json` exists and has correct paths
2. Restart Kiro IDE
3. Verify Godot plugin is running (check MCP Enhanced tab)
4. Check port 3571 is not blocked by firewall

### Issue: Commands timeout

**Solutions**:
1. Ensure Godot is running and not frozen
2. Check Godot's Output tab for errors
3. Restart the HTTP server in MCP Enhanced tab
4. Verify Python server is running

### Issue: Screenshots not working

**Requirements**:
- Godot 4.2+ (uses DisplayServer API)
- Godot editor must be visible (not minimized)
- AUTO_SCREENSHOT enabled in config

**Solutions**:
1. Update Godot to 4.2+
2. Make sure Godot window is visible
3. Check config has `"AUTO_SCREENSHOT": "true"`

### Issue: Tools not appearing in Kiro

**Solutions**:
1. Verify MCP server is configured correctly
2. Check Kiro's MCP settings panel
3. Restart Kiro after configuration changes
4. Check Python server logs for errors

---

## 📊 Performance Tips

### Optimize Screenshot Frequency

If screenshots are slowing things down:

```json
{
  "env": {
    "AUTO_SCREENSHOT": "false",
    "SCREENSHOT_ON_ERROR": "true",
    "SCREENSHOT_ON_SCENE_CHANGE": "false"
  }
}
```

Then request screenshots manually when needed:
```
@godot get_editor_screenshot
```

### Use Batch Operations

Instead of multiple separate commands, combine them:

```
@godot create a complete player scene with all components and script in one go
```

### Cache Context

Get context once, then reference it:

```
@godot get_windsurf_context

[Kiro remembers this context for the conversation]

Now add a feature based on what you see...
```

---

## 🎓 Learning Resources

### Kiro-Specific

- [Kiro Documentation](https://kiro.dev/docs)
- [Kiro MCP Guide](https://kiro.dev/docs/mcp)
- [Kiro AI Features](https://kiro.dev/docs/ai)

### Godot MCP Enhanced

- [AI Instructions](../AI_INSTRUCTIONS.md) - Comprehensive AI guidance
- [Examples](EXAMPLES.md) - Practical usage examples
- [Testing Guide](../TESTING.md) - Verification procedures

### Godot Engine

- [Official Documentation](https://docs.godotengine.org/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/)
- [Best Practices](https://docs.godotengine.org/en/stable/tutorials/best_practices/)

---

## 🚀 Advanced Usage

### Custom Tool Chains

Create complex workflows by chaining tools:

```
@godot Execute this workflow:
1. Get current project state
2. Create enemy scene
3. Add AI behavior
4. Create spawner
5. Add to game scene
6. Test and verify
7. Show final result with screenshot
```

### Automated Testing

Use Kiro to test your game:

```
@godot Run these tests:
1. Check for script errors
2. Verify all scenes load
3. Test player movement
4. Test enemy AI
5. Test UI functionality
6. Report any issues found
```

### Code Review

Get AI code review:

```
@godot Review my player script for:
- Performance issues
- Best practices
- Potential bugs
- Optimization opportunities
```

---

## 🤝 Best Practices

### 1. Start with Context
Always begin complex tasks by getting project context

### 2. Verify Each Step
Use screenshots and error checking to confirm changes

### 3. Be Specific
Provide detailed requirements for better results

### 4. Iterate Incrementally
Build features step-by-step, testing as you go

### 5. Use Visual Feedback
Screenshots help AI understand visual issues

### 6. Check for Errors
Regularly verify no errors were introduced

### 7. Document Changes
Ask AI to explain what it did and why

---

## 📞 Support

If you encounter issues:

1. Check this guide's troubleshooting section
2. Review [TESTING.md](../TESTING.md) for verification steps
3. Check [GitHub Issues](https://github.com/Rufaty/godot-mcp-enhanced/issues)
4. Join [Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)

---

<div align="center">

**Happy Game Development with Kiro! 🎮🤖**

[⬆ Back to Top](#kiro-ide-setup-guide---godot-mcp-enhanced)

</div>
