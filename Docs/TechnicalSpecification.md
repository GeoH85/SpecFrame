# SpecFrame Technical Specification
## Version 1.0.0 | Adfinium Engineering Standard: Pinnacle Tier

---

# §1 Product Definition

## 1.1 Purpose Statement

SpecFrame is a specification-first wireframing application for macOS. The specification is the product; the wireframe is its visual representation. Users input mathematical definitions; the canvas renders those definitions. This is not an artboard. This is not a drawing tool. This is a system for producing deterministic, engineer-ready UI specifications.

## 1.2 Target User

Specification authors who require:
- Pixel-precise UI definitions for implementation handoff
- Device-accurate safe areas and screen dimensions
- Exportable specifications in machine-readable formats
- Generated code scaffolds that match visual output exactly

Users expecting freeform creative tools will find SpecFrame restrictive by design.

## 1.3 Value Proposition

SpecFrame eliminates the gap between design intent and implementation outcome. When a specification states `x: 156, y: 84, width: 320, height: 48`, the generated SwiftUI code places that element at exactly those coordinates. The wireframe displays exactly those coordinates. The exported PNG renders exactly those coordinates. One source of truth, zero interpretation.

## 1.4 Platform Requirements

| Requirement | Value |
|-------------|-------|
| Operating System | macOS 14.0 Sonoma or later |
| Architecture | Apple Silicon native (arm64), Intel supported (x86_64) |
| Framework | AppKit |
| Distribution | Mac App Store |
| Sandbox | Required |
| Hardened Runtime | Required |

---

# §2 Coordinate System

## 2.1 Origin Definition

SpecFrame uses a **center-origin coordinate system**. The origin point (0, 0) is located at the exact center of the device screen.

```
                    +Y (North)
                       ↑
                       │
         ─────────────────────────────
        │             │               │
        │   (-X,-Y)   │   (+X,-Y)     │
        │             │               │
  -X ←──┼─────────────┼───────────────┼──→ +X (East)
        │             │               │
        │   (-X,+Y)   │   (+X,+Y)     │
        │             │               │
         ─────────────────────────────
                       │
                       ↓
                    -Y (South)
```

## 2.2 Axis Orientation

| Axis | Positive Direction | Negative Direction |
|------|-------------------|-------------------|
| X | East (right) | West (left) |
| Y | North (up) | South (down) |

## 2.3 Unit System

All measurements are in **points** (pt). One point equals one pixel at @1x scale factor.

| Scale Factor | Pixels per Point |
|--------------|------------------|
| @1x | 1 |
| @2x | 2 |
| @3x | 3 |

## 2.4 Element Positioning

Elements are positioned by their **center point**, not their top-left corner.

```
Element at (100, 50) with size (80, 40):

    Center: (100, 50)
    Top-Left: (60, 70)
    Top-Right: (140, 70)
    Bottom-Left: (60, 30)
    Bottom-Right: (140, 30)
```

## 2.5 Coordinate Transformation

To convert SpecFrame center-origin coordinates to SwiftUI top-left-origin coordinates:

```
swiftUI_x = specframe_x + (canvasWidth / 2)
swiftUI_y = (canvasHeight / 2) - specframe_y
```

To convert element center position to SwiftUI `.position()` modifier values:

```
position_x = element_center_x + (canvasWidth / 2)
position_y = (canvasHeight / 2) - element_center_y
```

## 2.6 Coordinate Display Format

Coordinates are displayed as `(X, Y)` with the following precision:

| Context | Decimal Places | Example |
|---------|---------------|---------|
| Inspector fields | 1 | `(156.5, 84.0)` |
| Specification output | 1 | `"x": 156.5` |
| Code generation | 1 | `.position(x: 156.5, y: 84.0)` |
| Internal storage | 2 | `156.50` |

Values are rounded to the nearest 0.5 points for pixel alignment at @2x.

---

# §3 Device Database

## 3.1 Supported Devices

### 3.1.1 iPhone Models

| Model | Screen (pt) | Screen (px) | Scale | Safe Area Top | Safe Area Bottom |
|-------|-------------|-------------|-------|---------------|------------------|
| iPhone 16 Pro Max | 440 × 956 | 1320 × 2868 | @3x | 62 | 34 |
| iPhone 16 Pro | 402 × 874 | 1206 × 2622 | @3x | 62 | 34 |
| iPhone 16 Plus | 430 × 932 | 1290 × 2796 | @3x | 59 | 34 |
| iPhone 16 | 393 × 852 | 1179 × 2556 | @3x | 59 | 34 |
| iPhone 15 Pro Max | 430 × 932 | 1290 × 2796 | @3x | 59 | 34 |
| iPhone 15 Pro | 393 × 852 | 1179 × 2556 | @3x | 59 | 34 |
| iPhone 15 Plus | 430 × 932 | 1290 × 2796 | @3x | 59 | 34 |
| iPhone 15 | 393 × 852 | 1179 × 2556 | @3x | 59 | 34 |
| iPhone 14 Pro Max | 430 × 932 | 1290 × 2796 | @3x | 59 | 34 |
| iPhone 14 Pro | 393 × 852 | 1179 × 2556 | @3x | 59 | 34 |
| iPhone 14 Plus | 428 × 926 | 1284 × 2778 | @3x | 47 | 34 |
| iPhone 14 | 390 × 844 | 1170 × 2532 | @3x | 47 | 34 |
| iPhone SE (3rd gen) | 375 × 667 | 750 × 1334 | @2x | 20 | 0 |

### 3.1.2 iPad Models

| Model | Screen (pt) | Screen (px) | Scale | Safe Area Top | Safe Area Bottom |
|-------|-------------|-------------|-------|---------------|------------------|
| iPad Pro 13" (M4) | 1032 × 1376 | 2064 × 2752 | @2x | 24 | 20 |
| iPad Pro 11" (M4) | 834 × 1210 | 1668 × 2420 | @2x | 24 | 20 |
| iPad Air 13" (M2) | 1024 × 1366 | 2048 × 2732 | @2x | 24 | 20 |
| iPad Air 11" (M2) | 820 × 1180 | 1640 × 2360 | @2x | 24 | 20 |
| iPad (10th gen) | 820 × 1180 | 1640 × 2360 | @2x | 24 | 20 |
| iPad mini (6th gen) | 744 × 1133 | 1488 × 2266 | @2x | 24 | 20 |

### 3.1.3 Mac Models

| Model | Screen (pt) | Screen (px) | Scale |
|-------|-------------|-------------|-------|
| MacBook Air 15" (M3) | 1710 × 1107 | 2880 × 1864 | @2x |
| MacBook Air 13" (M3) | 1470 × 956 | 2560 × 1664 | @2x |
| MacBook Pro 16" (M3) | 1728 × 1117 | 3456 × 2234 | @2x |
| MacBook Pro 14" (M3) | 1512 × 982 | 3024 × 1964 | @2x |
| iMac 24" (M3) | 2240 × 1260 | 4480 × 2520 | @2x |
| Studio Display | 2560 × 1440 | 5120 × 2880 | @2x |
| Pro Display XDR | 3200 × 1800 | 6016 × 3384 | @2x |

### 3.1.4 Apple Watch Models

| Model | Screen (pt) | Screen (px) | Scale |
|-------|-------------|-------------|-------|
| Apple Watch Ultra 2 (49mm) | 205 × 251 | 410 × 502 | @2x |
| Apple Watch Series 10 (46mm) | 208 × 248 | 416 × 496 | @2x |
| Apple Watch Series 10 (42mm) | 176 × 210 | 352 × 420 | @2x |
| Apple Watch SE (44mm) | 184 × 224 | 368 × 448 | @2x |
| Apple Watch SE (40mm) | 162 × 197 | 324 × 394 | @2x |

### 3.1.5 Apple TV Models

| Model | Screen (pt) | Screen (px) | Scale |
|-------|-------------|-------------|-------|
| Apple TV 4K (1080p) | 1920 × 1080 | 1920 × 1080 | @1x |
| Apple TV 4K (4K) | 3840 × 2160 | 3840 × 2160 | @1x |

### 3.1.6 Apple Vision Pro

| Model | Screen (pt) | Screen (px) | Scale |
|-------|-------------|-------------|-------|
| Vision Pro (Window) | 1280 × 720 | 1280 × 720 | @1x |

## 3.2 Default Device

When SpecFrame launches with no document open, the default device is **iPhone 16 Pro**.

## 3.3 Device Switching

Changing the target device after elements have been placed triggers the **Device Migration Dialog**:

| Option | Behavior |
|--------|----------|
| Scale to Fit | All element positions and sizes are scaled proportionally to the new screen dimensions |
| Preserve Coordinates | All element positions and sizes remain numerically identical; elements outside the new screen bounds are flagged |
| Cancel | Device change is aborted |

---

# §4 Canvas Architecture

## 4.1 Canvas Composition

The canvas consists of five layers rendered in this order (back to front):

| Layer | Z-Order | Content |
|-------|---------|---------|
| Background | 0 | Solid fill, color: `#1E1E1E` |
| Grid | 1 | Grid lines and origin crosshair |
| Device Frame | 2 | Screen boundary outline |
| Elements | 3 | User-placed wireframe elements |
| Guides & Selection | 4 | Rulers, guides, selection indicators, snap feedback |

## 4.2 Grid System

### 4.2.1 Grid Display

| Property | Value |
|----------|-------|
| Major grid spacing | 50 pt |
| Minor grid spacing | 10 pt |
| Major grid color | `#3A3A3A` |
| Minor grid color | `#2A2A2A` |
| Origin crosshair X-axis | `#888888`, solid line |
| Origin crosshair Y-axis | `#888888`, dashed line (4pt dash, 4pt gap) |
| Origin crosshair length | 20 pt beyond screen bounds |

### 4.2.2 Grid Visibility by Zoom Level

| Zoom Range | Major Grid | Minor Grid |
|------------|------------|------------|
| < 25% | Hidden | Hidden |
| 25% – 49% | Visible | Hidden |
| 50% – 199% | Visible | Visible |
| ≥ 200% | Visible | Visible (subdivided to 5 pt) |

### 4.2.3 Grid Snapping

Grid snap is **disabled by default**. When enabled (Toggle: `Cmd+Shift+G`):

| Snap Target | Increment |
|-------------|-----------|
| Major grid | 50 pt |
| Minor grid | 10 pt |

Snap tolerance: **8 screen pixels** (regardless of zoom level).

## 4.3 Rulers

### 4.3.1 Ruler Dimensions

| Property | Value |
|----------|-------|
| Ruler thickness | 20 pt |
| Horizontal ruler position | Top edge of canvas view |
| Vertical ruler position | Left edge of canvas view |

### 4.3.2 Ruler Graduations

| Zoom Range | Major Tick | Minor Tick | Label Interval |
|------------|------------|------------|----------------|
| < 25% | 100 pt | None | 200 pt |
| 25% – 49% | 50 pt | None | 100 pt |
| 50% – 99% | 50 pt | 10 pt | 50 pt |
| 100% – 199% | 10 pt | 5 pt | 50 pt |
| ≥ 200% | 10 pt | 1 pt | 10 pt |

### 4.3.3 Ruler Origin

Rulers display **center-origin values**. The center of the device screen shows `0` on both rulers. Negative values appear to the left (horizontal) and below (vertical) the origin.

## 4.4 Zoom System

### 4.4.1 Zoom Levels

Zoom uses **discrete levels** only:

```
10%, 25%, 33%, 50%, 67%, 75%, 100%, 150%, 200%, 300%, 400%, 600%, 800%, 1600%
```

### 4.4.2 Zoom Controls

| Action | Trigger |
|--------|---------|
| Zoom In | `Cmd+=` or `Cmd+Mouse Wheel Up` |
| Zoom Out | `Cmd+-` or `Cmd+Mouse Wheel Down` |
| Zoom to 100% | `Cmd+1` |
| Zoom to Fit | `Cmd+0` |
| Zoom to Selection | `Cmd+2` |

### 4.4.3 Zoom Behavior

Zoom centers on:
- **Cursor position** when using mouse wheel
- **Selection center** when using keyboard shortcuts with selection
- **Canvas center** when using keyboard shortcuts without selection

## 4.5 Pan and Scroll

| Action | Trigger |
|--------|---------|
| Pan | `Space + Drag` or `Middle Mouse Drag` or `Two-finger trackpad drag` |
| Scroll Vertical | `Mouse Wheel` or `Two-finger vertical swipe` |
| Scroll Horizontal | `Shift + Mouse Wheel` or `Two-finger horizontal swipe` |

---

# §5 Element System

## 5.1 Element Primitives

SpecFrame supports exactly **five element primitives**:

| Primitive | Purpose |
|-----------|---------|
| Rectangle | Containers, buttons, cards, backgrounds |
| Text | Labels, placeholder text, headings |
| Line | Dividers, connectors |
| Ellipse | Icons, avatars, circular elements |
| Group | Logical grouping of elements |

No other element types exist. Images are represented as rectangles with crosshatch fill. Icons are represented as rectangles with "×" placeholder.

## 5.2 Element Properties

### 5.2.1 Universal Properties (All Elements)

| Property | Type | Default | Range/Values |
|----------|------|---------|--------------|
| `id` | UUID | Auto-generated | — |
| `name` | String | `"Untitled [Type]"` | 1–64 characters |
| `x` | Float | `0.0` | Any |
| `y` | Float | `0.0` | Any |
| `rotation` | Float | `0.0` | -180.0 to 180.0 |
| `opacity` | Float | `1.0` | 0.0 to 1.0 |
| `locked` | Boolean | `false` | — |
| `visible` | Boolean | `true` | — |

### 5.2.2 Rectangle Properties

| Property | Type | Default | Range/Values |
|----------|------|---------|--------------|
| `width` | Float | `100.0` | 1.0 to 10000.0 |
| `height` | Float | `100.0` | 1.0 to 10000.0 |
| `cornerRadius` | Float[4] | `[0,0,0,0]` | 0.0 to min(width,height)/2 |
| `fill` | Fill | Solid `#FFFFFF` | See §5.3 |
| `stroke` | Stroke | None | See §5.4 |

Corner radius order: `[topLeft, topRight, bottomRight, bottomLeft]`

### 5.2.3 Text Properties

| Property | Type | Default | Range/Values |
|----------|------|---------|--------------|
| `content` | String | `"Label"` | 1–1000 characters |
| `fontSize` | Float | `17.0` | 8.0 to 144.0 |
| `fontWeight` | Enum | `regular` | ultraLight, thin, light, regular, medium, semibold, bold, heavy, black |
| `fontFamily` | String | `"SF Pro"` | System fonts only |
| `textAlignment` | Enum | `leading` | leading, center, trailing |
| `lineHeight` | Float | `1.2` | 0.5 to 3.0 (multiplier) |
| `textColor` | Color | `#000000` | Hex color |

### 5.2.4 Line Properties

| Property | Type | Default | Range/Values |
|----------|------|---------|--------------|
| `x2` | Float | `100.0` | Any |
| `y2` | Float | `0.0` | Any |
| `strokeWidth` | Float | `1.0` | 0.5 to 20.0 |
| `strokeColor` | Color | `#000000` | Hex color |
| `strokeStyle` | Enum | `solid` | solid, dashed, dotted |
| `dashLength` | Float | `5.0` | 1.0 to 50.0 |
| `dashGap` | Float | `5.0` | 1.0 to 50.0 |

Line position `(x, y)` is the start point; `(x2, y2)` is the end point (relative to element origin).

### 5.2.5 Ellipse Properties

| Property | Type | Default | Range/Values |
|----------|------|---------|--------------|
| `width` | Float | `100.0` | 1.0 to 10000.0 |
| `height` | Float | `100.0` | 1.0 to 10000.0 |
| `fill` | Fill | Solid `#FFFFFF` | See §5.3 |
| `stroke` | Stroke | None | See §5.4 |

### 5.2.6 Group Properties

| Property | Type | Default | Range/Values |
|----------|------|---------|--------------|
| `children` | Element[] | `[]` | — |

Group position `(x, y)` is the center of the bounding box of all children. Child coordinates are relative to the group center.

## 5.3 Fill Types

| Fill Type | Properties | Example |
|-----------|------------|---------|
| None | — | Transparent |
| Solid | `color` (Hex) | `#007AFF` |
| Pattern | `patternId`, `patternColor`, `backgroundColor` | See §5.5 |

## 5.4 Stroke Definition

| Property | Type | Default |
|----------|------|---------|
| `color` | Color | `#000000` |
| `width` | Float | `1.0` |
| `style` | Enum | `solid` |
| `position` | Enum | `center` |

Stroke position: `inside`, `center`, `outside`

## 5.5 Pattern Library

### 5.5.1 Built-in Patterns

| Pattern ID | Description | Parameters |
|------------|-------------|------------|
| `hlines` | Horizontal lines | `spacing`: 8 pt, `strokeWidth`: 1 pt |
| `vlines` | Vertical lines | `spacing`: 8 pt, `strokeWidth`: 1 pt |
| `dlines-45` | Diagonal lines (45°) | `spacing`: 8 pt, `strokeWidth`: 1 pt |
| `dlines-135` | Diagonal lines (135°) | `spacing`: 8 pt, `strokeWidth`: 1 pt |
| `crosshatch` | Crosshatch (90°) | `spacing`: 8 pt, `strokeWidth`: 1 pt |
| `crosshatch-45` | Diagonal crosshatch | `spacing`: 8 pt, `strokeWidth`: 1 pt |
| `dots` | Dot grid | `spacing`: 8 pt, `dotRadius`: 1 pt |
| `image-placeholder` | Image placeholder (×) | — |

### 5.5.2 Pattern Colors

| Property | Default |
|----------|---------|
| `patternColor` | `#888888` |
| `backgroundColor` | `#FFFFFF` |

---

# §6 Interaction Model

## 6.1 Input Hierarchy

SpecFrame prioritizes input methods in this order:

1. **Keyboard coordinate entry** (highest precision)
2. **Inspector field entry** (high precision)
3. **Snap-assisted mouse placement** (medium precision)
4. **Freeform mouse placement** (lowest precision, discouraged)

## 6.2 Element Creation

### 6.2.1 Creation Methods

| Method | Workflow |
|--------|----------|
| Toolbar Click | Click tool → Click canvas to place at default size at click point |
| Toolbar Drag | Click tool → Drag on canvas to define position and size |
| Menu Command | Insert menu → Element type → Places at canvas center at default size |
| Keyboard Shortcut | Press shortcut → Places at canvas center at default size |

### 6.2.2 Creation Shortcuts

| Element | Shortcut |
|---------|----------|
| Rectangle | `R` |
| Text | `T` |
| Line | `L` |
| Ellipse | `O` |
| Group Selection | `Cmd+G` |
| Ungroup | `Cmd+Shift+G` |

### 6.2.3 Default Sizes

| Element | Default Size |
|---------|--------------|
| Rectangle | 100 × 100 pt |
| Text | Intrinsic (based on content) |
| Line | 100 pt horizontal |
| Ellipse | 100 × 100 pt |

## 6.3 Selection

### 6.3.1 Selection Methods

| Action | Trigger |
|--------|---------|
| Select single | Click element |
| Add to selection | `Shift+Click` |
| Toggle in selection | `Cmd+Click` |
| Select all | `Cmd+A` |
| Deselect all | `Escape` or click empty canvas |
| Marquee select (contains) | Drag left-to-right |
| Marquee select (intersects) | Drag right-to-left |

### 6.3.2 Selection Appearance

| State | Appearance |
|-------|------------|
| Selected | White outline (2 pt, `#FFFFFF`), corner handles (8 × 8 pt squares, white fill, `#000000` stroke) |
| Multi-selected | White outline on each element, unified bounding box with handles |
| Hover (unselected) | White dashed outline (1 pt, `#FFFFFF`, 4pt dash, 4pt gap) |

## 6.4 Manipulation

### 6.4.1 Move

| Action | Trigger |
|--------|---------|
| Move freely | Drag selection |
| Move constrained (H/V) | `Shift+Drag` |
| Nudge 1 pt | Arrow keys |
| Nudge 10 pt | `Shift+Arrow` keys |
| Move to coordinates | Enter values in Inspector |

### 6.4.2 Resize

| Action | Trigger |
|--------|---------|
| Resize freely | Drag corner handle |
| Resize proportionally | `Shift+Drag` corner handle |
| Resize from center | `Option+Drag` handle |
| Resize proportionally from center | `Shift+Option+Drag` handle |
| Resize to dimensions | Enter values in Inspector |

### 6.4.3 Rotate

| Action | Trigger |
|--------|---------|
| Rotate freely | `Cmd+Drag` outside selection bounds |
| Rotate in 15° increments | `Shift+Cmd+Drag` |
| Rotate to angle | Enter value in Inspector |

### 6.4.4 Transform Origin

All transforms (rotate, scale from center) use the **element center** as origin. This is not configurable.

## 6.5 Snapping

### 6.5.1 Snap Types

| Snap Type | Default State | Toggle |
|-----------|---------------|--------|
| Grid snap | Off | `Cmd+Shift+'` |
| Edge snap | On | `Cmd+'` |
| Center snap | On | — (follows Edge snap) |
| Spacing snap | On | — (follows Edge snap) |

### 6.5.2 Snap Tolerance

**8 screen pixels** at all zoom levels.

### 6.5.3 Snap Priority

When multiple snap points are within tolerance:

1. Element edge (highest)
2. Element center
3. Canvas center (origin)
4. Grid intersection
5. Grid line (lowest)

### 6.5.4 Snap Feedback

| Feedback | Appearance |
|----------|------------|
| Alignment guide | White line (`#FFFFFF`), 1 pt, extends to canvas edge |
| Spacing indicator | White line with dimension label (black text on white background) |
| Snap point | White circle (`#FFFFFF`), 6 pt diameter, 1 pt black stroke |

## 6.6 Inspector Panel

### 6.6.1 Inspector Location

Right edge of window, fixed width: **260 pt**.

### 6.6.2 Inspector Sections

| Section | Contents | Collapsed by Default |
|---------|----------|---------------------|
| Transform | X, Y, W, H, Rotation | No |
| Fill | Fill type, color, pattern | No |
| Stroke | Stroke toggle, color, width, style | Yes |
| Text | Font, size, weight, alignment, color | No (text elements only) |
| Constraints | Future feature placeholder | Yes |

### 6.6.3 Numeric Field Behavior

| Action | Trigger |
|--------|---------|
| Direct entry | Click field, type value, press Enter |
| Increment by 1 | Up/Down arrow while field focused |
| Increment by 10 | `Shift+Up/Down` arrow |
| Increment by 0.1 | `Option+Up/Down` arrow |
| Scrub | Click-drag horizontally on field label |
| Scrub coarse | `Shift+Scrub` (10× increment) |
| Scrub fine | `Option+Scrub` (0.1× increment) |
| Expression | Type expression (e.g., `100+50`, `50%`), press Enter |

### 6.6.4 Supported Expressions

| Expression | Example | Result (if width is 200) |
|------------|---------|--------------------------|
| Addition | `100+50` | `150` |
| Subtraction | `100-20` | `80` |
| Multiplication | `10*5` | `50` |
| Division | `100/2` | `50` |
| Percentage | `50%` | `100` (50% of current value) |
| Mixed | `50%+10` | `110` |

Expressions are evaluated and stored as absolute values. The expression itself is not stored.

## 6.7 Keyboard Shortcuts

### 6.7.1 File Operations

| Action | Shortcut |
|--------|----------|
| New Document | `Cmd+N` |
| Open | `Cmd+O` |
| Save | `Cmd+S` |
| Save As | `Cmd+Shift+S` |
| Export Specification | `Cmd+E` |
| Export PNG | `Cmd+Shift+E` |
| Export SVG | `Cmd+Option+E` |

### 6.7.2 Edit Operations

| Action | Shortcut |
|--------|----------|
| Undo | `Cmd+Z` |
| Redo | `Cmd+Shift+Z` |
| Cut | `Cmd+X` |
| Copy | `Cmd+C` |
| Paste | `Cmd+V` |
| Paste in Place | `Cmd+Shift+V` |
| Duplicate | `Cmd+D` |
| Delete | `Backspace` or `Delete` |
| Select All | `Cmd+A` |

### 6.7.3 View Operations

| Action | Shortcut |
|--------|----------|
| Zoom In | `Cmd+=` |
| Zoom Out | `Cmd+-` |
| Zoom to 100% | `Cmd+1` |
| Zoom to Fit | `Cmd+0` |
| Zoom to Selection | `Cmd+2` |
| Toggle Rulers | `Cmd+R` |
| Toggle Grid | `Cmd+Shift+'` |
| Toggle Guides | `Cmd+;` |

### 6.7.4 Element Operations

| Action | Shortcut |
|--------|----------|
| Bring to Front | `Cmd+Shift+]` |
| Bring Forward | `Cmd+]` |
| Send Backward | `Cmd+[` |
| Send to Back | `Cmd+Shift+[` |
| Group | `Cmd+G` |
| Ungroup | `Cmd+Shift+G` |
| Lock | `Cmd+L` |
| Unlock All | `Cmd+Option+L` |
| Hide | `Cmd+H` |
| Show All | `Cmd+Option+H` |

---

# §7 Specification Panel

## 7.1 Panel Location

Left edge of window, fixed width: **320 pt**. Collapsible via `Cmd+Option+S`.

## 7.2 Panel Structure

The Specification Panel displays a **live, read-only specification** of the current document. It updates in real-time as elements are modified.

```
┌─────────────────────────────────────┐
│ SPECIFICATION                   [●] │
├─────────────────────────────────────┤
│ ▼ Document                          │
│   Device: iPhone 16 Pro             │
│   Screen: 402 × 874 pt              │
│   Safe Area: T:62 B:34 L:0 R:0      │
│   Elements: 12                      │
│   Groups: 2                         │
├─────────────────────────────────────┤
│ ▼ Selected: "Header Bar"            │
│   Type: Rectangle                   │
│   Position: (0.0, 403.0)            │
│   Size: 402.0 × 44.0                │
│   Fill: #F5F5F5                     │
│   Corner Radius: [0, 0, 0, 0]       │
│   Stroke: None                      │
├─────────────────────────────────────┤
│ ▼ Generated Code                    │
│ ┌─────────────────────────────────┐ │
│ │ Rectangle()                     │ │
│ │   .fill(Color(hex: "F5F5F5"))   │ │
│ │   .frame(width: 402, height: 44)│ │
│ │   .position(x: 201, y: 34)      │ │
│ └─────────────────────────────────┘ │
│                            [Copy]   │
└─────────────────────────────────────┘
```

## 7.3 Specification Completeness

The panel displays a **completeness indicator** using shape differentiation:

| Status | Condition | Indicator |
|--------|-----------|-----------|
| Complete | All elements have explicit sizes and positions | Filled circle ● |
| Incomplete | One or more elements have default/unset properties | Hollow circle ○ |
| Invalid | Overlapping constraints or impossible layouts | Cross × |

## 7.4 Validation Rules

| Rule | Condition | Severity |
|------|-----------|----------|
| Unnamed element | Element name is default (`"Untitled..."`) | Warning |
| Off-screen element | Element center is outside device bounds | Warning |
| Zero dimension | Width or height is 0 | Error |
| Overlapping siblings | Two elements at same Z-order occupy same space | Info |

---

# §8 Export System

## 8.1 Export Formats

| Format | Extension | Purpose |
|--------|-----------|---------|
| Specification (JSON) | `.spec.json` | Machine-readable specification |
| Specification (Markdown) | `.spec.md` | Human-readable specification |
| Specification (PDF) | `.spec.pdf` | Print-ready specification sheet |
| Code (SwiftUI) | `.swift` | Generated SwiftUI view code |
| Image (PNG) | `.png` | Raster image at specified DPI |
| Image (SVG) | `.svg` | Vector image |

## 8.2 JSON Specification Schema

```json
{
  "$schema": "https://specframe.app/schemas/v1/spec.json",
  "specVersion": "1.0.0",
  "generator": "SpecFrame/1.0.0",
  "created": "2025-01-15T10:30:00Z",
  "document": {
    "name": "Login Screen",
    "device": {
      "name": "iPhone 16 Pro",
      "os": "iOS",
      "screenWidth": 402,
      "screenHeight": 874,
      "scaleFactor": 3,
      "safeArea": {
        "top": 62,
        "bottom": 34,
        "left": 0,
        "right": 0
      }
    },
    "coordinateSystem": {
      "origin": "center",
      "xPositive": "east",
      "yPositive": "north"
    }
  },
  "tokens": {
    "colors": {},
    "spacing": {},
    "cornerRadius": {}
  },
  "elements": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Header Bar",
      "type": "rectangle",
      "position": { "x": 0.0, "y": 403.0 },
      "size": { "width": 402.0, "height": 44.0 },
      "rotation": 0.0,
      "opacity": 1.0,
      "fill": {
        "type": "solid",
        "color": "#F5F5F5"
      },
      "stroke": null,
      "cornerRadius": [0, 0, 0, 0]
    }
  ]
}
```

## 8.3 SwiftUI Code Generation

### 8.3.1 Output Structure

```swift
// Generated by SpecFrame 1.0.0
// Device: iPhone 16 Pro (402 × 874 pt)
// Created: 2025-01-15T10:30:00Z

import SwiftUI

struct LoginScreenWireframe: View {
    var body: some View {
        ZStack {
            // Header Bar
            Rectangle()
                .fill(Color(hex: "F5F5F5"))
                .frame(width: 402, height: 44)
                .position(x: 201, y: 34)
        }
        .frame(width: 402, height: 874)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        // Implementation
    }
}

#Preview {
    LoginScreenWireframe()
}
```

### 8.3.2 Coordinate Transformation

Generated `.position(x:y:)` values use SwiftUI's top-left origin coordinate system:

```
swiftUI_x = specframe_x + (screenWidth / 2)
swiftUI_y = (screenHeight / 2) - specframe_y
```

### 8.3.3 Code Generation Rules

| Element | SwiftUI Output |
|---------|----------------|
| Rectangle | `Rectangle()` with `.fill()`, `.frame()`, `.position()` |
| Rectangle (rounded) | `RoundedRectangle(cornerRadius:)` or custom shape for asymmetric |
| Ellipse | `Ellipse()` with `.fill()`, `.frame()`, `.position()` |
| Text | `Text()` with `.font()`, `.foregroundColor()`, `.position()` |
| Line | `Path` with `move(to:)` and `addLine(to:)` |
| Group | Nested `ZStack` |
| Pattern fill | Custom `Shape` with pattern `ShapeStyle` |

## 8.4 PNG Export

### 8.4.1 Export Presets

| Preset | Scale Factor | DPI | Use Case |
|--------|--------------|-----|----------|
| @1x | 1.0 | 72 | Standard screen |
| @2x | 2.0 | 144 | Retina screen |
| @3x | 3.0 | 216 | Super Retina screen |
| Print (Standard) | 4.17 | 300 | Standard print |
| Print (High) | 8.33 | 600 | High-quality print |
| Custom | User-defined | User-defined | — |

### 8.4.2 PNG Export Settings

| Setting | Options | Default |
|---------|---------|---------|
| Background | Transparent, White, Device Color | Transparent |
| Include device frame | Yes, No | No |
| Color profile | sRGB, Display P3 | sRGB |

## 8.5 SVG Export

### 8.5.1 SVG Structure

```svg
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     viewBox="0 0 402 874"
     width="402"
     height="874">
  <title>Login Screen</title>
  <desc>Generated by SpecFrame 1.0.0</desc>

  <defs>
    <!-- Pattern definitions -->
  </defs>

  <!-- Elements -->
  <rect id="header-bar" x="0" y="0" width="402" height="44" fill="#F5F5F5"/>

</svg>
```

### 8.5.2 SVG Coordinate Transformation

SVG uses top-left origin. Transformation from SpecFrame center-origin:

```
svg_x = specframe_x - (element_width / 2) + (screenWidth / 2)
svg_y = (screenHeight / 2) - specframe_y - (element_height / 2)
```

### 8.5.3 SVG Precision

All coordinate values are rounded to **2 decimal places**.

---

# §9 Document Format

## 9.1 File Extension

`.specframe`

## 9.2 UTType

| Property | Value |
|----------|-------|
| Identifier | `com.adfinium.specframe.document` |
| Conforms To | `public.composite-content`, `public.data` |
| Description | SpecFrame Document |

## 9.3 File Structure

`.specframe` files are ZIP archives containing:

```
document.specframe/
├── manifest.json          # Document metadata
├── document.json          # Element data
├── tokens.json            # Design tokens (DTCG format)
├── assets/                # Embedded images (future)
│   └── {sha256}.png
└── previews/
    ├── preview.png        # Document preview (512px max)
    └── thumbnail.png      # Finder thumbnail (256px)
```

## 9.4 manifest.json

```json
{
  "specframeVersion": "1.0.0",
  "documentVersion": 1,
  "created": "2025-01-15T10:30:00Z",
  "modified": "2025-01-15T14:22:00Z",
  "name": "Login Screen",
  "device": {
    "identifier": "iphone-16-pro",
    "name": "iPhone 16 Pro",
    "os": "iOS"
  }
}
```

## 9.5 document.json

```json
{
  "canvas": {
    "width": 402,
    "height": 874,
    "backgroundColor": "#FFFFFF"
  },
  "safeArea": {
    "top": 62,
    "bottom": 34,
    "left": 0,
    "right": 0
  },
  "elements": [
    // Element array as defined in §8.2
  ]
}
```

## 9.6 Autosave

| Property | Value |
|----------|-------|
| Autosave enabled | Yes |
| Autosave interval | System-managed (NSDocument) |
| Version browser support | Yes |

## 9.7 Document Versioning

| Document Version | SpecFrame Version | Migration |
|------------------|-------------------|-----------|
| 1 | 1.0.x | Current |

Migration logic is triggered when `manifest.documentVersion` is less than the current version. Migration transforms the document structure and increments the version.

---

# §10 Application Architecture

## 10.1 Window Structure

```
┌─────────────────────────────────────────────────────────────────────┐
│ SpecFrame — Login Screen.specframe                          ─ □ ✕ │
├──────────────────┬────────────────────────────────────────┬─────────────────┤
│                  │ [Rulers]                        │                 │
│                  ├────────────────────────────────┤                 │
│   SPECIFICATION  │                                │    INSPECTOR    │
│   PANEL          │                                │    PANEL        │
│   (320 pt)       │         CANVAS                 │    (260 pt)     │
│                  │                                │                 │
│                  │                                │                 │
│                  │                                │                 │
│                  │                                │                 │
├──────────────────┴────────────────────────────────┴─────────────────┤
│ [Status Bar: Zoom: 100% | Cursor: (0, 0) | Selection: Header Bar]  │
└─────────────────────────────────────────────────────────────────────┘
```

## 10.2 Minimum Window Size

| Dimension | Value |
|-----------|-------|
| Minimum width | 960 pt |
| Minimum height | 600 pt |

## 10.3 Panel Behavior

| Panel | Default State | Collapsed Width | Toggle |
|-------|---------------|-----------------|--------|
| Specification | Visible | 0 pt | `Cmd+Option+S` |
| Inspector | Visible | 0 pt | `Cmd+Option+I` |

## 10.4 Toolbar

The toolbar contains:

| Item | Type | Icon | Action |
|------|------|------|--------|
| Device Selector | Dropdown | Device icon | Opens device picker |
| Separator | — | — | — |
| Selection Tool | Toggle | Arrow | Activates selection mode |
| Rectangle Tool | Toggle | Square | Activates rectangle creation |
| Text Tool | Toggle | T | Activates text creation |
| Line Tool | Toggle | Diagonal line | Activates line creation |
| Ellipse Tool | Toggle | Circle | Activates ellipse creation |
| Separator | — | — | — |
| Export | Button | Share icon | Opens export menu |

## 10.5 Status Bar

The status bar displays:

| Item | Format | Example |
|------|--------|---------|
| Zoom level | `Zoom: {n}%` | `Zoom: 100%` |
| Cursor position | `Cursor: ({x}, {y})` | `Cursor: (156.0, 84.0)` |
| Selection | `Selection: {name}` or `Selection: {n} elements` | `Selection: Header Bar` |
| Specification status | Shape indicator | ● (complete), ○ (incomplete), × (invalid) |

---

# §11 Implementation Notes

## 11.1 Rendering Pipeline

| Layer | Technology |
|-------|------------|
| Canvas background | Core Graphics (`CGContext`) |
| Grid and guides | Core Graphics |
| Device frame | Core Graphics |
| Elements | Core Graphics |
| Selection UI | Core Animation (`CALayer`) |
| Rulers | `NSRulerView` subclass |

## 11.2 Data Flow

```
User Input → Document Model → Canvas View (render)
                ↓
          Specification Panel (display)
                ↓
          Export Pipeline (output)
```

## 11.3 Undo/Redo Granularity

| Action | Undo Unit |
|--------|-----------|
| Create element | Single undo |
| Delete element(s) | Single undo |
| Move element(s) | Single undo (coalesced during drag) |
| Resize element | Single undo (coalesced during drag) |
| Rotate element | Single undo (coalesced during drag) |
| Property change | Single undo per property |
| Group/Ungroup | Single undo |
| Paste | Single undo |

## 11.4 Performance Targets

| Metric | Target |
|--------|--------|
| Canvas frame rate | 60 fps during pan/zoom |
| Element limit (responsive) | 500 elements |
| Document open time | < 500ms for typical document |
| Export time (PNG @3x) | < 2s for typical document |

## 11.5 Accessibility

| Feature | Implementation |
|---------|----------------|
| VoiceOver | All controls labeled; element list navigable |
| Keyboard navigation | Full keyboard access to all functions |
| Reduce Motion | Snap animations disabled |
| Increase Contrast | Selection outlines thickened |

---

# §12 Future Considerations

The following features are explicitly **out of scope** for version 1.0 but are architecturally anticipated:

| Feature | Consideration |
|---------|---------------|
| Constraints system | Element property structure includes placeholder |
| Component library | Document format supports external references |
| Collaboration | Document format is merge-friendly JSON |
| Custom patterns | Pattern system is extensible |
| Plugin API | Architecture separates model from view |
| iOS companion | Core logic in framework, not app target |

---

# Appendix A: Color Definitions

## A.1 Design Principle

SpecFrame uses a monochromatic palette. The interface disappears; the specification demands attention. Color is noise. Shape and contrast provide differentiation.

## A.2 The Palette

| Role | Hex Value | Usage |
|------|-----------|-------|
| Black | `#000000` | Element default stroke, text, handle outlines |
| White | `#FFFFFF` | Element default fill, selection UI, guides, active indicators |
| Grey (Primary UI) | `#888888` | Origin crosshair, secondary indicators |
| Grey (Tertiary) | `#3A3A3A` | Grid major lines |
| Grey (Quaternary) | `#2A2A2A` | Grid minor lines |
| Canvas | `#1E1E1E` | Canvas background |

## A.3 UI Element Colors

| Element | Value |
|---------|-------|
| Canvas background | `#1E1E1E` |
| Panel background | System (adapts to macOS appearance) |
| Selection outline | `#FFFFFF` |
| Selection handle fill | `#FFFFFF` |
| Selection handle stroke | `#000000` |
| Hover outline | `#FFFFFF` (dashed) |
| Snap guide | `#FFFFFF` |
| Snap point | `#FFFFFF` fill, `#000000` stroke |
| Grid major | `#3A3A3A` |
| Grid minor | `#2A2A2A` |
| Origin X-axis | `#888888` (solid) |
| Origin Y-axis | `#888888` (dashed) |
| Dimension labels | `#000000` text on `#FFFFFF` background |

## A.4 Specification Status Indicators

Status is communicated through **shape**, not color:

| Status | Shape | Meaning |
|--------|-------|---------|
| Complete | ● (filled circle) | All elements fully specified |
| Incomplete | ○ (hollow circle) | One or more elements have default values |
| Invalid | × (cross) | Conflicting or impossible specifications |

---

# Appendix B: Typography

## B.1 UI Typography

| Element | Font | Size | Weight |
|---------|------|------|--------|
| Panel header | SF Pro | 13 pt | Semibold |
| Panel label | SF Pro | 11 pt | Regular |
| Panel value | SF Pro Mono | 11 pt | Regular |
| Inspector field | SF Pro | 13 pt | Regular |
| Status bar | SF Pro | 11 pt | Regular |
| Code preview | SF Mono | 11 pt | Regular |

---

# Appendix C: Default Element Styles

## C.1 New Rectangle

| Property | Value |
|----------|-------|
| Size | 100 × 100 pt |
| Fill | Solid `#FFFFFF` |
| Stroke | `#000000`, 1 pt, solid, center |
| Corner radius | 0 |

## C.2 New Text

| Property | Value |
|----------|-------|
| Content | `"Label"` |
| Font | SF Pro, 17 pt, Regular |
| Color | `#000000` |
| Alignment | Leading |

## C.3 New Line

| Property | Value |
|----------|-------|
| Length | 100 pt (horizontal) |
| Stroke | `#000000`, 1 pt, solid |

## C.4 New Ellipse

| Property | Value |
|----------|-------|
| Size | 100 × 100 pt |
| Fill | Solid `#FFFFFF` |
| Stroke | `#000000`, 1 pt, solid, center |

---

# Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-15 | SpecFrame Team | Initial specification |

---

**END OF SPECIFICATION**
