# Testing Guide - Godot MCP Enhanced

This guide will help you test the installation and functionality of Godot MCP Enhanced.

---

## ✅ Prerequisites Test

Before testing, verify you have the required software:

```bash
# Check Python version (need 3.10+)
python --version

# Check if uv is installed
uv --version

# Check Godot version (need 4.2+)
# Open Godot and check Help → About
```

---

## 🧪 Test 1: Python Server Installation

### Step 1: Create Virtual Environment

```bash
cd godot-mcp-enhanced/python
uv venv
```

**Expected Output**: 
```
Using CPython 3.x.x interpreter at: ...
Creating virtual environment at: .venv
Activate with: source .venv/Scripts/activate
```

### Step 2: Install Dependencies

```bash
uv pip install -e .
```

**Expected Output**:
```
Resolved 29 packages in Xms
Built godot-mcp-enhanced @ file:///...
Installed 29 packages in Xs
```

**✅ Success Criteria**: No errors, all 29 packages installed

### Step 3: Verify Module Import

**Windows**:
```bash
.venv\Scripts\python.exe -c "import mcp_server; print('Success!')"
```

**macOS/Linux**:
```bash
.venv/bin/python -c "import mcp_server; print('Success!')"
```

**Expected Output**: `Success!`

---

## 🧪 Test 2: Godot Plugin Installation

### Step 1: Copy Plugin to Project

1. Create or open a Godot 4.2+ project
2. Copy `addons/godot_mcp_enhanced/` to your project's `res://addons/` directory
3. Your project structure should look like:
   ```
   YourProject/
   ├── addons/
   │   └── godot_mcp_enhanced/
   │       ├── plugin.gd
   │       ├── plugin.cfg
   │       ├── http_server.gd
   │       └── ... (other files)
   ```

### Step 2: Enable Plugin

1. Open Godot
2. Go to **Project → Project Settings → Plugins**
3. Find "Godot MCP Enhanced" in the list
4. Click the checkbox to enable it

**Expected Result**: 
- No errors in the Output tab
- "MCP Enhanced" tab appears in the bottom panel

### Step 3: Start HTTP Server

1. Click on the "MCP Enhanced" tab in the bottom panel
2. Click "Start Server" button

**Expected Output in Godot Console**:
```
[Godot MCP Enhanced] Initializing plugin...
[Godot MCP Enhanced] HTTP server started on port 3571
```

**✅ Success Criteria**: Server shows "Running" status

---

## 🧪 Test 3: Connection Test

### Using Test Script

```bash
cd godot-mcp-enhanced/python
python test_connection.py
```

**Expected Output**:
```
Testing Godot MCP Enhanced Connection
=====================================

✓ Server is reachable
✓ Project info retrieved
✓ Filesystem tree retrieved
✓ Scene tree retrieved
...

All tests passed!
```

### Manual Connection Test

**Windows**:
```bash
.venv\Scripts\python.exe -c "import httpx; import asyncio; print(asyncio.run(httpx.AsyncClient().get('http://127.0.0.1:3571/project_info')).json())"
```

**Expected Output**: JSON with project information

---

## 🧪 Test 4: MCP Client Configuration

### Test with Windsurf

1. Create `.windsurf/mcp.json` in your Godot project:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "D:/CascadeProjects/godot-mcp-enhanced/python/.venv/Scripts/python.exe",
      "args": ["-m", "mcp_server"],
      "cwd": "D:/CascadeProjects/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571"
      }
    }
  }
}
```

**Note**: Update paths to match your installation

2. Restart Windsurf
3. Try a test command:
   ```
   @godot get_project_info
   ```

**Expected Result**: JSON response with your Godot project information

---

## 🧪 Test 5: Basic Operations

### Test Scene Tree

In Windsurf/Cursor:
```
@godot get_scene_tree
```

**Expected**: Complete scene hierarchy of current scene

### Test Screenshot

```
@godot get_editor_screenshot
```

**Expected**: Base64-encoded PNG image of Godot editor

### Test File Search

```
@godot search_files for "player"
```

**Expected**: List of files matching "player"

---

## 🐛 Troubleshooting

### Issue: Python module not found

**Solution**: Make sure you're using the virtual environment Python:
```bash
# Windows
.venv\Scripts\python.exe -m mcp_server

# macOS/Linux
.venv/bin/python -m mcp_server
```

### Issue: Port 3571 already in use

**Solution**: Change the port in `godot_mcp_config.json`:
```json
{
  "GDAI_MCP_SERVER_PORT": "3581"
}
```

Then update your MCP client configuration to match.

### Issue: Plugin doesn't load

**Checklist**:
- [ ] Godot version is 4.2 or higher
- [ ] Plugin files are in `res://addons/godot_mcp_enhanced/`
- [ ] Plugin is enabled in Project Settings → Plugins
- [ ] Check Output tab for error messages

### Issue: Connection refused

**Checklist**:
- [ ] Godot is running with plugin enabled
- [ ] HTTP server is started (check MCP Enhanced tab)
- [ ] Port 3571 is not blocked by firewall
- [ ] Correct host/port in MCP client config

### Issue: Screenshots not working

**Requirements**:
- Godot 4.2+ (uses DisplayServer API)
- Godot editor must be visible (not minimized)
- AUTO_SCREENSHOT enabled in config

---

## ✅ Success Checklist

After completing all tests, you should have:

- [x] Python virtual environment created
- [x] All dependencies installed (29 packages)
- [x] MCP server module imports successfully
- [x] Godot plugin loads without errors
- [x] HTTP server starts on port 3571
- [x] MCP Enhanced tab visible in Godot
- [x] Connection test passes
- [x] MCP client configured and working
- [x] Basic operations (scene tree, screenshot) work

---

## 📊 Performance Benchmarks

Expected performance metrics:

| Operation | Expected Time |
|-----------|--------------|
| Get project info | < 100ms |
| Get scene tree | < 200ms |
| Get screenshot | < 500ms |
| Create scene | < 300ms |
| Add node | < 200ms |

If operations are significantly slower, check:
- Godot project size
- Number of open scenes
- System resources

---

## 🆘 Getting Help

If tests fail:

1. **Check logs**:
   - Godot: Output tab
   - Python: Terminal output
   - MCP Client: Client logs

2. **Common solutions**:
   - Restart Godot
   - Restart MCP client
   - Recreate virtual environment
   - Check firewall settings

3. **Report issues**:
   - [GitHub Issues](https://github.com/Rufaty/godot-mcp-enhanced/issues)
   - Include test results and error messages
   - Specify OS, Python version, Godot version

---

**Last Updated**: October 14, 2025  
**Version**: 1.0.0
