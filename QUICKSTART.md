# Quick Start - Godot MCP Enhanced

Get up and running in **5 minutes**! ⚡

---

## ✅ Prerequisites Check

Before starting, ensure you have:

```bash
# Check Python version (need 3.10+)
python --version

# Check if uv is installed
uv --version

# If not installed:
# Windows: powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
# macOS/Linux: curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## 🚀 Installation (3 Steps)

### Step 1: Install Godot Plugin (1 min)

1. Download from [Releases](https://github.com/your-repo/releases)
2. Extract and copy `addons/godot_mcp_enhanced/` to your project
3. In Godot: **Project → Settings → Plugins → Enable "Godot MCP Enhanced"**

### Step 2: Install Python Server (1 min)

```bash
cd godot-mcp-enhanced/python
uv venv
uv pip install -e .
```

### Step 3: Configure Windsurf (1 min)

Create `.windsurf/mcp.json` in your project:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "uv",
      "args": ["run", "python", "-m", "mcp_server"],
      "cwd": "FULL_PATH_TO/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    }
  }
}
```

**Replace `FULL_PATH_TO` with actual path!**

---

## ✨ Test It Works

### In Godot:
1. Open MCP Enhanced tab (bottom panel)
2. Click "Start Server"
3. Should show "Running on port 3571" ✅

### In Windsurf:
```
@godot get_project_info
```

You should see your project details! 🎉

---

## 🎯 First Commands to Try

### 1. See Your Project
```
@godot get windsurf context
```

### 2. Capture Editor
```
@godot get_editor_screenshot
```

### 3. View Scene
```
@godot get scene tree
```

### 4. Find Files
```
@godot search files for "player"
```

### 5. Check Errors
```
@godot get godot errors
```

---

## 🎮 Build Your First Scene

Try this complete workflow:

```
@godot Create a player scene for me:

1. New scene at "res://scenes/player.tscn" with CharacterBody2D root
2. Add Sprite2D child named "Sprite"
3. Add CollisionShape2D child named "Collision"
4. Give Collision a RectangleShape2D with size 32x32
5. Create script at "res://scripts/player.gd" with basic movement
6. Show me a screenshot of the result
```

---

## 🐛 Troubleshooting

### "Server not found"
- ✅ Check Godot's MCP Enhanced tab shows "Running"
- ✅ Verify `.windsurf/mcp.json` has correct paths
- ✅ Restart Windsurf

### "Connection refused"
- ✅ Start server in Godot (MCP Enhanced tab → Start Server)
- ✅ Check port 3571 not blocked by firewall
- ✅ Ensure Godot project is open

### Screenshots not working
- ✅ Godot window must be visible (not minimized)
- ✅ Need Godot 4.2+
- ✅ Try: `@godot get_editor_screenshot`

### Python/uv errors
```bash
# Reinstall dependencies
cd godot-mcp-enhanced/python
uv pip install -e . --force-reinstall
```

---

## 📚 Next Steps

Now that it works:

1. **Read Examples**: [docs/EXAMPLES.md](docs/EXAMPLES.md)
2. **Windsurf Guide**: [docs/WINDSURF_SETUP.md](docs/WINDSURF_SETUP.md)
3. **Full Docs**: [README.md](README.md)

---

## 💡 Pro Tips

### 1. Always Request Screenshots
```
@godot [your request] and show me a screenshot
```

### 2. Use Live Preview
```
@godot get live preview
```
Gets screenshot + scene tree + current script!

### 3. Build Incrementally
```
Step 1: @godot create the scene structure
Step 2: @godot add the nodes
Step 3: @godot create the script
Step 4: @godot show me the result
```

### 4. Debug Visually
```
@godot I have an error. Show me:
- Current errors
- Scene tree
- Screenshot
- Suggest fixes
```

---

## 🎉 You're Ready!

Start building games with AI assistance!

Common workflows:
- 🎨 **Scene Building**: Create complex hierarchies
- 💻 **Script Writing**: Generate and refactor code
- 🐛 **Debugging**: Visual error analysis
- ⚡ **Optimization**: Performance suggestions

---

## 🆘 Need Help?

- [Full Installation Guide](INSTALLATION.md)
- [GitHub Issues](https://github.com/your-repo/issues)
- [Community Discord](https://discord.gg/your-server)

---

<div align="center">

**Happy Game Development! 🚀**

[⬆ Back to Top](#quick-start---godot-mcp-enhanced)

</div>
