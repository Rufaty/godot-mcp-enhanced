# Changelog

All notable changes to Godot MCP Enhanced will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-10-01

### 🎉 Initial Release

#### Added

**Core Features**
- Complete Godot EditorPlugin implementation with @tool annotation
- HTTP REST API server for MCP communication
- Python MCP server with 40+ tools
- Real-time bidirectional communication between AI and Godot

**Screenshot System**
- Editor window screenshot capture using DisplayServer API
- Running scene screenshot capture
- Auto-screenshot on scene changes (optional)
- Auto-screenshot on errors (optional)
- Base64 encoding for immediate AI vision integration
- Configurable throttling to prevent spam

**Scene & Node Operations**
- Complete scene tree traversal with recursive node structure
- Create, open, delete, and manage scenes
- Add, delete, duplicate, and move nodes
- Update node properties with type safety
- Add resources (shapes, textures, materials)
- Control node anchors for UI elements
- Play and stop scenes programmatically

**Script Operations**
- View all open scripts with content
- Create new GDScript files
- Attach scripts to nodes
- Find and replace with regex support
- Execute arbitrary GDScript in editor context
- Syntax validation
- Script method and property inspection

**Debugger Integration**
- Capture script errors with line numbers
- Runtime error tracking with stack traces
- Output log monitoring
- Performance metrics (FPS, memory, draw calls)
- Scene analysis for common issues
- Performance hints for optimization

**File & Project Management**
- Recursive filesystem tree generation
- Fuzzy file search
- UID ↔ path conversion (Godot 4.4+)
- Recent files tracking
- Dependency analysis
- Project overview statistics

**Windsurf-Specific Features**
- Comprehensive context API for AI understanding
- Live preview with screenshot + scene tree + script
- Optimized for Windsurf's streaming capabilities
- Smart context awareness

**UI & UX**
- Bottom panel UI in Godot editor
- Server status monitoring
- One-click configuration copy
- Quick links to documentation
- Visual feedback for server state

**Documentation**
- Comprehensive README with examples
- Detailed Windsurf setup guide
- Complete installation instructions for all platforms
- Troubleshooting guide
- Tool reference documentation

**Development Tools**
- Connection test script
- Automated endpoint testing
- Rich terminal output for debugging

#### Technical Details

**Architecture**
- Godot 4.5 GDScript with idiomatic patterns
- Python 3.10+ with asyncio
- MCP 1.0+ protocol compliance
- HTTP/JSON communication layer
- Event-driven signal system

**Performance**
- Efficient screenshot throttling
- Async HTTP operations
- Minimal _process usage
- Lazy loading where possible

**Security**
- Localhost-only binding by default
- Configurable ports
- No external network access required

---

## [Unreleased]

### Planned Features

- [ ] WebSocket support for real-time streaming
- [ ] Custom resource type support
- [ ] Animation player integration
- [ ] Timeline and cutscene tools
- [ ] Multiplayer debugging support
- [ ] Plugin marketplace integration
- [ ] Git integration for version control
- [ ] Collaborative editing features

---

## Version History

- **1.0.0** (2025-10-01) - Initial release

---

[1.0.0]: https://github.com/your-repo/releases/tag/v1.0.0
