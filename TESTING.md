# Testing

## Automated connection test

With the editor open and the plugin enabled:

```bash
cd python
GODOT_MCP_TOKEN=<token from godot_mcp_config.json> python test_connection.py
```

It hits five endpoints (project info, filesystem tree, scene tree, open scripts, error log) and prints a pass/fail table. All five should pass against an open project. `get_scene_tree` fails legitimately when no scene is open; open any scene and rerun.

## Manual checklist

Run through this before tagging a release.

### Security behavior

- Request without a token returns 401.
- Request with a wrong token returns 401.
- Request with a bogus Host header (`curl -H "Host: evil.example" ...`) returns 403.
- Request with an Origin header returns 403.
- `write_script_file` with `../../outside.gd` is rejected on both the Python side and the GDScript side.

### Editor operations

- `create_scene`, then `add_node`, then `attach_script`: the scene opens in the editor and saves cleanly.
- `play_scene` and `stop_running_scene` behave, and `get_running_scene_screenshot` returns an image while playing.
- `edit_file` performs a find and replace and the script editor shows the change after reload.
- `delete_scene` removes the `.tscn` and reports removed sidecars.
- `rename_file` on a script moves its `.uid` file too. Check the filesystem dock afterward: no yellow UID warnings.

### Asset pipeline

- Overwrite a PNG used in a scene from outside the editor, call `reimport_assets` on it, and confirm the texture updates without an editor restart.
- `get_import_info` on that PNG reports the importer (`texture`) and a `uid://` value.

### Python package

```bash
cd python
uv run pytest        # when tests exist for your changes
uv run ruff check .
```

Keep `ruff` clean. `black` formatting is configured in the dev dependency group.
