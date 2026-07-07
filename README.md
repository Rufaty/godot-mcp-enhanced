# Godot MCP Enhanced

An MCP bridge between AI coding assistants and a running Godot 4 editor. A GDScript plugin exposes editor operations over a token-protected HTTP API on 127.0.0.1, and a Python MCP server translates tool calls from clients like Claude Desktop, Cursor, Windsurf, or Kiro into those API calls.

Requires Godot 4.4 or newer. Tested on Godot 4.7.

## What it does

Around 60 tools, grouped like this:

- Project: filesystem tree, file search, UID/path conversion, dependency analysis
- Scenes: create, open, play, stop, read `.tscn` content, inspect the scene tree
- Nodes: add, delete, move, duplicate, set properties, anchors, attach resources
- Scripts: create, attach to nodes, view, edit with find and replace
- Assets: reimport through the editor pipeline, read `.import` sidecars, list assets by type
- Editor: screenshots of the editor and the running scene, error log, GDScript execution
- Runtime: simulate input, read node properties, call methods, run test scripts, engine stats

Screenshots come back as PNG images, so an assistant can look at the result of what it just changed instead of guessing.

## Version 2.0

Version 1.0 was written fast and it showed. 2.0 rewrites everything that mattered:

- The Python server built its base URL from a broken f-string, producing `{http://127.0.0.1}:3571`. Every single API call failed. Fixed.
- The HTTP server accepted requests from anyone, sent a CORS wildcard, and would execute arbitrary GDScript for any web page that asked. Now every request needs a generated token, the Host header must be loopback, and anything carrying an Origin header is refused. Details in [SECURITY.md](SECURITY.md).
- Requests used to be read in a single chunk, so bodies that arrived slowly were silently truncated. The server now buffers until Content-Length is satisfied.
- File operations reject paths that escape `res://`, on both the GDScript and the Python side.
- Deleting or renaming a file now takes its `.uid` and `.import` sidecars along. Godot 4.4+ uses `.uid` files to keep script and shader references stable; losing them breaks scenes.
- Windsurf-specific naming is gone. `get_windsurf_context` is now `get_editor_context`. The old `/api/windsurf/*` routes still answer, so nothing existing breaks.
- New asset tools: `reimport_assets` and `get_import_info`, built on the 4.x import pipeline.
- An unrelated Colab notebook that somehow lived in `studio/` is deleted.

## Install

The short version. Full steps with per-client configs are in [INSTALLATION.md](INSTALLATION.md).

1. Copy `addons/godot_mcp_enhanced/` into your Godot project and enable the plugin under Project > Project Settings > Plugins.
2. On first load the plugin writes `godot_mcp_config.json` at the project root, including a random auth token. Keep that file out of git. The shipped `.gitignore` already ignores it.
3. Install the Python server:

```bash
cd python
uv sync          # or: pip install -e .
```

4. Open the MCP panel at the bottom of the editor and click the copy button for your client. Paste into your client's MCP config and fill in the two paths:

```json
{
  "mcpServers": {
    "godot-mcp-enhanced": {
      "command": "/path/to/python/.venv/bin/python",
      "args": ["-m", "mcp_server"],
      "cwd": "/path/to/godot-mcp-enhanced/python",
      "env": {
        "GDAI_MCP_SERVER_PORT": "3571",
        "GODOT_MCP_TOKEN": "<from godot_mcp_config.json>",
        "GODOT_PROJECT_PATH": "/path/to/your/game"
      }
    }
  }
}
```

If `GODOT_MCP_TOKEN` is not set, the server reads the token from `godot_mcp_config.json` under `GODOT_PROJECT_PATH` on its own.

## Requirements

| Component | Version |
| --- | --- |
| Godot | 4.4+, tested on 4.7 |
| Python | 3.10+ |
| mcp (Python package) | 1.0+ |

## Documentation

- [INSTALLATION.md](INSTALLATION.md): full setup for each client
- [QUICKSTART.md](QUICKSTART.md): running in about five minutes
- [SECURITY.md](SECURITY.md): threat model and what the protections actually cover
- [AI_INSTRUCTIONS.md](AI_INSTRUCTIONS.md): a working guide for the assistant on the other end of the bridge
- [TESTING.md](TESTING.md): manual test checklist plus the connection test script

## License

MIT. See [LICENSE](LICENSE).
