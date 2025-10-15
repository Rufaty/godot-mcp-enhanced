# Contributing to Godot MCP Enhanced

Thank you for your interest in contributing to Godot MCP Enhanced! This document provides guidelines and instructions for contributing.

---

## 🎯 Ways to Contribute

### 1. Report Bugs
Found a bug? Please [open an issue](https://github.com/Rufaty/godot-mcp-enhanced/issues/new) with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Godot version, Python version, OS
- Screenshots if applicable

### 2. Suggest Features
Have an idea? [Open a feature request](https://github.com/Rufaty/godot-mcp-enhanced/issues/new) with:
- Clear description of the feature
- Use case and benefits
- Possible implementation approach
- Examples if applicable

### 3. Improve Documentation
Documentation improvements are always welcome:
- Fix typos or unclear explanations
- Add examples
- Improve guides
- Translate documentation

### 4. Submit Code
Code contributions should:
- Follow the coding standards below
- Include tests when applicable
- Update documentation
- Pass all existing tests

---

## 🚀 Getting Started

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/godot-mcp-enhanced.git
   cd godot-mcp-enhanced
   ```

2. **Install Python Dependencies**
   ```bash
   cd python
   uv venv
   uv pip install -e ".[dev]"
   ```

3. **Install Godot Plugin**
   - Copy `addons/godot_mcp_enhanced/` to a test Godot project
   - Enable the plugin in Project Settings

4. **Run Tests**
   ```bash
   cd python
   pytest
   python test_connection.py
   ```

---

## 📝 Coding Standards

### Python Code

**Style Guide**: Follow PEP 8

```python
# Good
async def get_scene_tree(node_path: str = "/root") -> dict:
    """Get the scene tree structure."""
    try:
        response = await client.get(f"{BASE_URL}/api/scene/tree")
        return response.json()
    except Exception as e:
        logger.error(f"Failed to get scene tree: {e}")
        raise

# Use type hints
# Use docstrings
# Handle errors gracefully
# Use async/await for HTTP requests
```

**Tools**:
```bash
# Format code
black .
ruff check .

# Type checking
mypy mcp_server.py
```

### GDScript Code

**Style Guide**: Follow [Godot GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)

```gdscript
# Good
@tool
extends Node

## Brief description of the class
##
## Detailed description if needed

var server: TCPServer
var port: int = 3571


func start_server() -> bool:
	"""Start the HTTP server on the configured port."""
	server = TCPServer.new()
	var err = server.listen(port)
	if err != OK:
		push_error("Failed to start server on port %d" % port)
		return false
	return true

# Use @tool for editor plugins
# Type hint all variables and parameters
# Use docstrings for functions
# Use proper error handling
```

### Documentation

**Markdown Style**:
- Use clear, concise language
- Include code examples
- Add screenshots for visual features
- Use proper heading hierarchy
- Link to related documentation

---

## 🔄 Pull Request Process

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 2. Make Changes

- Write clear, focused commits
- Follow coding standards
- Add tests for new features
- Update documentation

### 3. Test Your Changes

```bash
# Run Python tests
cd python
pytest
python test_connection.py

# Test in Godot
# - Open test project
# - Enable plugin
# - Test your changes manually
# - Verify no errors in console
```

### 4. Commit Changes

```bash
git add .
git commit -m "feat: add input simulation for testing"
# or
git commit -m "fix: resolve screenshot capture issue on Windows"
# or
git commit -m "docs: improve installation guide"
```

**Commit Message Format**:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:
- Clear title and description
- Reference related issues
- List changes made
- Include screenshots if applicable
- Mention breaking changes if any

### 6. Code Review

- Respond to feedback promptly
- Make requested changes
- Keep discussion focused and professional
- Be open to suggestions

---

## 🧪 Testing Guidelines

### Python Tests

```python
# tests/test_mcp_server.py
import pytest
from mcp_server import GodotMCPServer

@pytest.mark.asyncio
async def test_get_project_info():
    """Test getting project information."""
    server = GodotMCPServer()
    result = await server.get_project_info()
    assert "project_name" in result
    assert "godot_version" in result
```

### Manual Testing Checklist

- [ ] Plugin loads without errors
- [ ] HTTP server starts on port 3571
- [ ] All tools respond correctly
- [ ] Screenshots work
- [ ] Error tracking works
- [ ] No console errors
- [ ] Works on Windows/macOS/Linux
- [ ] Works with Godot 4.2, 4.3, 4.4

---

## 📚 Documentation Guidelines

### Adding New Features

When adding a new feature, update:

1. **README.md** - Add to features list
2. **CHANGELOG.md** - Add to [Unreleased] section
3. **AI_INSTRUCTIONS.md** - Add usage guidance for AI
4. **docs/EXAMPLES.md** - Add usage examples
5. **Relevant guides** - Update setup/feature guides

### Documentation Structure

```
godot-mcp-enhanced/
├── README.md              # Main overview
├── INSTALLATION.md        # Detailed setup
├── QUICKSTART.md         # Quick start guide
├── CHANGELOG.md          # Version history
├── CONTRIBUTING.md       # This file
├── AI_INSTRUCTIONS.md    # AI guidance
├── ENHANCEMENTS.md       # Feature details
├── TESTING.md           # Testing guide
└── docs/
    ├── RUNTIME_FEATURES.md  # Runtime operations
    ├── CLI_SETUP.md         # CLI tool setup
    ├── KIRO_SETUP.md        # Kiro IDE setup
    ├── WINDSURF_SETUP.md    # Windsurf setup
    └── EXAMPLES.md          # Usage examples
```

---

## 🐛 Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- OS: [e.g. Windows 11]
- Godot Version: [e.g. 4.3]
- Python Version: [e.g. 3.11]
- AI Tool: [e.g. Kiro IDE]

**Additional context**
Any other relevant information.
```

---

## ✨ Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
What you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Use case**
How would this feature be used?

**Additional context**
Any other relevant information.
```

---

## 🎯 Development Priorities

### High Priority
- Bug fixes
- Performance improvements
- Documentation improvements
- Test coverage

### Medium Priority
- New tools and features
- UI improvements
- Additional AI client support

### Low Priority
- Code refactoring
- Style improvements
- Nice-to-have features

---

## 📞 Getting Help

- **Questions**: [GitHub Discussions](https://github.com/Rufaty/godot-mcp-enhanced/discussions)
- **Bugs**: [GitHub Issues](https://github.com/Rufaty/godot-mcp-enhanced/issues)
- **Chat**: [Discord Server](#) (coming soon)

---

## 📜 Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold this code.

---

## 🙏 Recognition

Contributors will be:
- Listed in CHANGELOG.md
- Mentioned in release notes
- Added to contributors list
- Credited in documentation

---

## 📝 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

<div align="center">

**Thank you for contributing to Godot MCP Enhanced!** 🎮🤖

[⬆ Back to Top](#contributing-to-godot-mcp-enhanced)

</div>
