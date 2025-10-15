# Godot MCP Enhanced

<div align="center">

[![Made with Godot](https://img.shields.io/badge/Made%20with-Godot%204.x-478CBF?style=flat&logo=godot%20engine&logoColor=white)](https://godotengine.org)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![MCP](https://badge.mcpx.dev?type=server)](https://modelcontextprotocol.io/introduction)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**A comprehensive Model Context Protocol (MCP) server that enables AI assistants to interact with Godot Engine in real-time**

[Features](#-features) • [Quick Start](#-quick-start) • [Installation](#-installation) • [Documentation](#-documentation) • [Examples](#-examples)

</div>

---

## 🎯 What is Godot MCP Enhanced?

Godot MCP Enhanced bridges the gap between AI assistants and the Godot game engine, enabling AI to:

- 🎮 **Build complete games** from natural language descriptions
- 🖼️ **See your editor** through real-time screenshots
- 🔍 **Understand your project** with deep context awareness
- ⚡ **Make live changes** that reflect instantly in Godot
- 🎨 **Use your assets** automatically (sprites, models, sounds)
- 🔌 **Integrate plugins** seamlessly
- 🧪 **Test gameplay** with automated input simulation
- 📊 **Optimize performance** with real-time monitoring

### Why Use This?

Traditional AI coding assistants can write code, but they can't:
- See what your game looks like
- Understand your scene structure
- Use your project's assets
- Test if the game actually works
- Debug runtime issues

**Godot MCP Enhanced solves all of these problems.**

---

## ✨ Features

### 🎬 Scene & Node Operations
- Create, open, delete, and manage scenes
- Add, delete, duplicate, move, and configure nodes
- Modify any node property with type safety
- Add and configure resources (textures, shapes, materials)
- Live preview - see changes instantly

### 💻 Script Operations
- Create, view, edit, and attach GDScript files
- Regex-powered find & replace across files
- Syntax validation before execution
- Run arbitrary GDScript in editor context
- View all open scripts with content

### 🎮 Runtime Operations (NEW!)
- **Input Simulation** - Test keyboard, mouse, and actions automatically
- **Asset Discovery** - AI finds and uses all your project assets
- **Plugin Detection** - Automatically detect and use installed plugins
- **Runtime Debugging** - Inspect node properties during gameplay
- **Performance Monitoring** - Real-time FPS, memory, draw call stats
- **Automated Testing** - Run test scripts and verify results
- **Method Calling** - Call node methods for testing and debugging

### 🐛 Debugging & Analysis
- Capture script errors, runtime errors, and stack traces
- Monitor all Godot output in real-time
- Performance metrics (FPS, memory, draw calls)
- Scene analysis and validation
- AI-powered optimization suggestions

### � PFile & Project Management
- Recursive filesystem tree view
- Fuzzy file search
- UID management (Godot 4.4+)
- Dependency analysis
- Recent files tracking

### 🖼️ Screenshot System
- Capture editor window
- Capture running game viewport
- Auto-capture on scene changes and errors
- Base64 encoding for instant AI vision

### 🚀 Process Management
- Auto-detect Godot installation
- Launch Godot automatically when needed
- Direct file access (works without Godot running)
- Modify project settings programmatically

---

## 🛠️ Supported AI Tools

Godot MCP Enhanced works with any MCP-compatible AI tool:

- ✅ **Kiro IDE** 
- ✅ **Claude Desktop**
- ✅ **Claude Code CLI**
- ✅ **Cursor**
- ✅ **Windsurf**
- ✅ **Gemini CLI**
- ✅ **Aider**
- ✅ **Continue**
- ✅ Any MCP-compatible client

---

## 🚀 Quick Start

### Prerequisites

1. **Godot Engine 4.2+** - [Download](https://godotengine.org/download)
2. **Python 3.10+** - [Download](https://www.python.org/downloads/)
3. **uv** (Python package manager):
   ```bash
   # Windows
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

### Installation (5 minutes)

#### 1. Install Godot Plugin

1. Download or clone this repository
2. Copy `addons/godot_mcp_enhanced/` to your Godot project's `addons/` folder
3. Open your project in Godot
4. Go to **Project → Project Settings → Plugins**
5. Enable **Godot MCP Enhanced**
6. Check the bottom panel for "MCP Enhanced" tab - it should show "Server Running on port 3571"

#### 2. Install Python Server

```bash
cd godot-mcp-enhanced/python
uv venv
uv pip install -e .
```

#### 3. Configure Your AI Tool

**For Kiro IDE** - Create `.kiro/settings/mcp.json` in your project:

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

**For other tools**, see [CLI Setup Guide](docs/CLI_SETUP.md).

#### 4. Test It!

Restart your AI tool and try:

```
@godot get_project_info
@godot get_editor_screenshot
@godot create a simple player scene with a sprite and collision
```

---

## 📊 What Can You Build?

### Example 1: Complete Platformer
```
Create a 2D platformer with:
- Player character that can move and jump
- 3 enemy types with different behaviors
- Collectible coins
- Main menu and game over screen
- Background music and sound effects

Use any sprites you find in my project.
```

**AI will**:
- Discover your sprites automatically
- Create all scenes and scripts
- Implement physics and collision
- Add UI with proper anchoring
- Test gameplay with input simulation
- Provide screenshots at each step

### Example 2: 3D Adventure Game
```
I have a knight model and sword model in my project.
Create a 3D character controller with:
- WASD movement
- Mouse look camera
- Attack animation when clicking
- Health system
```

**AI will**:
- Find your 3D models
- Set up CharacterBody3D
- Create camera controller
- Implement combat system
- Test with simulated input

### Example 3: Dialogue System
```
I have the Dialogue Manager plugin installed.
Create a conversation system with:
- NPC that shows dialogue when approached
- Multiple dialogue branches
- Character portraits
```

**AI will**:
- Detect your plugin
- Use plugin nodes
- Create dialogue resources
- Implement interaction system
- Test the dialogue flow

---

## 📚 Documentation

### Getting Started
- **[Quick Start](#-quick-start)** - Get running in 5 minutes
- **[Installation Guide](INSTALLATION.md)** - Detailed setup instructions
- **[Quick Start Guide](QUICKSTART.md)** - Step-by-step first project

### Feature Guides
- **[Runtime Features](docs/RUNTIME_FEATURES.md)** - Input simulation, asset discovery, testing
- **[SVG Asset Guide](docs/SVG_GUIDE.md)** - Using SVG files for icons, logos, UI, and 2D games
- **[Examples](docs/EXAMPLES.md)** - Real-world usage examples
- **[AI Instructions](AI_INSTRUCTIONS.md)** - Comprehensive guide for AI assistants

### Setup Guides
- **[Kiro IDE Setup](docs/KIRO_SETUP.md)** - Kiro-specific configuration
- **[CLI Setup](docs/CLI_SETUP.md)** - Claude, Gemini, Aider, Continue
- **[Windsurf Setup](docs/WINDSURF_SETUP.md)** - Windsurf-specific setup

### Reference
- **[Enhancements](ENHANCEMENTS.md)** - Complete feature list
- **[Changelog](CHANGELOG.md)** - Version history
- **[Testing Guide](TESTING.md)** - Verification procedures

---

## 🎮 Key Capabilities

### 62+ Tools Available

| Category | Tools | Description |
|----------|-------|-------------|
| **Scene Operations** | 8 | Create, open, delete, play scenes |
| **Node Operations** | 8 | Add, delete, move, configure nodes |
| **Script Operations** | 6 | Create, edit, attach scripts |
| **Runtime Operations** | 11 | Input simulation, asset discovery, testing |
| **Debugging** | 5 | Error tracking, performance monitoring |
| **File Operations** | 10 | Read, write, search files |
| **Project Management** | 8 | Project info, filesystem, dependencies |
| **Editor Control** | 6 | Screenshots, execution, logs |

### Asset-Aware Development

AI can discover and use ALL your project assets:

```
@godot get_assets_by_type asset_type="texture"
# Returns: ["res://sprites/player.png", "res://sprites/enemy.png", ...]

@godot get_assets_by_type asset_type="audio"
# Returns: ["res://sounds/jump.wav", "res://music/theme.ogg", ...]
```

Then automatically use them in scenes!

### Plugin Integration

AI detects and uses installed plugins:

```
@godot get_installed_plugins
# Returns: [{"name": "dialogue_manager", "enabled": true}, ...]

@godot get_plugin_info plugin_name="dialogue_manager"
# Returns: {"nodes": ["DialogueLabel", "DialogueManager"], ...}
```

Then uses plugin nodes in your scenes!

### Automated Testing

AI can test your game automatically:

```
@godot play_scene path="res://scenes/game.tscn"
@godot simulate_action action_name="move_right" pressed=true
@godot get_node_properties node_path="Player"
@godot get_running_scene_screenshot
@godot stop_running_scene
```

---

## 🎯 Best Practices

### 1. Start with Context
```
@godot get_windsurf_context
```
Let AI understand your project before making changes.

### 2. Request Screenshots
```
@godot show me the current scene with a screenshot
```
Visual feedback helps AI understand what's happening.

### 3. Incremental Development
```
@godot create the player node, then show me a screenshot
```
Build step-by-step and verify each change.

### 4. Use Asset Discovery
```
@godot find all my sprites and create a game using them
```
Let AI discover and use your existing assets.

### 5. Test Automatically
```
@godot test the player movement with input simulation
```
Verify gameplay works without manual testing.

---

## 🐛 Troubleshooting

### Plugin Not Showing Up
- Ensure copied to `res://addons/godot_mcp_enhanced/`
- Enable in Project Settings → Plugins
- Restart Godot

### Connection Refused
- Check MCP Enhanced tab shows "Server Running"
- Verify port 3571 is not in use
- Check firewall settings

### Screenshots Not Working
- Godot editor must be open and visible
- Requires Godot 4.2+ for DisplayServer API
- Check AUTO_SCREENSHOT is enabled

### AI Tool Not Detecting Server
- Ensure Python server is running
- Check MCP config has correct paths
- Restart AI tool after config changes

For more help, see [Testing Guide](TESTING.md).

---

## 🤝 Contributing

Contributions are welcome!

### Development Setup

```bash
# Clone repository
git clone https://github.com/Rufaty/godot-mcp-enhanced.git
cd godot-mcp-enhanced

# Install Python dependencies
cd python
uv venv
uv pip install -e ".[dev]"

# Run tests
pytest
python test_connection.py
```

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Godot Engine** - Amazing open-source game engine
- **Anthropic** - Model Context Protocol specification
- **Community** - All contributors and users

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Rufaty/godot-mcp-enhanced/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)
- **Documentation**: [Full Docs](docs/)

---

<div align="center">

**Built with the help of Claude**

[⬆ Back to Top](#godot-mcp-enhanced)

</div>
