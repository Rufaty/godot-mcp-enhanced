# Installation

Two parts: a Godot editor plugin and a Python MCP server. The plugin runs inside the editor and answers on 127.0.0.1:3571. The Python server is what your MCP client actually launches; it forwards tool calls to the plugin.

## Requirements

- Godot 4.4 or newer (tested on 4.7)
- Python 3.10 or newer
- uv (recommended) or pip

## 1. Install the editor plugin

1. Copy `addons/godot_mcp_enhanced/` into your project's `addons/` folder.
2. Open the project and enable the plugin: Project > Project Settings > Plugins > Godot MCP Enhanced.
3. Check the Output tab. You should see the server start on port 3571 and, on first load, a note that an auth token was generated.

The token lands in `godot_mcp_config.json` at your project root. Never commit that file. If you use the shipped `.gitignore` it is already excluded.

## 2. Install the Python server

```bash
cd python
uv sync
```

Or with plain pip:

```bash
cd python
python -m venv .venv
source .venv/bin/activate    # Windows: .venv\Scripts\activate
pip install -e .
```

## 3. Configure your MCP client

The fastest path: open the MCP panel at the bottom of the Godot editor and press the copy button for your client. It fills in the port, token, and project path for you. You only adjust the `command` and `cwd` paths.

Manual config, same shape for every client:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "/path/to/godot-mcp-enhanced/python/.venv/bin/python",
      "args": ["-m", "mcp_server"],
      "cwd": "/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GODOT_MCP_TOKEN": "<token from godot_mcp_config.json>",
        "GODOT_PROJECT_PATH": "/path/to/your/game"
      }
    }
  }
}
```

On Windows the interpreter path is `.venv\Scripts\python.exe`.

Where it goes:

| Client | Location |
| --- | --- |
| Claude Desktop | `claude_desktop_config.json` (Settings > Developer > Edit Config) |
| Cursor | `.cursor/mcp.json` in your workspace, or global MCP settings |
| Windsurf | `~/.codeium/windsurf/mcp_config.json` |
| Kiro | `.kiro/settings/mcp.json` |

You can omit `GODOT_MCP_TOKEN` entirely: when `GODOT_PROJECT_PATH` is set, the server reads the token from `godot_mcp_config.json` on its own. That way the config survives token regeneration.

## 4. Verify

With the editor open and the plugin enabled:

```bash
cd python
GODOT_MCP_TOKEN=<token> python test_connection.py
```

Five endpoint checks should pass. Then ask your assistant something like "what scenes does my project have" and watch it answer from the live editor.

## Environment variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `GODOT_MCP_TOKEN` | read from config file | Auth token for the bridge |
| `GODOT_PROJECT_PATH` | cwd | Project root; also the jail for direct file tools |
| `GDAI_MCP_SERVER_PORT` | 3571 | Bridge port |
| `GODOT_HOST` | 127.0.0.1 | Bridge host |
| `GODOT_EXECUTABLE` | (none) | Godot binary path for `launch_godot` |

## Troubleshooting

- **401 Unauthorized**: token mismatch. Compare your client env against `godot_mcp_config.json`. The plugin regenerates a token only if the key is missing, so a stale copy in the client config is the usual cause.
- **Connection refused**: plugin not enabled, editor not running, or the port is taken. Use the Restart Server button in the MCP panel and read the Output tab.
- **403 Forbidden**: something other than the Python bridge is calling the API, or a proxy rewrote your Host header. Direct browser requests work only via the panel's Test button, which appends the token.
- **Tools time out on screenshots**: large editor windows produce large PNGs. Give it a few seconds; the client timeout is 30.
