# Python MCP server

This directory holds the MCP server that clients (Claude Desktop, Cursor, Windsurf, Kiro) launch over stdio. It proxies tool calls to the Godot editor plugin's HTTP API on 127.0.0.1.

## Setup

```bash
cd python
uv sync          # or: pip install -e .
```

Python 3.10 or newer.

## Environment variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `GODOT_MCP_TOKEN` | (none) | Auth token for the editor bridge. If unset, read from `godot_mcp_config.json` under `GODOT_PROJECT_PATH`. |
| `GODOT_PROJECT_PATH` | cwd | Godot project root. Also the jail for direct file tools. |
| `GDAI_MCP_SERVER_PORT` | 3571 | Port the editor plugin listens on. |
| `GODOT_HOST` | 127.0.0.1 | Host of the editor bridge. Leave it alone. |
| `GODOT_EXECUTABLE` | (none) | Path to the Godot binary, needed only by `launch_godot` and `get_godot_version`. |

## Run it manually

MCP clients start the server themselves, but for a smoke test:

```bash
GODOT_PROJECT_PATH=/path/to/your/game python -m mcp_server
```

Then check the bridge with:

```bash
GODOT_MCP_TOKEN=<token> python test_connection.py
```
