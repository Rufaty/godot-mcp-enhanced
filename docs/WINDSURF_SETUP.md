# Windsurf AI Setup Guide for Godot MCP Enhanced

This guide will help you set up and maximize the potential of Godot MCP Enhanced with Windsurf AI.

---

## 🌊 Why Windsurf + Godot MCP Enhanced?

Windsurf AI's unique capabilities combined with this MCP server create a powerful game development workflow:

- **Visual Understanding** - Windsurf can see your editor and game through screenshots
- **Context Awareness** - Deep understanding of your project structure and state
- **Streaming Updates** - Real-time feedback as you make changes
- **Smart Suggestions** - AI knows Godot's API and best practices
- **Error Prevention** - Catches issues before they become problems

---

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ Godot 4.2+ installed
- ✅ Python 3.10+ installed
- ✅ `uv` package manager installed
- ✅ Windsurf AI (latest version)
- ✅ Godot MCP Enhanced plugin installed in your project

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Start the Godot Plugin

1. Open your Godot project
2. Go to the **MCP Enhanced** tab in the bottom panel
3. Click **Start Server** (if not already running)
4. You should see "Running on port 3571"

### Step 2: Install Python Server

```bash
cd path/to/godot-mcp-enhanced/python
uv venv
uv pip install -e .
```

### Step 3: Configure Windsurf

**Option A: Project-Specific (Recommended)**

Create `.windsurf/mcp.json` in your Godot project:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "uv",
      "args": [
        "run",
        "python",
        "-m",
        "mcp_server"
      ],
      "cwd": "C:/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true"
      }
    }
  }
}
```

**Option B: Global Configuration**

Edit Windsurf's global config (Settings → MCP Servers → Add New):

- **Name**: godot-mcp-enhanced
- **Command**: `uv run python -m mcp_server`
- **Working Directory**: `path/to/godot-mcp-enhanced/python`
- **Environment Variables**: Copy from above

### Step 4: Verify Setup

1. Restart Windsurf
2. Open your Godot project folder in Windsurf
3. In chat, type: `@godot get_project_info`
4. You should see your project details!

---

## 💡 Windsurf Power User Tips

### 1. **Always Use @godot Mentions**

Windsurf works best when you explicitly mention the MCP server:

```
@godot create a player scene with CharacterBody2D
```

### 2. **Request Visual Feedback**

Get screenshots to verify changes:

```
@godot show me the current scene with a screenshot
```

### 3. **Use Live Preview**

Get comprehensive context in one command:

```
@godot get live preview
```

This returns:
- Screenshot of editor
- Current scene tree
- Active script content

### 4. **Context-First Workflow**

Start conversations by gathering context:

```
@godot get windsurf context
```

This gives Windsurf:
- Current scene name
- Open scripts
- Recent errors
- Project structure overview
- Editor state

### 5. **Iterative Development**

Make changes incrementally and verify:

```
@godot create a sprite node named "Player"
@godot add a collision shape to Player node
@godot show me a screenshot of the scene
@godot now add a script to Player that moves with arrow keys
```

---

## 🎯 Common Workflows

### Workflow 1: Building a New Scene

```
@godot I want to create a main menu scene. Here's what I need:

1. Create scene at "res://scenes/menus/main_menu.tscn" with Control root
2. Add a ColorRect as background (full screen with dark blue color)
3. Add centered VBoxContainer with these buttons:
   - "Start Game"
   - "Options" 
   - "Quit"
4. Create and attach a script that handles button presses
5. Show me a screenshot when done

Use proper anchors so it scales on different resolutions.
```

### Workflow 2: Debugging Issues

```
@godot I'm getting an error. Help me debug:

1. Get current errors from Godot
2. Show me the scene tree
3. Capture a screenshot of the editor
4. Analyze the error and suggest fixes
5. Check for common issues like missing resources
```

### Workflow 3: Code Refactoring

```
@godot Refactor my player script:

1. View the current player.gd script
2. Cache all get_node calls in _ready() instead of using them in _process()
3. Add proper type hints
4. Validate the syntax
5. Show me the changes
```

### Workflow 4: Performance Optimization

```
@godot Analyze my project's performance:

1. Get performance metrics
2. Check all scripts for performance issues
3. Analyze the current scene for optimization opportunities
4. Suggest specific improvements
5. Show me the scene with a screenshot to understand the context
```

---

## 🔥 Advanced Features

### Auto-Screenshot on Errors

When enabled, the plugin automatically captures screenshots when errors occur:

```json
{
  "env": {
    "SCREENSHOT_ON_ERROR": "true"
  }
}
```

Then in Windsurf:
```
@godot check recent errors with screenshots
```

### Scene Change Monitoring

Automatically capture when you switch scenes:

```json
{
  "env": {
    "SCREENSHOT_ON_SCENE_CHANGE": "true"
  }
}
```

### Performance Profiling

```
@godot analyze script performance for "res://scripts/player.gd"
```

Gets detailed analysis of:
- Potential performance issues
- Inefficient patterns
- Optimization suggestions

### Dependency Analysis

```
@godot analyze project dependencies
```

Shows:
- Which scenes depend on which scripts
- Resource dependencies
- Potential circular dependencies

---

## 🎨 Creative Use Cases

### 1. **AI-Assisted Scene Design**

```
@godot I'm making a 2D platformer level. Create:

1. A Node2D scene named "Level1"
2. TileMap for the ground
3. Player spawn point (Marker2D)
4. 3 enemy spawn points
5. Collectible items (5 coins as Area2D nodes)
6. Level exit (Area2D with visual indicator)

Show me the scene tree and a screenshot when done.
```

### 2. **Rapid Prototyping**

```
@godot Quickly prototype a card game:

1. Create CardBase scene (Control node)
2. Add card visual (Panel with rounded corners)
3. Add title (Label) and description (RichTextLabel)
4. Add card stats (HBoxContainer with icons and values)
5. Create script with hover effects and click handling
6. Create a test scene with 3 card instances

Show me screenshots of the card design.
```

### 3. **Interactive Debugging**

```
@godot My character isn't moving correctly. Debug this:

1. Show me the current scene tree
2. Get the player script content
3. Check for errors in the output
4. Analyze the CharacterBody2D properties
5. Capture a screenshot of the scene
6. Suggest what might be wrong based on the code and scene setup
```

### 4. **Documentation Generation**

```
@godot Generate documentation for my project:

1. List all scenes with their purpose
2. List all scripts with their main functions
3. Show the project structure
4. Identify which scripts are attached to which nodes
5. Create a markdown file summarizing everything
```

---

## 🛠️ Troubleshooting

### Windsurf Can't Find MCP Server

**Problem**: Windsurf shows "Server not found" error

**Solutions**:
1. Verify server is running in Godot's MCP Enhanced tab
2. Check `.windsurf/mcp.json` paths are absolute
3. Restart Windsurf after config changes
4. Try running manually: `cd python && uv run python -m mcp_server`

### Connection Timeout

**Problem**: Tools timeout without response

**Solutions**:
1. Increase timeout in Windsurf settings
2. Check Godot is not frozen
3. Verify port 3571 is not blocked by firewall
4. Check Godot console for errors

### Screenshots Not Appearing

**Problem**: Screenshot tools return empty data

**Solutions**:
1. Ensure Godot editor window is visible (not minimized)
2. Check DisplayServer permissions on your OS
3. Verify Godot version is 4.2+
4. Try manual screenshot: `@godot get_editor_screenshot`

### Tool Calls Fail

**Problem**: Individual tools return errors

**Solutions**:
1. Check Godot's Output tab for errors
2. Verify scene is open when using scene tools
3. Check file paths use "res://" format
4. Look at Godot's MCP Enhanced tab for connection status

---

## 📊 Performance Tips

### Optimize Screenshot Frequency

Screenshots can be expensive. Configure wisely:

```json
{
  "env": {
    "AUTO_SCREENSHOT": "true",
    "SCREENSHOT_ON_SCENE_CHANGE": "true",
    "SCREENSHOT_ON_ERROR": "true"
  }
}
```

Disable auto-screenshot if you don't need visual feedback:
```json
{
  "env": {
    "AUTO_SCREENSHOT": "false"
  }
}
```

### Use Compact Tools

For better performance, use compact versions:

```
@godot get windsurf context  // Lightweight overview
```

Instead of:
```
@godot get scene tree, get open scripts, get errors, get screenshot
```

### Batch Operations

Group related operations:

```
@godot In one operation:
1. Create player scene
2. Add sprite, collision, and camera nodes
3. Create and attach script
4. Show me the result
```

---

## 🎓 Best Practices

### 1. **Clear Instructions**

❌ Bad:
```
@godot make a player
```

✅ Good:
```
@godot Create a player scene at "res://scenes/player.tscn" with:
- CharacterBody2D as root named "Player"
- Sprite2D child named "Sprite"
- CollisionShape2D child named "Collision" with RectangleShape2D
- Script at "res://scripts/player.gd" with basic movement
```

### 2. **Verify Before Building**

```
@godot Before I start building my boss fight scene, show me:
1. Current project structure
2. Existing enemy scripts I can reference
3. Screenshot of similar scenes
```

### 3. **Incremental Development**

```
Step 1: @godot create the UI scene structure
(verify)
Step 2: @godot add the button styling
(verify)
Step 3: @godot create the script for button handlers
```

### 4. **Use Context**

```
@godot Get the current context, then help me refactor this script based on the project's existing code style
```

### 5. **Learn from Errors**

```
@godot I got this error: [paste error]
Show me the scene structure and relevant script, then suggest fixes
```

---

## 🚀 Next Steps

Now that you're set up:

1. **Try the example workflows** in this guide
2. **Experiment** with different tool combinations
3. **Join the community** - share your workflows!
4. **Read the full documentation** for advanced features
5. **Provide feedback** - help us improve!

---

## 📚 Additional Resources

- [Main Documentation](../README.md)
- [Tool Reference](./TOOLS.md)
- [Example Prompts](./EXAMPLES.md)
- [GitHub Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)

---

## 💬 Community

Share your Windsurf + Godot workflows:

- [GitHub Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)
- [Issue Tracker](https://github.com/Rufaty/godot-mcp-enhanced/issues)

---

<div align="center">

**Happy Game Development with AI! 🎮🤖**

[⬆ Back to Top](#windsurf-ai-setup-guide-for-godot-mcp-enhanced)

</div>
