# SVG Asset Usage Guide for Godot MCP Enhanced

Complete guide for using SVG (Scalable Vector Graphics) files in your Godot projects with AI assistance.

---

## 🎨 Why Use SVG Files?

### Advantages

✅ **Resolution Independent** - Scale to any size without quality loss  
✅ **Small File Size** - Vector data is compact  
✅ **Perfect for UI** - Icons, buttons, logos stay crisp  
✅ **Easy to Edit** - Modify colors and styles programmatically  
✅ **Ideal for 2D Games** - Clean, scalable game elements  
✅ **Multi-Resolution Support** - One file works for all screen sizes

### Best Use Cases

- 🎯 UI icons and buttons
- 🏷️ Logos and branding
- 📊 HUD elements
- 🎮 Menu graphics
- 🎲 Simple 2D game sprites
- 📐 Geometric shapes
- 🔔 Symbols and indicators
- 🖼️ Resolution-independent backgrounds

---

## 🔍 Discovering SVG Assets

SVG files are discovered as textures:

```
@godot get_assets_by_type asset_type="texture"
# Returns: ["res://icons/menu.svg", "res://ui/button.svg", "res://sprites/player.svg"]
```

---

## 📋 Quick Examples

### 1. Menu Icons

```
@godot add_node node_type="TextureRect" node_name="PlayIcon"
@godot update_property node_path="PlayIcon" property="texture" value="res://icons/play.svg"
@godot update_property node_path="PlayIcon" property="custom_minimum_size" value="[32, 32]"
@godot update_property node_path="PlayIcon" property="expand_mode" value="1"
```

### 2. Game Logo

```
@godot add_node node_type="TextureRect" node_name="Logo"
@godot update_property node_path="Logo" property="texture" value="res://branding/logo.svg"
@godot update_property node_path="Logo" property="custom_minimum_size" value="[400, 200]"
@godot update_property node_path="Logo" property="expand_mode" value="1"
@godot set_anchor_preset node_path="Logo" preset="center_top"
```

### 3. HUD Icons

```
@godot add_node node_type="TextureRect" node_name="HealthIcon"
@godot update_property node_path="HealthIcon" property="texture" value="res://icons/heart.svg"
@godot update_property node_path="HealthIcon" property="custom_minimum_size" value="[24, 24]"
@godot update_property node_path="HealthIcon" property="position" value="[10, 10]"
```

### 4. 2D Game Sprite

```
@godot add_node node_type="Sprite2D" node_name="PlayerSprite"
@godot update_property node_path="PlayerSprite" property="texture" value="res://sprites/player.svg"
@godot update_property node_path="PlayerSprite" property="scale" value="[2.0, 2.0]"
```

---

## 🎯 Best Practices

### 1. Always Set Size

```
# SVG needs explicit size
@godot update_property node_path="Icon" property="custom_minimum_size" value="[32, 32]"
```

### 2. Keep Aspect Ratio

```
# Prevent distortion
@godot update_property node_path="Icon" property="expand_mode" value="1"
```

### 3. Scale Without Quality Loss

```
# Scale up as much as you want!
@godot update_property node_path="Sprite" property="scale" value="[5.0, 5.0]"
```

### 4. Modify Colors

```
# Tint SVG with modulate
@godot update_property node_path="Icon" property="modulate" value="[1.0, 0.0, 0.0, 1.0]"
```

---

## 📁 Recommended Folder Structure

```
res://
├── icons/          # UI icons (SVG)
│   ├── menu.svg
│   ├── settings.svg
│   ├── play.svg
│   └── quit.svg
├── ui/             # UI components (SVG)
│   ├── button_bg.svg
│   ├── panel_bg.svg
│   └── bar_fill.svg
├── branding/       # Logos (SVG)
│   ├── logo.svg
│   └── splash.svg
├── sprites/        # Game sprites (SVG)
│   ├── player.svg
│   └── enemy.svg
└── shapes/         # Geometric shapes (SVG)
    ├── circle.svg
    ├── triangle.svg
    └── square.svg
```

---

## 🎮 Complete Workflows

### Workflow 1: Icon-Based Menu

```
# 1. Discover icons
@godot get_assets_by_type asset_type="texture"

# 2. Create menu
@godot create_scene path="res://scenes/menu.tscn" root_type="Control"

# 3. Add button with icon
@godot add_node node_type="HBoxContainer" node_name="PlayButton"
@godot add_node parent_path="PlayButton" node_type="TextureRect" node_name="Icon"
@godot update_property node_path="PlayButton/Icon" property="texture" value="res://icons/play.svg"
@godot update_property node_path="PlayButton/Icon" property="custom_minimum_size" value="[32, 32]"
@godot add_node parent_path="PlayButton" node_type="Label" node_name="Label"
@godot update_property node_path="PlayButton/Label" property="text" value="Play Game"
```

### Workflow 2: HUD with Icons

```
# 1. Create HUD
@godot create_scene path="res://scenes/hud.tscn" root_type="CanvasLayer"

# 2. Add health display
@godot add_node node_type="HBoxContainer" node_name="Health"
@godot add_node parent_path="Health" node_type="TextureRect" node_name="Icon"
@godot update_property node_path="Health/Icon" property="texture" value="res://icons/heart.svg"
@godot update_property node_path="Health/Icon" property="custom_minimum_size" value="[24, 24]"
@godot add_node parent_path="Health" node_type="Label" node_name="Value"
@godot update_property node_path="Health/Value" property="text" value="100"

# 3. Add coin display
@godot add_node node_type="HBoxContainer" node_name="Coins"
@godot add_node parent_path="Coins" node_type="TextureRect" node_name="Icon"
@godot update_property node_path="Coins/Icon" property="texture" value="res://icons/coin.svg"
@godot update_property node_path="Coins/Icon" property="custom_minimum_size" value="[24, 24]"
@godot add_node parent_path="Coins" node_type="Label" node_name="Value"
@godot update_property node_path="Coins/Value" property="text" value="0"
```

### Workflow 3: 2D Game with SVG

```
# 1. Create player
@godot create_scene path="res://scenes/player.tscn" root_type="CharacterBody2D"
@godot add_node parent_path="." node_type="Sprite2D" node_name="Sprite"
@godot update_property node_path="Sprite" property="texture" value="res://sprites/player.svg"
@godot update_property node_path="Sprite" property="scale" value="[2.0, 2.0]"

# 2. Create enemy
@godot create_scene path="res://scenes/enemy.tscn" root_type="CharacterBody2D"
@godot add_node parent_path="." node_type="Sprite2D" node_name="Sprite"
@godot update_property node_path="Sprite" property="texture" value="res://sprites/enemy.svg"
@godot update_property node_path="Sprite" property="scale" value="[1.5, 1.5]"

# 3. Create level
@godot create_scene path="res://scenes/level.tscn" root_type="Node2D"
@godot add_scene parent_path="." scene_path="res://scenes/player.tscn"
@godot add_scene parent_path="." scene_path="res://scenes/enemy.tscn"
```

---

## 🆚 SVG vs PNG

### Use SVG for:

✅ UI icons and buttons  
✅ Logos and text  
✅ HUD elements  
✅ Simple geometric sprites  
✅ Symbols and indicators  
✅ Resolution-independent graphics  
✅ Minimalist art styles

### Use PNG for:

✅ Detailed pixel art  
✅ Complex textures  
✅ Photographic images  
✅ Heavily animated sprites  
✅ Particle effects  
✅ Detailed character art

---

## 📊 Quick Reference

| Task | Command | Value |
|------|---------|-------|
| Find SVG | `get_assets_by_type` | `asset_type="texture"` |
| Add to UI | `add_node` | `node_type="TextureRect"` |
| Add to game | `add_node` | `node_type="Sprite2D"` |
| Set size | `update_property` | `property="custom_minimum_size"` |
| Keep aspect | `update_property` | `property="expand_mode" value="1"` |
| Scale | `update_property` | `property="scale" value="[2.0, 2.0]"` |
| Tint color | `update_property` | `property="modulate"` |

---

## 💡 Pro Tips

### 1. Multi-Resolution Support

SVG automatically adapts to different screen sizes - perfect for mobile games!

### 2. Color Variants

Create multiple color variants from one SVG using `modulate`:

```
# Red variant
@godot update_property node_path="Icon1" property="modulate" value="[1.0, 0.0, 0.0, 1.0]"

# Blue variant
@godot update_property node_path="Icon2" property="modulate" value="[0.0, 0.0, 1.0, 1.0]"
```

### 3. Performance

SVG files are rasterized at import time, so they perform like regular textures!

### 4. Responsive UI

SVG scales perfectly for responsive UI that works on any screen size.

---

## 🎓 Learning Resources

- **[AI Instructions](../AI_INSTRUCTIONS.md)** - Complete AI guidance with SVG section
- **[Examples](EXAMPLES.md)** - Real-world usage examples
- **[Godot SVG Docs](https://docs.godotengine.org/)** - Official Godot documentation

---

## 🎉 Summary

SVG files are perfect for:
- ✅ Icons, logos, and UI elements
- ✅ Resolution-independent graphics
- ✅ Simple 2D game sprites
- ✅ Geometric shapes and patterns
- ✅ Multi-resolution support
- ✅ Easy color modification

**Use SVG for clean, scalable graphics that look perfect at any size!** 🎨✨

---

<div align="center">

**Build Beautiful, Scalable UIs and 2D Games with SVG!**

[Back to Documentation](../README.md)

</div>
