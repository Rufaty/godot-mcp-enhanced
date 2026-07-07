# Instructions for AI assistants

You are connected to a live Godot 4 editor (4.4+, assume 4.7 features are available) through this MCP server. These instructions tell you how to work in it without wrecking anything. They assume you already know GDScript; this is about workflow.

## Ground rules

1. Look before you touch. Start every session with `check_godot_running`, then `get_editor_context`. For any change to an existing project, read the relevant scene or script first. Never write into a file you have not read this session.
2. Small, reversible steps. One scene or one script per change, then verify. Do not batch ten mutations and hope.
3. Verify with your eyes. You have screenshots; use them. After a UI change, `get_editor_screenshot`. After a gameplay change, `play_scene`, `get_running_scene_screenshot`, `get_godot_errors`, `stop_running_scene`. A change is not done because the tool call returned success. It is done when you saw it work.
4. Root cause, not symptom. When fixing a bug, reproduce it first (play the scene, read the error), then fix the cause. Never silence an error to make the log clean.
5. Preserve what works. Before refactoring, note the behaviors that must not change: save formats, signal contracts, exported properties, input actions. Check them after.

## Choosing tools

- Prefer editor-mediated tools (`create_scene`, `add_node`, `edit_file`, `create_script`) over the direct file tools (`write_scene_file`, `write_script_file`). The editor tools keep the scene dock, UID cache, and undo history coherent. Direct file writes are for cases the editor tools cannot express, and Godot must rescan afterward.
- `edit_file` does find and replace. Use it for surgical script edits instead of rewriting whole files; it preserves everything you did not intend to change.
- `execute_editor_script` is the escape hatch for anything without a dedicated tool (batch renames, editor settings queries, one-off inspections). Keep such scripts short, print their results, and never leave persistent state behind.
- `run_test_script` runs a script and reports; use it for quick behavioral assertions.

## Godot 4.4+ asset and file rules

- Every script and shader has a `.uid` sidecar. Scene references point at that UID, not the path. Use `rename_file` and `delete_file` from this server, which move and remove sidecars correctly. If you must move files another way, move the `.uid` file too, and in git use one commit for both.
- Never edit `.uid` or `.import` files by hand.
- Imported assets (textures, audio, models) have a `.import` sidecar and a compiled copy in `.godot/imported/`. After changing a source asset outside the editor, call `reimport_assets` on it. Read settings with `get_import_info` when import behavior matters.
- `uid_to_project_path` and `project_path_to_uid` convert between `uid://` and `res://` forms when reading scene files.
- Everything you write stays under `res://`. The server enforces this; do not try to work around it.

## Godot 4.6/4.7 notes

- 3D physics defaults to Jolt since 4.6. Behavior differs slightly from the old GodotPhysics3D; do not port old workarounds blindly.
- 4.7 gives Control nodes offset transforms (translate, rotate, scale without breaking container layout). Prefer them over margin hacks for UI animation.
- Prefer typed GDScript (`var speed: float = 300.0`, typed arrays) and `@export` over magic literals. The debugger and the editor both get smarter with types.
- Scene organization convention: one scene per logical entity, composition over inheritance, signals up and calls down.

## Workflow per request type

- **Create**: plan node structure first, state it in one short block, build scene by scene, play and screenshot after each.
- **Fix**: reproduce, read the error with `get_godot_errors`, locate with `search_files`/`view_script`, minimal fix, replay, confirm the error is gone and nothing else appeared.
- **Extend**: read the scenes and scripts you touch, match their existing style and naming, wire new pieces through signals, regression-check the surrounding feature.
- **Refactor**: capture behavior first (play, screenshot, note stats via `get_runtime_stats`), change structure without changing values, then diff behavior against the capture.
- **Balance/tune**: change numbers, not structure. Play before and after.
- **Optimize**: measure with `get_runtime_stats` before touching anything. Fix the dominant cost. Measure again. Never optimize on suspicion.

## Things you do not do

- Do not delete or overwrite user work without being asked. When a request implies destruction, say what will be lost first.
- Do not `clear_output_logs` unless asked; the user may want that history.
- Do not leave a scene in a broken state between steps. If a step fails midway, repair or revert before moving on.
- Do not guess API signatures. If unsure whether a method exists in this Godot version, check with a tiny `execute_editor_script` probe.
