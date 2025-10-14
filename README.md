# Godot MCP Enhanced

<div align="center">

[![Made with Godot](https://img.shields.io/badge/Made%20with-Godot%204.x-478CBF?style=flat&logo=godot%20engine&logoColor=white)](https://godotengine.org)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![MCP](https://badge.mcpx.dev?type=server)](https://modelcontextprotocol.io/introduction)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**A comprehensive Model Context Protocol server for Godot Engine with advanced features for Windsurf AI, Cursor, and Claude**

[Features](#features) • [Installation](#installation) • [Windsurf Setup](#windsurf-setup) • [Documentation](#documentation) • [Examples](#examples)

</div>

---

## 🎯 Why Godot MCP Enhanced?

Transform your Godot development workflow with AI assistance that actually understands your game:

- **🖼️ Real-time Screenshots** - AI sees what you see in the editor and running game
- **🔍 Deep Context** - Full scene tree, scripts, errors, and project structure
- **⚡ Live Updates** - Changes reflect instantly in your editor
- **🎨 Multi-IDE Support** - Optimized for Windsurf AI, Kiro IDE, Cursor, and Claude
- **🛠️ 62+ Tools** - Complete control over scenes, nodes, scripts, debugging, runtime operations, and file system
- **🚀 Godot Process Management** - Auto-detect and launch Godot when needed
- **📁 Direct File Access** - Work with project files even when Godot isn't running

---

## ✨ Features

### 🎬 Scene & Node Operations
- **Complete Scene Control** - Create, open, delete, and manage scenes
- **Node Manipulation** - Add, delete, duplicate, move, and configure nodes
- **Property Updates** - Modify any node property with type safety
- **Resource Management** - Add and configure resources (textures, shapes, materials)
- **Live Preview** - See changes instantly in the editor

### 💻 Script Operations
- **Script Management** - Create, view, edit, and attach GDScript files
- **Find & Replace** - Regex-powered search and replace across files
- **Syntax Validation** - Check GDScript syntax before execution
- **Code Execution** - Run arbitrary GDScript in the editor context
- **Open Scripts** - View all currently open scripts with content

### 🐛 Debugging & Analysis
- **Error Tracking** - Capture script errors, runtime errors, and stack traces
- **Output Logs** - Monitor all Godot output in real-time
- **Performance Metrics** - FPS, memory usage, draw calls, and more
- **Scene Analysis** - Detect missing resources, invalid configurations
- **Performance Hints** - AI-powered suggestions for optimization

### 📁 File & Project Management
- **Filesystem Tree** - Recursive view of entire project structure
- **Fuzzy Search** - Find files quickly with smart matching
- **UID Management** - Convert between UIDs and paths (Godot 4.4+)
- **Dependency Analysis** - Understand project relationships
- **Recent Files** - Quick access to recently modified files

### 🖼️ Screenshot System
- **Editor Screenshots** - Capture the entire Godot editor window
- **Game Screenshots** - Capture running game viewport
- **Auto-Capture** - Automatic screenshots on scene changes and errors
- **Base64 Encoding** - Instant AI vision integration

### 🌊 Advanced AI Features
- **Live Context** - Comprehensive project state for AI understanding
- **Smart Suggestions** - Context-aware code and scene recommendations
- **Streaming Updates** - Real-time feedback on changes
- **Visual Feedback** - Screenshots automatically included in responses
- **AI Instructions** - Comprehensive guidance for AI assistants (see AI_INSTRUCTIONS.md)
- **Autonomous Development** - AI can build complete games with minimal intervention

### 🚀 Process & File Management
- **Godot Detection** - Check if Godot is running and responsive
- **Auto-Launch** - Launch Godot automatically when needed
- **Direct File Access** - Read/write scenes and scripts without Godot running
- **Project Settings** - Modify project.godot programmatically
- **Directory Operations** - Create folders and manage project structure

### 🎮 Runtime Operations (NEW!)
- **Input Simulation** - Test keyboard, mouse, and actions automatically
- **Asset Discovery** - AI can find and use all your project assets
- **Plugin Detection** - Automatically detect and use installed plugins
- **Runtime Debugging** - Inspect node properties during gameplay
- **Performance Monitoring** - Real-time FPS, memory, and draw call stats
- **Automated Testing** - Run test scripts and verify results
- **Method Calling** - Call node methods for testing and debugging

---

## 📦 Installation

### Prerequisites

1. **Godot Engine 4.2+** - [Download here](https://godotengine.org/download)
2. **Python 3.10+** - [Download here](https://www.python.org/downloads/)
3. **uv** (Python package manager) - Install with:
   ```bash
   # Windows
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

### Step 1: Install Godot Plugin

1. **Download** the latest release from [Releases](https://github.com/Rufaty/godot-mcp-enhanced/releases)
2. **Extract** and copy `addons/godot_mcp_enhanced/` to your project's `res://addons/` directory
3. **Open** your project in Godot
4. Go to **Project → Project Settings → Plugins**
5. **Enable** "Godot MCP Enhanced"
6. You should see the "MCP Enhanced" tab in the bottom panel

### Step 2: Install Python MCP Server

```bash
cd godot-mcp-enhanced/python
uv venv
uv pip install -e .
```

### Step 3: Configure Your AI Client

The plugin automatically generates the configuration you need. 

1. Open the **MCP Enhanced** tab in Godot's bottom panel
2. Click **Copy Config** button
3. Follow the setup instructions for your AI client below

---

## 🎨 IDE Setup

### Kiro IDE

Kiro IDE has excellent AI capabilities and works great with Godot MCP Enhanced. See [Kiro Setup Guide](docs/KIRO_SETUP.md) for detailed instructions.

**Quick Setup**:
1. Create `.kiro/settings/mcp.json` in your project
2. Add Godot MCP Enhanced configuration
3. Set `GODOT_EXECUTABLE` environment variable
4. Restart Kiro and start building!

### Windsurf AI

Windsurf AI is optimized for this plugin with special features like live preview and context-aware suggestions. See [Windsurf Setup Guide](docs/WINDSURF_SETUP.md).

### Configuration

1. Open Windsurf Settings
2. Navigate to **MCP Servers**
3. Click **Add New Server**
4. Paste the configuration from Godot's MCP Enhanced panel
5. Restart Windsurf

### Example `.windsurf/mcp.json`:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "python",
      "args": [
        "-m",
        "mcp_server"
      ],
      "cwd": "path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true"
      }
    }
  }
}
```

### Windsurf Pro Tips

**🎯 Use Context Commands:**
```
@godot show me the current scene structure with a screenshot
```

**🔍 Live Preview:**
```
@godot get live preview of what I'm working on
```

**🐛 Debug Assistance:**
```
@godot what errors are in my project? show me with context
```

**🎨 Scene Building:**
```
@godot create a platformer player scene with CharacterBody2D, sprite, and collision
```

---

## 🚀 Quick Start Examples

### Example 1: Create a Complete Player Scene

```
@godot create a new scene at "res://scenes/player.tscn" with CharacterBody2D as root.
Then add these nodes:
- Sprite2D named "Sprite"
- CollisionShape2D named "Collision"
- Camera2D named "Camera"

For the Collision node, add a RectangleShape2D resource to the shape property.
Finally, create and attach a script at "res://scripts/player.gd"
```

### Example 2: Debug Current Scene

```
@godot analyze my current scene for issues and show me:
1. A screenshot of the editor
2. The scene tree structure
3. Any errors or warnings
4. Performance suggestions
```

### Example 3: Refactor Scripts

```
@godot find all scripts that use get_node and refactor them to cache node references in _ready()
```

### Example 4: Build UI Layout

```
@godot create a main menu UI scene with:
- A background Panel
- VBoxContainer centered with these buttons:
  - "Start Game"
  - "Options"
  - "Quit"
Set up proper anchors for responsive design
```

---

## 📚 Available Tools

<details>
<summary><b>Project Tools (5)</b></summary>

- `get_project_info` - Project metadata and settings
- `get_filesystem_tree` - Recursive file structure
- `search_files` - Fuzzy file search
- `uid_to_project_path` - UID → path conversion
- `project_path_to_uid` - Path → UID conversion

</details>

<details>
<summary><b>Scene Tools (8)</b></summary>

- `get_scene_tree` - Complete scene hierarchy
- `get_scene_file_content` - Raw scene file
- `create_scene` - New scene creation
- `open_scene` - Open scene in editor
- `delete_scene` - Remove scene file
- `add_scene` - Instance scene as node
- `play_scene` - Run scene
- `stop_running_scene` - Stop playback

</details>

<details>
<summary><b>Node Tools (8)</b></summary>

- `add_node` - Create new node
- `delete_node` - Remove node
- `duplicate_node` - Clone node
- `move_node` - Reparent node
- `update_property` - Modify properties
- `add_resource` - Add resources
- `set_anchor_preset` - Control anchors
- `set_anchor_values` - Precise anchor control

</details>

<details>
<summary><b>Script Tools (5)</b></summary>

- `get_open_scripts` - List open scripts
- `view_script` - Open & activate script
- `create_script` - New GDScript file
- `attach_script` - Attach to node
- `edit_file` - Find & replace

</details>

<details>
<summary><b>Editor Tools (5)</b></summary>

- `get_godot_errors` - All errors & logs
- `get_editor_screenshot` - Editor capture
- `get_running_scene_screenshot` - Game capture
- `execute_editor_script` - Run GDScript
- `clear_output_logs` - Clear logs

</details>

<details>
<summary><b>Windsurf Tools (2)</b></summary>

- `get_windsurf_context` - Comprehensive project state
- `get_live_preview` - Screenshot + scene + script

</details>

---

## 🔧 Configuration

### Config File: `godot_mcp_config.json`

```json
{
  "GDAI_MCP_SERVER_PORT": "3571",
  "GDAI_RUNTIME_SERVER_PORT": "3572",
  "AUTO_SCREENSHOT": true,
  "SCREENSHOT_ON_SCENE_CHANGE": true,
  "SCREENSHOT_ON_ERROR": true
}
```

### Environment Variables

- `GODOT_HOST` - Godot server host (default: `127.0.0.1`)
- `GDAI_MCP_SERVER_PORT` - MCP server port (default: `3571`)
- `GDAI_RUNTIME_SERVER_PORT` - Runtime server port (default: `3572`)
- `AUTO_SCREENSHOT` - Enable auto-screenshots (default: `true`)

---

## 🤝 Cursor & Claude Desktop Setup

<details>
<summary><b>Cursor Configuration</b></summary>

Create `.cursor/mcp.json` in your project:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    }
  }
}
```

</details>

<details>
<summary><b>Claude Desktop Configuration</b></summary>

Edit `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "type": "stdio",
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    }
  }
}
```

</details>

---

## 🎓 Best Practices

### 1. **Use Descriptive Names**
AI works better when nodes and scripts have clear, descriptive names.

### 2. **Request Screenshots**
Always ask for screenshots when debugging visual issues:
```
@godot show me the current scene with a screenshot
```

### 3. **Check Context First**
Before making changes, get the current state:
```
@godot get windsurf context to understand my project
```

### 4. **Incremental Changes**
Make changes step-by-step and verify each one:
```
@godot create the player node, then show me a screenshot
```

### 5. **Use Error Monitoring**
Regularly check for issues:
```
@godot check for errors and analyze performance
```

---

## 📚 Documentation

- **[Runtime Features Guide](docs/RUNTIME_FEATURES.md)** - Complete guide to input simulation, asset management, and testing
- **[CLI Setup Guide](docs/CLI_SETUP.md)** - Setup for Claude Code CLI, Gemini CLI, Aider, and more
- **[Kiro IDE Setup](docs/Kiro_SETUP.md)** - Setup guide for Kiro IDE
- **[Examples](docs/EXAMPLES.md)** - Real-world usage examples
- **[AI Instructions](AI_INSTRUCTIONS.md)** - Comprehensive guide for AI assistants
- **[Enhancements](ENHANCEMENTS.md)** - Detailed feature list and capabilities

---

## 🐛 Troubleshooting

### Plugin Not Showing Up
- Ensure you copied to `res://addons/godot_mcp_enhanced/`
- Enable plugin in Project Settings → Plugins
- Restart Godot

### Connection Refused Errors
- Check Godot's MCP Enhanced tab shows "Server Running"
- Verify port `3571` is not in use
- Check firewall settings

### Screenshots Not Working
- Only works when Godot editor is open and visible
- Requires Godot 4.2+ for DisplayServer API
- Check AUTO_SCREENSHOT is enabled in config

### Windsurf Not Detecting Server
- Ensure Python server is running (`uv run mcp-server`)
- Check .windsurf/mcp.json has correct paths
- Restart Windsurf after config changes

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

---

## 🙏 Acknowledgments

- Built with [Godot Engine](https://godotengine.org)
- Uses [Model Context Protocol](https://modelcontextprotocol.io)
- Inspired by [GDAI MCP](https://gdaimcp.com)
- Optimized for [Windsurf AI](https://codeium.com/windsurf)

---

## 🔗 Links

- [GitHub Repository](https://github.com/Rufaty/godot-mcp-enhanced)
- [Issue Tracker](https://github.com/Rufaty/godot-mcp-enhanced/issues)
- [Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)

---

<div align="center">

**Made with ❤️ for the Godot and AI community**

[⬆ Back to Top](#godot-mcp-enhanced)

</div>
