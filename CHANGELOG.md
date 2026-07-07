# Changelog

## 2.0.0 (2026-07-07)

Rewrite release after four months of abandonment. The headline: version 1.0's Python server could not talk to Godot at all because of a malformed URL template, and the HTTP server was open to any process or web page on the machine. Both are fixed, along with most of what surrounded them.

### Fixed

- Python server base URL was built as `{http://127.0.0.1}:3571`, so every API call failed with a connection error. This also affected `test_connection.py`.
- HTTP requests were read in one chunk without honoring Content-Length. Large or slow bodies were silently truncated. The server now buffers per client until the full body arrives.
- Deleting or renaming files left `.uid` and `.import` sidecars behind, which produces invalid-UID warnings and broken references in Godot 4.4+. Sidecars now move and delete together with their file.
- `EditorInterface` is used as the singleton it has been since Godot 4.2 instead of the deprecated `get_editor_interface()` call.

### Security

- All HTTP endpoints now require a generated auth token (`X-MCP-Token` header). The token lives in `godot_mcp_config.json`, which is gitignored.
- Host header must be loopback and requests carrying an Origin header are refused. Together this blocks DNS rebinding and drive-by requests from web pages.
- Removed the `Access-Control-Allow-Origin: *` header.
- GDScript file operations reject paths that escape `res://`. Python direct-file tools are confined to `GODOT_PROJECT_PATH`; they previously accepted any absolute path on disk.
- Request bodies capped at 8 MiB with a 10 second per-client timeout.

### Added

- `reimport_assets`: push changed source assets (textures, audio, models) through the editor import pipeline.
- `get_import_info`: read an asset's `.import` sidecar, including importer type, UID, and import parameters.
- `SECURITY.md` with the actual threat model.
- The bottom panel's copy-config button now emits a complete client config: port, token, and project path.

### Changed

- `get_windsurf_context` renamed to `get_editor_context`. New `/api/context/*` routes; the old `/api/windsurf/*` routes remain as aliases.
- Plugin and Python package versions bumped to 2.0.0; plugin metadata now names a real author and states the supported Godot range (4.4+, tested on 4.7).
- HTTP server logging cut down to what helps: start, stop, errors. The poll counters and debug timers are gone.
- `.gitignore` no longer contains a `user://` path (git cannot ignore what is not in the repo) and now documents why `.uid` files must be committed.

### Removed

- `studio/Unsloth_Studio_Colab.ipynb`, an unrelated LLM fine-tuning notebook.
- The unused `GDAI_RUNTIME_SERVER_PORT` config key.

## 1.0.0 (2026-03)

Initial release.
