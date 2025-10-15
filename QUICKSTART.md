# Quick Start Guide

Get Godot MCP Enhanced running in 5 minutes!

---

## Prerequisites

Before starting, install:

1. **Godot Engine 4.2+** - [Download](https://godotengine.org/download)
2. **Python 3.10+** - [Download](https://www.python.org/downloads/)
3. **uv** (Python package manager):
   ```bash
   # Windows
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

---

## Step 1: Install Godot Plugin (2 minutes)

1. **Download** this repository or clone it:
   ```bash
   git clone https://github.com/Rufaty/godot-mcp-enhanced.git
   ```

2. **Copy the plugin** to your Godot project:
   ```
   Copy: godot-mcp-enhanced/addons/godot_mcp_enhanced/
   To:   your-project/addons/godot_mcp_enhanced/
   ```

3. **Open your project** in Godot

4. **Enable the plugin**:
   - Go to **Project → Project Settings → Plugins**
   - Find **Godot MCP Enhanced**
   - Click the checkbox to enable it

5. **Verify it's running**:
   - Look at the bottom panel
   - You should see a new **"MCP Enhanced"** tab
   - It should show: **"Server Running on port 3571"** ✅

---

## Step 2: Install Python Server (2 minutes)

```bash
cd godot-mcp-enhanced/python
uv venv
uv pip install -e .
```

That's it! The Python server is installed.

---

## Step 3: Configure Your AI Tool (1 minute)

Choose your AI tool:

### Kiro IDE

Create `.kiro/settings/mcp.json` in your Godot project root:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "uv",
      "args": ["run", "python", "-m", "mcp_server"],
      "cwd": "D:/path/to/godot-mcp-enhanced/python",
      "env": {
        "GODOT_HOST": "127.0.0.1",
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    }
  }
}
```

**Important**: Change `"cwd"` to your actual path!

### Claude Desktop

Edit `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "uv",
      "args": ["run", "python", "-m", "mcp_server"],
      "cwd": "/path/to/godot-mcp-enhanced/python",
      "env": {
        "GODOT_HOST": "127.0.0.1",
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    }
  }
}
```

### Other Tools

See [CLI Setup Guide](docs/CLI_SETUP.md) for:
- Cursor
- Windsurf
- Gemini CLI
- Aider
- Continue

---

## Step 4: Test It! (30 seconds)

1. **Restart your AI tool** (Kiro, Claude, etc.)

2. **Open your Godot project** in the AI tool

3. **Try these commands**:

```
@godot get_project_info
```

You should see your project information!

```
@godot get_editor_screenshot
```

You should see a screenshot of your Godot editor!

```
@godot create a simple player scene with a Sprite2D and CollisionShape2D
```

Watch as AI creates a complete scene for you!

---

## 🎉 You're Ready!

Godot MCP Enhanced is now running. Here's what you can do:

### Try These Examples

#### Example 1: Create a Player Character
```
Create a 2D player character with:
- CharacterBody2D as root
- AnimatedSprite2D for graphics
- CollisionShape2D for physics
- A script that handles WASD movement and jumping
```

#### Example 2: Use Your Assets
```
@godot get_assets_by_type asset_type="texture"

Now create a game scene using the sprites you found
```

#### Example 3: Test Your Game
```
@godot play_scene path="res://scenes/game.tscn"
@godot simulate_action action_name="jump" pressed=true
@godot get_running_scene_screenshot
@godot stop_running_scene
```

---

## 📚 Next Steps

### Learn More

- **[Runtime Features](docs/RUNTIME_FEATURES.md)** - Input simulation, asset discovery, testing
- **[Examples](docs/EXAMPLES.md)** - Real-world usage examples
- **[AI Instructions](AI_INSTRUCTIONS.md)** - Comprehensive AI guidance

### Explore Features

- **Asset Discovery**: `@godot get_assets_by_type asset_type="texture"`
- **Plugin Detection**: `@godot get_installed_plugins`
- **Performance Monitoring**: `@godot get_runtime_stats`
- **Input Simulation**: `@godot simulate_key_press keycode=32`

### Get Help

- **Issues**: [GitHub Issues](https://github.com/Rufaty/godot-mcp-enhanced/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)
- **Documentation**: [Full Docs](docs/)

---

## 🐛 Troubleshooting

### Plugin Not Showing Up

- Make sure you copied to `res://addons/godot_mcp_enhanced/`
- Enable it in Project Settings → Plugins
- Restart Godot

### "Server Running" Not Showing

- Check Godot console for errors
- Verify port 3571 is not in use
- Try restarting Godot

### AI Tool Not Detecting Server

- Verify Python server is installed (`uv pip list` should show `mcp`)
- Check MCP config file has correct paths
- Restart your AI tool after config changes
- Make sure Godot is running with plugin enabled

### Connection Refused Errors

- Ensure Godot is open with your project
- Check the MCP Enhanced tab shows "Server Running"
- Verify firewall isn't blocking port 3571

For more help, see [Testing Guide](TESTING.md).

---

## 🎮 What's Next?

Now that you're set up, try building something amazing:

1. **Start Simple**: Create a basic scene with AI assistance
2. **Use Your Assets**: Let AI discover and use your project assets
3. **Test Automatically**: Use input simulation to test gameplay
4. **Optimize**: Monitor performance with runtime stats
5. **Build Complete Games**: Let AI handle the heavy lifting!

---

<div align="center">

**Happy Game Development!** 🎮🤖

[⬆ Back to Top](#quick-start-guide)

</div>
