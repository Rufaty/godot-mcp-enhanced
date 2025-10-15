# Changelog

All notable changes to Godot MCP Enhanced will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-01-15

### 🎉 Major Release - Runtime Operations & Multi-CLI Support

This release transforms Godot MCP Enhanced into a comprehensive AI-assisted game development platform with 62+ tools and support for 8+ AI clients.

### Added

#### Runtime Operations (11 New Tools)
- **`simulate_key_press`** - Simulate keyboard input for testing
- **`simulate_action`** - Simulate input actions (jump, move, etc.)
- **`get_runtime_stats`** - Real-time performance monitoring (FPS, memory, draw calls)
- **`get_node_properties`** - Inspect node properties during gameplay
- **`call_node_method`** - Call methods on nodes for testing
- **`get_installed_plugins`** - Detect all installed Godot plugins
- **`get_plugin_info`** - Get detailed plugin information
- **`get_assets_by_type`** - Discover project assets (textures, models, audio, etc.)
- **`get_asset_info`** - Get detailed asset information
- **`run_test_script`** - Execute automated test scripts
- **`get_input_actions`** - List all registered input actions

#### Asset Discovery System
- Automatic detection of textures, 3D models, audio files, scripts, scenes
- Support for PNG, JPG, SVG, GLB, GLTF, OBJ, FBX, WAV, OGG, MP3
- Detailed asset metadata (size, format, type)
- AI can now use project assets automatically

#### Plugin Integration System
- Automatic plugin detection in `addons/` directory
- Plugin metadata parsing from `plugin.cfg`
- Plugin node discovery
- AI can use plugin features automatically

#### Input Simulation System
- Keyboard key press/release simulation
- Input action simulation with strength control
- Mouse button and motion simulation
- Support for all Godot keycodes and actions

#### Performance Monitoring
- Real-time FPS tracking
- Memory usage (static and dynamic)
- Draw call counting
- Vertex and surface change tracking
- Material and shader change monitoring

#### Multi-CLI Support
- **Kiro IDE** - Full support with optimized configuration
- **Claude Code CLI** - Complete setup guide
- **Gemini CLI** - Full integration
- **Cursor** - MCP configuration
- **Windsurf** - Enhanced support
- **Aider** - CLI integration
- **Continue** - Full compatibility
- **Generic MCP CLIs** - Universal support

#### Documentation
- **`docs/RUNTIME_FEATURES.md`** - Comprehensive runtime operations guide
- **`docs/CLI_SETUP.md`** - Setup guides for all supported CLIs
- **`docs/KIRO_SETUP.md`** - Kiro IDE specific guide
- **`AI_INSTRUCTIONS.md`** - 900+ lines of AI guidance with runtime operations
- **`docs/EXAMPLES.md`** - Real-world usage examples
- **`CONTRIBUTING.md`** - Contribution guidelines
- **`CODE_OF_CONDUCT.md`** - Community guidelines

### Changed

- **Tool Count**: Increased from 51 to 62+ tools
- **AI Instructions**: Expanded from 450 to 900+ lines
- **Documentation**: Reorganized and consolidated for clarity
- **README**: Complete rewrite with modern structure
- **Performance**: Optimized HTTP request handling

### Improved

- **Asset-Aware Development**: AI can now discover and use all project assets
- **Plugin Compatibility**: Works with any installed Godot plugin
- **Testing Capabilities**: Automated gameplay testing with input simulation
- **Debugging**: Runtime inspection and method calling
- **Performance**: Real-time monitoring and optimization
- **Documentation**: Comprehensive guides for all features

### Fixed

- HTTP route registration for runtime operations
- Endpoint mapping in Python MCP server
- Tool definitions for new runtime features
- Documentation cross-references

### Removed

- Duplicate files (`AI_INSTRUCTIONS_OPTIMIZED.md`, `mcp_server_optimized.py`)
- Redundant documentation (`docs/OPTIMIZATION.md`, `docs/AI_INSTRUCTIONS_GUIDE.md`)
- Obsolete test files (`test_godot_connection.py`)

---

## [0.9.0] - 2024-12-20

### Added

- Initial public release
- 51 core tools for Godot integration
- Scene and node operations
- Script management
- Debugging and error tracking
- Screenshot system
- File operations
- Project management
- Windsurf AI optimization
- Cursor support
- Claude Desktop support

### Features

- Real-time editor integration
- HTTP REST API (port 3571)
- Python MCP server
- Godot EditorPlugin
- Auto-screenshot on changes
- Error tracking system
- Performance monitoring basics
- Live scene tree inspection

---

## [0.8.0] - 2024-12-10

### Added

- Beta release for testing
- Core MCP protocol implementation
- Basic Godot integration
- Scene operations
- Node manipulation
- Script editing

---

## [0.5.0] - 2024-11-25

### Added

- Alpha release
- Proof of concept
- Basic HTTP server
- Simple tool set
- Initial documentation

---

## Upgrade Guide

### From 0.9.0 to 1.0.0

1. **Update Plugin**:
   - Replace `addons/godot_mcp_enhanced/` with new version
   - Restart Godot
   - Verify "Server Running" in MCP Enhanced tab

2. **Update Python Server**:
   ```bash
   cd python
   git pull
   uv pip install -e .
   ```

3. **Update MCP Configuration**:
   - No changes needed for existing configs
   - New tools are automatically available

4. **New Features Available**:
   - Try `@godot get_assets_by_type asset_type="texture"`
   - Try `@godot get_installed_plugins`
   - Try `@godot simulate_action action_name="jump"`
   - Try `@godot get_runtime_stats`

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute to this project.

---

## Links

- **Repository**: https://github.com/Rufaty/godot-mcp-enhanced
- **Issues**: https://github.com/Rufaty/godot-mcp-enhanced/issues
- **Discussions**: https://github.com/Rufaty/godot-mcp-enhanced/discussions
- **Documentation**: [docs/](docs/)

---

[1.0.0]: https://github.com/Rufaty/godot-mcp-enhanced/releases/tag/v1.0.0
[0.9.0]: https://github.com/Rufaty/godot-mcp-enhanced/releases/tag/v0.9.0
[0.8.0]: https://github.com/Rufaty/godot-mcp-enhanced/releases/tag/v0.8.0
[0.5.0]: https://github.com/Rufaty/godot-mcp-enhanced/releases/tag/v0.5.0
