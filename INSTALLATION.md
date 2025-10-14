# Installation Guide - Godot MCP Enhanced

Complete step-by-step installation instructions for all platforms.

---

## 📋 System Requirements

- **Godot Engine**: 4.2 or higher
- **Python**: 3.10 or higher
- **Operating System**: Windows, macOS, or Linux
- **RAM**: 4GB minimum, 8GB recommended
- **AI Client**: Windsurf, Cursor, Claude Desktop, or any MCP-compatible client

---

## 🪟 Windows Installation

### 1. Install Prerequisites

#### Install Python 3.10+
```powershell
# Download from python.org or use winget
winget install Python.Python.3.11
```

#### Install uv (Package Manager)
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Verify installation:
```powershell
python --version
uv --version
```

### 2. Install Godot Plugin

1. **Download** the plugin:
   - Go to [Releases](https://github.com/Rufaty/godot-mcp-enhanced/releases)
   - Download `godot-mcp-enhanced-v1.0.0.zip`

2. **Extract** the archive

3. **Copy** to your project:
   ```
   YourGodotProject/
   └── addons/
       └── godot_mcp_enhanced/  ← Copy this folder here
   ```

4. **Enable** in Godot:
   - Open your project in Godot
   - `Project` → `Project Settings` → `Plugins`
   - Enable "Godot MCP Enhanced"
   - Check the bottom panel for "MCP Enhanced" tab

### 3. Setup Python Server

```powershell
# Navigate to the python directory
cd C:\path\to\godot-mcp-enhanced\python

# Create virtual environment and install
uv venv
uv pip install -e .

# Test the server
uv run python -m mcp_server --help
```

### 4. Configure Windsurf

Create `.windsurf\mcp.json` in your Godot project:

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
      "cwd": "C:\\path\\to\\godot-mcp-enhanced\\python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true"
      }
    }
  }
}
```

**Note**: Use double backslashes `\\` in Windows paths!

---

## 🍎 macOS Installation

### 1. Install Prerequisites

#### Install Python 3.10+
```bash
# Using Homebrew
brew install python@3.11
```

#### Install uv
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Add to your shell profile (~/.zshrc or ~/.bash_profile):
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

Reload shell and verify:
```bash
source ~/.zshrc  # or ~/.bash_profile
python3 --version
uv --version
```

### 2. Install Godot Plugin

1. **Download** the plugin from [Releases](https://github.com/Rufaty/godot-mcp-enhanced/releases)

2. **Extract** and copy to your project:
   ```bash
   cp -r addons/godot_mcp_enhanced /path/to/YourGodotProject/addons/
   ```

3. **Handle macOS Gatekeeper** (if you get verification errors):
   ```bash
   cd /path/to/YourGodotProject/addons/godot_mcp_enhanced
   xattr -cr .
   ```

4. **Enable** in Godot:
   - Open project in Godot
   - `Project` → `Project Settings` → `Plugins`
   - Enable "Godot MCP Enhanced"

### 3. Setup Python Server

```bash
cd /path/to/godot-mcp-enhanced/python

# Create virtual environment and install
uv venv
uv pip install -e .

# Test the server
uv run python -m mcp_server
```

### 4. Configure Windsurf

Create `.windsurf/mcp.json`:

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
      "cwd": "/Users/yourname/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true"
      }
    }
  }
}
```

---

## 🐧 Linux Installation

### 1. Install Prerequisites

#### Install Python 3.10+
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3.11 python3.11-venv

# Fedora
sudo dnf install python3.11

# Arch
sudo pacman -S python
```

#### Install uv
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Add to ~/.bashrc or ~/.zshrc:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

Verify:
```bash
source ~/.bashrc
python3 --version
uv --version
```

### 2. Install Godot Plugin

```bash
# Download and extract
wget https://github.com/Rufaty/godot-mcp-enhanced/releases/download/v1.0.0/godot-mcp-enhanced-v1.0.0.zip
unzip godot-mcp-enhanced-v1.0.0.zip

# Copy to your project
cp -r addons/godot_mcp_enhanced /path/to/YourGodotProject/addons/

# Enable in Godot
# Project → Project Settings → Plugins → Enable "Godot MCP Enhanced"
```

### 3. Setup Python Server

```bash
cd /path/to/godot-mcp-enhanced/python

# Create virtual environment and install
uv venv
uv pip install -e .

# Test
uv run python -m mcp_server
```

### 4. Configure Windsurf

Create `.windsurf/mcp.json`:

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
      "cwd": "/home/yourname/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GDAI_RUNTIME_SERVER_PORT": "3572",
        "AUTO_SCREENSHOT": "true"
      }
    }
  }
}
```

---

## 🔧 Post-Installation Setup

### 1. Verify Godot Plugin

1. Open your Godot project
2. Look for "MCP Enhanced" tab in bottom panel
3. Click "Start Server" button
4. Should show "Running on port 3571"

### 2. Test Python Server

```bash
cd godot-mcp-enhanced/python

# Run server manually
uv run python -m mcp_server

# Should start without errors
# Press Ctrl+C to stop
```

### 3. Test MCP Connection

In Windsurf:
```
@godot get_project_info
```

Should return your Godot project information!

---

## 🎯 Quick Start

Once installed, try these commands:

```
@godot get windsurf context
@godot get_editor_screenshot
@godot get scene tree
@godot search files for "player"
```

---

## 🔄 Updating

### Update Plugin

1. Download new version
2. Replace `addons/godot_mcp_enhanced/` folder
3. Restart Godot

### Update Python Server

```bash
cd godot-mcp-enhanced/python
git pull  # If using git
uv pip install -e . --force-reinstall
```

---

## 🗑️ Uninstallation

### Remove Plugin

1. In Godot: `Project` → `Project Settings` → `Plugins`
2. Disable "Godot MCP Enhanced"
3. Delete `addons/godot_mcp_enhanced/` folder

### Remove Python Server

```bash
# Remove virtual environment
cd godot-mcp-enhanced/python
rm -rf .venv

# Remove from AI client config
# Delete the "godot-mcp-enhanced" entry from .windsurf/mcp.json
```

---

## ❓ Troubleshooting Installation

### Python Not Found

**Windows**:
```powershell
# Add Python to PATH manually
$env:Path += ";C:\Users\YourName\AppData\Local\Programs\Python\Python311"
```

**macOS/Linux**:
```bash
# Use python3 explicitly
alias python=python3
```

### uv Command Not Found

**Windows**:
```powershell
# Add to PATH
$env:Path += ";$env:USERPROFILE\.cargo\bin"
```

**macOS/Linux**:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
source ~/.bashrc  # or ~/.zshrc
```

### Permission Denied (macOS/Linux)

```bash
# Fix permissions
chmod +x /path/to/godot-mcp-enhanced/python/mcp_server.py
```

### Port Already in Use

If port 3571 is in use:

1. Edit `godot_mcp_config.json`:
   ```json
   {
     "GDAI_MCP_SERVER_PORT": "3581"
   }
   ```

2. Update Windsurf config to match

3. Restart both Godot and Windsurf

### Plugin Doesn't Load

1. Check Godot version (must be 4.2+)
2. Look at Godot's Output tab for errors
3. Ensure `plugin.cfg` exists in the plugin folder
4. Try removing and re-adding the plugin folder

---

## 🆘 Getting Help

If you encounter issues:

1. **Check the logs**:
   - Godot: Output tab
   - Python: Terminal where server is running

2. **Common solutions**:
   - Restart Godot
   - Restart Windsurf
   - Check firewall settings
   - Verify all paths are correct

3. **Get support**:
   - [GitHub Issues](https://github.com/Rufaty/godot-mcp-enhanced/issues)
   - [Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)

---

## ✅ Installation Checklist

- [ ] Python 3.10+ installed and in PATH
- [ ] uv package manager installed
- [ ] Godot Engine 4.2+ installed
- [ ] Plugin copied to project's addons folder
- [ ] Plugin enabled in Godot Project Settings
- [ ] MCP Enhanced tab visible in Godot bottom panel
- [ ] Python server installed (`uv pip install -e .`)
- [ ] Windsurf configured with mcp.json
- [ ] Test connection works (`@godot get_project_info`)

---

## 🎉 Next Steps

Installation complete! Now check out:

- [Windsurf Setup Guide](docs/WINDSURF_SETUP.md) - Maximize your Windsurf workflow
- [README](README.md) - Full feature documentation
- [Examples](docs/EXAMPLES.md) - Real-world usage examples

---

<div align="center">

**Ready to build games with AI! 🚀**

[⬆ Back to Top](#installation-guide---godot-mcp-enhanced)

</div>
