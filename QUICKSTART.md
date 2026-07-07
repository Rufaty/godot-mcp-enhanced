# Quickstart

Assumes Godot 4.4+ and Python 3.10+ are installed. Five steps.

1. Copy the plugin and enable it:

   Copy `addons/godot_mcp_enhanced/` into your project, then Project > Project Settings > Plugins > enable Godot MCP Enhanced. The Output tab reports the server on port 3571 and a generated token.

2. Install the Python side:

   ```bash
   cd python && uv sync
   ```

3. Copy the client config:

   Open the MCP panel at the bottom of the editor, hit the copy button for your client (Cursor, Windsurf, or Kiro; the same JSON works for Claude Desktop). Paste it into your client's MCP config and fix the `command` and `cwd` paths.

4. Restart your MCP client so it picks up the new server.

5. Try it. Ask the assistant:

   - "Take a screenshot of my editor"
   - "List every scene in the project"
   - "Create a scene called Level2 with a CharacterBody2D root"

If a request fails with 401, the token in your client config does not match `godot_mcp_config.json`. Recopy it. For anything else, [INSTALLATION.md](INSTALLATION.md) has a troubleshooting table.
