# Security

This plugin gives whatever talks to it control over your Godot editor, including a tool that executes arbitrary GDScript. Treat it accordingly.

## Threat model

The HTTP bridge runs on 127.0.0.1, which sounds private but is not. Any web page you have open can tell your browser to send requests to localhost. With DNS rebinding, that page can even make the request look like it comes from a real hostname. Version 1.0 was fully exposed to this: no authentication, a CORS wildcard, and `/api/editor/execute_script` sitting right there. A malicious page could have run code on your machine while you had the editor open.

## What 2.0 does about it

- **Token authentication.** The plugin generates a random 256-bit token on first load and stores it in `godot_mcp_config.json`. Every request must present it in the `X-MCP-Token` header (or a `token` query parameter). Comparison is constant-time.
- **Loopback only.** The server binds to 127.0.0.1 and refuses any Host header that is not `127.0.0.1`, `localhost`, or `::1`. This closes the DNS rebinding hole.
- **No cross-origin traffic.** Browsers attach an Origin header to cross-site requests; direct clients such as the Python bridge do not. Requests with an Origin header get a 403. There are no CORS headers to opt anyone in.
- **Path confinement.** File tools normalize paths and reject anything that escapes `res://` (GDScript side) or the project root (Python side). Before 2.0 the Python server would write to any path on disk.
- **Bounded requests.** Bodies are read against Content-Length with an 8 MiB cap and a 10 second timeout per client.

## What remains true anyway

- `execute_editor_script` is arbitrary code execution by design. The token is the only thing between a caller and your machine. Do not share it, do not commit `godot_mcp_config.json`, and disable the plugin when you are not using it.
- Anything running as your user on the same machine can read the config file and therefore the token. That is the same trust boundary as your project files themselves.
- The AI client on the other end can be prompted into destructive actions. The bridge does not try to judge intent.

## Reporting

Found something? Open an issue at https://github.com/Rufaty/godot-mcp-enhanced/issues. If it is sensitive, say so in the issue without details and we will take it from there.
