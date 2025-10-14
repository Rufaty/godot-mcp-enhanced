# CLI Setup Guide - Godot MCP Enhanced

Complete guide for using Godot MCP Enhanced with various AI CLI tools.

---

## 🤖 Supported AI CLIs

- **Claude Code CLI** (Anthropic)
- **Gemini CLI** (Google)
- **OpenAI CLI**
- **Cline CLI**
- **Aider**
- **Continue**
- **Any MCP-compatible CLI**

---

## 📋 Prerequisites

1. **Godot MCP Enhanced** installed and working
2. **Python 3.10+** with virtual environment
3. **MCP server** installed (`cd python && uv pip install -e .`)
4. **Godot** running with plugin enabled

---

## 🔵 Claude Code CLI Setup

### Installation

```bash
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Or with pip
pip install claude-code
```

### Configuration

Create `~/.claude/mcp_config.json`:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "D:/CascadeProjects/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true",
        "GODOT_EXECUTABLE": "D:/Godot 4.5/Godot_v4.5-stable_win64.exe"
      }
    }
  }
}
```

### Usage

```bash
# Start Claude Code with Godot MCP
claude-code

# In Claude Code:
> Use godot-mcp-enhanced to create a player scene
> Get a screenshot of the current Godot editor
> List all assets in my project
```

---

## 🟢 Gemini CLI Setup

### Installation

```bash
# Install Gemini CLI
pip install google-generativeai-cli

# Or
npm install -g @google/generative-ai-cli
```

### Configuration

Create `~/.gemini/mcp_config.json`:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "AUTO_SCREENSHOT": "true",
        "GODOT_EXECUTABLE": "/path/to/godot"
      }
    }
  }
}
```

### Usage

```bash
# Start Gemini CLI
gemini-cli --mcp

# Use Godot MCP tools
> @godot get_project_info
> @godot create a platformer player
```

---

## 🟠 OpenAI CLI Setup

### Installation

```bash
# Install OpenAI CLI
pip install openai-cli
```

### Configuration

Create `~/.openai/mcp_config.json`:

```json
{
  "mcpServers": {
    "godot": {
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    }
  }
}
```

---

## 🟣 Aider Setup

### Installation

```bash
pip install aider-chat
```

### Configuration

Aider uses environment variables:

```bash
# Windows
set MCP_SERVER_GODOT=python -m mcp_server
set MCP_SERVER_GODOT_CWD=D:/CascadeProjects/godot-mcp-enhanced/python
set GDAI_MCP_SERVER_PORT=3571

# Linux/Mac
export MCP_SERVER_GODOT="python -m mcp_server"
export MCP_SERVER_GODOT_CWD="/path/to/godot-mcp-enhanced/python"
export GDAI_MCP_SERVER_PORT=3571
```

### Usage

```bash
# Start Aider with MCP
aider --mcp godot

# Use in Aider
/mcp godot get_project_info
/mcp godot create_scene path="res://scenes/player.tscn"
```

---

## 🔴 Continue Setup

### Installation

Continue is a VS Code extension, but also has CLI mode:

```bash
npm install -g continue-cli
```

### Configuration

Edit `~/.continue/config.json`:

```json
{
  "mcp": {
    "servers": {
      "godot-mcp-enhanced": {
        "command": "python",
        "args": ["-m", "mcp_server"],
        "cwd": "/path/to/godot-mcp-enhanced/python",
        "env": {
          "GDAI_MCP_SERVER_PORT": "3571"
        }
      }
    }
  }
}
```

---

## 🌐 Generic MCP CLI Setup

For any MCP-compatible CLI tool:

### Standard MCP Configuration Format

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "/absolute/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true",
        "GODOT_EXECUTABLE": "/path/to/godot.exe"
      }
    }
  }
}
```

### Environment Variables

All CLI tools should support these:

| Variable | Description | Default |
|----------|-------------|---------|
| `GDAI_MCP_SERVER_PORT` | HTTP server port | 3571 |
| `GDAI_RUNTIME_SERVER_PORT` | Runtime server port | 3572 |
| `AUTO_SCREENSHOT` | Enable auto screenshots | true |
| `GODOT_EXECUTABLE` | Path to Godot | (auto-detect) |
| `GODOT_CONSOLE_EXECUTABLE` | Path to Godot console | (auto-detect) |

---

## 🧪 Testing Your Setup

### Test 1: Check Connection

```bash
# In any CLI
> @godot check_godot_running
```

**Expected**: `{"success": true, "running": true, "responsive": true}`

### Test 2: Get Project Info

```bash
> @godot get_project_info
```

**Expected**: JSON with your project details

### Test 3: Get Screenshot

```bash
> @godot get_editor_screenshot
```

**Expected**: Screenshot image data

### Test 4: List Assets

```bash
> @godot get_filesystem_tree
```

**Expected**: Tree of all project files

---

## 💡 CLI Usage Examples

### Example 1: Create a Game Scene

```bash
# Claude Code
> Using godot-mcp-enhanced, create a 2D platformer player scene with:
  - CharacterBody2D root
  - Sprite2D using res://sprites/player.png
  - CollisionShape2D with RectangleShape2D
  - Movement script with WASD controls
  Show me a screenshot when done.
```

### Example 2: Debug Issues

```bash
# Gemini CLI
> @godot get_godot_errors
> Analyze these errors and fix them
> @godot get_editor_screenshot to verify the fix
```

### Example 3: Asset Management

```bash
# Aider
/mcp godot get_assets_by_type texture
/mcp godot get_asset_info res://sprites/player.png
> Add this sprite to a new player scene
```

### Example 4: Test Gameplay

```bash
# Any CLI
> @godot simulate_action jump pressed=true
> @godot get_runtime_stats
> @godot simulate_key_press keycode=32 pressed=true
```

---

## 🔧 Troubleshooting

### CLI Can't Find MCP Server

**Check**:
1. Python virtual environment is activated
2. `mcp_server` module is installed (`uv pip install -e .`)
3. Paths in config are absolute, not relative
4. Config file is in the correct location

**Test manually**:
```bash
cd godot-mcp-enhanced/python
python -m mcp_server
```

### Connection Refused

**Check**:
1. Godot is running
2. Plugin is enabled
3. HTTP server shows "listening: true"
4. Port 3571 is not blocked by firewall

**Test**:
```bash
curl http://127.0.0.1:3571/api/project/info
```

### Tools Not Available

**Check**:
1. MCP server started successfully
2. CLI loaded the MCP configuration
3. Restart CLI after config changes

---

## 📚 Advanced Configuration

### Multiple Godot Projects

```json
{
  "mcpServers": {
    "godot-project-a": {
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    },
    "godot-project-b": {
      "command": "python",
      "args": ["-m", "mcp_server"],
      "cwd": "/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3581"
      }
    }
  }
}
```

### Custom Tool Aliases

Some CLIs support aliases:

```json
{
  "aliases": {
    "godot": "godot-mcp-enhanced",
    "g": "godot-mcp-enhanced"
  }
}
```

Then use: `@g get_project_info`

---

## 🎯 Best Practices

### 1. Always Check Connection First

```bash
> @godot check_godot_running
```

### 2. Use Screenshots for Visual Feedback

```bash
> Create a player scene, then show me a screenshot
```

### 3. Batch Operations

```bash
> Create player, enemy, and coin scenes, then show me all three
```

### 4. Error Checking

```bash
> After each change, check for errors with get_godot_errors
```

### 5. Use Descriptive Requests

```bash
❌ "Make a player"
✅ "Create a 2D platformer player scene at res://scenes/player.tscn with CharacterBody2D, sprite, collision, and WASD movement script"
```

---

## 🔗 Related Documentation

- [AI Instructions](../AI_INSTRUCTIONS.md) - Comprehensive AI guidance
- [Kiro Setup](KIRO_SETUP.md) - Kiro IDE specific setup
- [Windsurf Setup](WINDSURF_SETUP.md) - Windsurf specific setup
- [Testing Guide](../TESTING.md) - Verification procedures

---

## 🆘 Getting Help

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Verify your setup with the [Testing](#testing-your-setup) section
3. Check [GitHub Issues](https://github.com/Rufaty/godot-mcp-enhanced/issues)
4. Join [Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)

---

**Last Updated**: October 14, 2025  
**Version**: 1.2.0  
**Compatibility**: All MCP-compatible CLI tools
