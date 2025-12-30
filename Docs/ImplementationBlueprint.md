# SpecFrame Implementation Blueprint
## Version 1.0.0 | Adfinium Engineering Standard: Pinnacle Tier

---

# Preamble

This document defines the build sequence for SpecFrame. It is not a suggestion. It is an instruction set.

Each sprint is a bounded unit of work with:
- **Entry Criteria:** What must be true before work begins
- **Scope:** Exactly what is built, referencing Technical Specification sections
- **Exit Criteria:** What must be true for the sprint to pass audit
- **Documentation Requirements:** What the implementation agent must produce
- **Audit Protocol:** How the output is evaluated against intent

The implementation agent (Claude Code) operates under these constraints:
1. No deviation from Technical Specification without documented justification
2. All decisions logged with rationale
3. All interpretations flagged explicitly
4. Code and documentation are equal outputs

---

# Documentation Standards

## Required Documentation Per Sprint

The implementation agent SHALL produce the following for each sprint:

### 1. Engineering Log (`ENGINEERING_LOG.md`)

Chronological record of implementation decisions.

```markdown
## [Timestamp] Decision: [Title]

**Context:** What prompted this decision
**Options Considered:** List of alternatives
**Decision:** What was chosen
**Rationale:** Why this option
**Specification Reference:** §X.X.X or "Not specified"
**Interpretation Required:** Yes/No
**If Yes, Interpretation Detail:** What was assumed
```

### 2. Design Notes (`DESIGN_NOTES.md`)

Architectural decisions and patterns employed.

```markdown
## [Component Name]

**Purpose:** Single sentence
**Pattern:** Named pattern (MVC, Observer, etc.) or "Custom"
**Dependencies:** What this component requires
**Dependents:** What requires this component
**Specification Alignment:** How this maps to spec sections
**Deviations:** None, or explicit list with justification
```

### 3. Implementation Record (`IMPLEMENTATION_RECORD.md`)

Line-level traceability.

```markdown
## [File Path]

| Lines | Specification Reference | Notes |
|-------|------------------------|-------|
| 1-15 | §9.4 manifest.json | Direct implementation |
| 16-42 | §2.5 Coordinate Transformation | Interpretation: rounded to 2 decimal places per §2.6 |
| 43-67 | Not specified | Utility function for ZIP handling |
```

### 4. Interpretation Register (`INTERPRETATION_REGISTER.md`)

Every instance where the specification did not fully determine the implementation.

```markdown
## Interpretation #[N]

**Location:** [File:Line]
**Specification Gap:** What was not specified
**Interpretation Made:** What was assumed/decided
**Confidence:** High/Medium/Low
**Risk:** What could break if this interpretation is wrong
**Recommendation:** Clarification needed in spec? Y/N
```

### 5. Test Manifest (`TEST_MANIFEST.md`)

Verification coverage.

```markdown
## [Feature/Component]

| Test ID | Description | Specification Reference | Status |
|---------|-------------|------------------------|--------|
| T001 | Document saves to ZIP | §9.3 | Pass/Fail/Pending |
```

---

# Sprint Definitions

---

## Sprint 0: Project Scaffold

### Purpose
Establish the Xcode project structure, build configuration, and documentation framework. No functional code.

### Entry Criteria
- Technical Specification v1.0.0 approved
- Implementation Blueprint approved
- Development environment ready (Xcode 15+, macOS 14+)

### Scope

| Task | Specification Reference |
|------|------------------------|
| Create Xcode project (Document-based App template) | §1.4, §10.1 |
| Configure bundle identifier: `com.adfinium.specframe` | §9.2 |
| Configure UTType: `com.adfinium.specframe.document` | §9.2 |
| Set deployment target: macOS 14.0 | §1.4 |
| Create folder structure for documentation | Blueprint |
| Initialize ENGINEERING_LOG.md | Blueprint |
| Initialize DESIGN_NOTES.md | Blueprint |
| Configure App Sandbox entitlements | §1.4 |
| Configure Hardened Runtime | §1.4 |

### Deliverables

```
SpecFrame/
├── SpecFrame.xcodeproj
├── SpecFrame/
│   ├── App/
│   │   └── SpecFrameApp.swift
│   ├── Document/
│   ├── Model/
│   ├── Views/
│   │   ├── Canvas/
│   │   ├── Inspector/
│   │   ├── Specification/
│   │   └── Toolbar/
│   ├── Export/
│   ├── Resources/
│   └── Info.plist
├── Documentation/
│   ├── ENGINEERING_LOG.md
│   ├── DESIGN_NOTES.md
│   ├── IMPLEMENTATION_RECORD.md
│   ├── INTERPRETATION_REGISTER.md
│   └── TEST_MANIFEST.md
└── README.md
```

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Project builds without error | `xcodebuild` succeeds |
| App launches to empty window | Manual verification |
| UTType registered in Info.plist | Plist inspection |
| Sandbox entitlements configured | Entitlements file inspection |
| Documentation files exist and have correct headers | File inspection |

### Audit Questions

1. Does the folder structure support the architectural separation defined in §10?
2. Are all bundle identifiers exactly as specified?
3. Is the deployment target exactly macOS 14.0?
4. Were any decisions made that required interpretation? If so, are they logged?

---

## Sprint 1: Document Model & Persistence

### Purpose
Implement the core data model and file persistence. The document can be created, saved, and opened. No UI beyond default window.

### Entry Criteria
- Sprint 0 passed audit
- No unresolved interpretations from Sprint 0

### Scope

| Task | Specification Reference |
|------|------------------------|
| Define `Device` struct with all properties | §3.1, §3.2 |
| Populate device database (all 30+ devices) | §3.1.1 – §3.1.6 |
| Define `Element` protocol and concrete types | §5.1, §5.2 |
| Define `Fill` enum (None, Solid, Pattern) | §5.3 |
| Define `Stroke` struct | §5.4 |
| Define `Pattern` enum with all built-in patterns | §5.5.1 |
| Define `SpecFrameDocument` (NSDocument subclass) | §9.6 |
| Implement `manifest.json` encoding/decoding | §9.4 |
| Implement `document.json` encoding/decoding | §9.5 |
| Implement ZIP archive creation/extraction | §9.3 |
| Implement autosave | §9.6 |
| Write unit tests for all model types | Blueprint |
| Write unit tests for document persistence | Blueprint |

### Data Model Structures

```swift
// These signatures are requirements, not suggestions

struct Device: Codable, Identifiable {
    let id: String                    // e.g., "iphone-16-pro"
    let name: String                  // e.g., "iPhone 16 Pro"
    let os: DeviceOS                  // iOS, iPadOS, macOS, watchOS, tvOS, visionOS
    let screenWidth: CGFloat          // Points
    let screenHeight: CGFloat         // Points
    let scaleFactor: Int              // 1, 2, or 3
    let safeAreaTop: CGFloat          // Points
    let safeAreaBottom: CGFloat       // Points
    let safeAreaLeft: CGFloat         // Points
    let safeAreaRight: CGFloat        // Points
}

protocol Element: Codable, Identifiable {
    var id: UUID { get }
    var name: String { get set }
    var x: CGFloat { get set }
    var y: CGFloat { get set }
    var rotation: CGFloat { get set }
    var opacity: CGFloat { get set }
    var locked: Bool { get set }
    var visible: Bool { get set }
}

struct RectangleElement: Element { /* §5.2.2 */ }
struct TextElement: Element { /* §5.2.3 */ }
struct LineElement: Element { /* §5.2.4 */ }
struct EllipseElement: Element { /* §5.2.5 */ }
struct GroupElement: Element { /* §5.2.6 */ }
```

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| All 30+ devices defined with exact values from §3.1 | Unit test comparing to spec |
| Document can be created with default device (iPhone 16 Pro) | Unit test |
| Document can be saved to `.specframe` file | Unit test |
| Saved file is valid ZIP with correct structure | Unit test + manual inspection |
| Document can be opened from `.specframe` file | Unit test |
| Round-trip save/open preserves all data | Unit test |
| All element types serialize/deserialize correctly | Unit tests per type |
| Autosave triggers without error | Manual verification |
| Device values match specification exactly (spot check 5 devices) | Manual comparison |

### Audit Questions

1. Do all device specifications match §3.1 exactly? (Spot check: iPhone 16 Pro, iPad Pro 13", MacBook Pro 16", Apple Watch Ultra 2, Vision Pro)
2. Do element property defaults match §5.2 exactly?
3. Does the ZIP structure match §9.3 exactly?
4. Does `manifest.json` structure match §9.4 exactly?
5. Does `document.json` structure match §9.5 exactly?
6. Are coordinate values stored with 2 decimal places per §2.6?
7. How many interpretations were required? Are all logged?

---

## Sprint 2: Canvas Foundation

### Purpose
Implement the canvas rendering layer with coordinate system, grid, rulers, and device frame. No elements yet.

### Entry Criteria
- Sprint 1 passed audit
- Document model stable (no pending changes)

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement `CanvasView` (NSView subclass) | §4.1 |
| Implement 5-layer rendering architecture | §4.1 |
| Implement center-origin coordinate system | §2.1, §2.2 |
| Implement coordinate transformation functions | §2.5 |
| Implement grid rendering (major/minor) | §4.2.1 |
| Implement grid visibility by zoom level | §4.2.2 |
| Implement origin crosshair (solid X, dashed Y) | §4.2.1, Appendix A |
| Implement ruler views (top and left) | §4.3 |
| Implement ruler graduations by zoom level | §4.3.2 |
| Implement ruler center-origin values | §4.3.3 |
| Implement device frame outline | §4.1 |
| Implement zoom system (discrete levels only) | §4.4.1 |
| Implement zoom controls (keyboard, mouse wheel) | §4.4.2 |
| Implement zoom behavior (center on cursor/selection/canvas) | §4.4.3 |
| Implement pan and scroll | §4.5 |
| Connect canvas to document model | — |

### Color Implementation

All canvas colors must match Appendix A exactly:

| Element | Required Value |
|---------|---------------|
| Canvas background | `#1E1E1E` |
| Grid major | `#3A3A3A` |
| Grid minor | `#2A2A2A` |
| Origin X-axis | `#888888`, solid |
| Origin Y-axis | `#888888`, dashed (4pt dash, 4pt gap) |
| Device frame | `#FFFFFF`, 1pt stroke |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Canvas displays with dark background (#1E1E1E) | Visual verification |
| Origin crosshair visible at (0,0) | Visual verification |
| X-axis is solid grey, Y-axis is dashed grey | Visual verification |
| Grid major lines at 50pt intervals | Measurement |
| Grid minor lines at 10pt intervals | Measurement |
| Grid visibility changes correctly across zoom levels | Test at 10%, 25%, 50%, 100%, 200% |
| Rulers show center-origin values (negative left/below center) | Visual verification |
| Ruler graduations change appropriately with zoom | Test at each zoom range |
| All 14 discrete zoom levels accessible | Keyboard/menu test |
| Zoom centers on cursor when using mouse wheel | Visual verification |
| Zoom centers on canvas center when using keyboard | Visual verification |
| Pan works via Space+drag, middle mouse, trackpad | Input test |
| Device frame matches selected device dimensions | Measurement against §3.1 |

### Audit Questions

1. Is the origin exactly at canvas center?
2. Do coordinates increase rightward (+X) and upward (+Y) per §2.2?
3. Are all colors exactly as specified in Appendix A?
4. Is the Y-axis dashed and X-axis solid?
5. Are zoom levels exactly the 14 discrete values from §4.4.1?
6. At 100% zoom with iPhone 16 Pro, does the device frame measure exactly 402×874 points?
7. Do rulers display `0` at the exact center of the device?
8. How many interpretations were required?

---

## Sprint 3: Element Rendering

### Purpose
Implement element rendering on canvas. Elements from the document model appear visually. No interaction yet.

### Entry Criteria
- Sprint 2 passed audit
- Canvas coordinate system verified accurate

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement Rectangle rendering | §5.2.2 |
| Implement Rectangle corner radius (including asymmetric) | §5.2.2 |
| Implement Ellipse rendering | §5.2.5 |
| Implement Line rendering | §5.2.4 |
| Implement Line stroke styles (solid, dashed, dotted) | §5.2.4 |
| Implement Text rendering | §5.2.3 |
| Implement Text properties (font, size, weight, alignment) | §5.2.3 |
| Implement Group rendering (recursive) | §5.2.6 |
| Implement Fill: None | §5.3 |
| Implement Fill: Solid | §5.3 |
| Implement Fill: Pattern (all 8 patterns) | §5.5.1 |
| Implement Stroke rendering | §5.4 |
| Implement Stroke positions (inside, center, outside) | §5.4 |
| Implement element opacity | §5.2.1 |
| Implement element rotation | §5.2.1 |
| Implement element visibility toggle | §5.2.1 |
| Implement Z-ordering (layer order) | §6.7.4 |

### Pattern Rendering Requirements

Each pattern must render correctly at all zoom levels:

| Pattern ID | Rendering Specification |
|------------|------------------------|
| `hlines` | Horizontal lines, 8pt spacing, 1pt stroke |
| `vlines` | Vertical lines, 8pt spacing, 1pt stroke |
| `dlines-45` | 45° diagonal lines, 8pt spacing, 1pt stroke |
| `dlines-135` | 135° diagonal lines, 8pt spacing, 1pt stroke |
| `crosshatch` | Horizontal + vertical, 8pt spacing, 1pt stroke |
| `crosshatch-45` | 45° + 135° diagonal, 8pt spacing, 1pt stroke |
| `dots` | Dot grid, 8pt spacing, 1pt radius |
| `image-placeholder` | × from corner to corner |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Rectangle renders at correct position (center-origin) | Create at (0,0), verify centered |
| Rectangle with corner radius renders correctly | Test symmetric and asymmetric |
| Ellipse renders at correct position and size | Create at (0,0), verify centered |
| Line renders from start to end point | Create horizontal, vertical, diagonal |
| Line stroke styles render correctly | Test solid, dashed, dotted |
| Text renders with correct font properties | Test each font weight |
| Text alignment (leading, center, trailing) works | Visual verification |
| All 8 patterns render correctly | Visual verification per pattern |
| Patterns tile seamlessly at edges | Visual verification |
| Patterns remain consistent across zoom levels | Test at 50%, 100%, 200% |
| Stroke inside/center/outside positions correct | Visual comparison |
| Opacity reduces element visibility | Test at 0.5, 0.25 |
| Rotation transforms around element center | Test at 45°, 90° |
| Hidden elements do not render | Toggle visibility |
| Z-order respected (later elements on top) | Overlap test |

### Audit Questions

1. Does an element at (0, 0) appear at the exact canvas center?
2. Does an element at (100, 50) appear right and up from center?
3. Do all 8 patterns match their descriptions in §5.5.1?
4. Do diagonal patterns tile without visible seams?
5. Does stroke position "inside" keep stroke within element bounds?
6. Is rotation around element center, not top-left?
7. Do default element styles match Appendix C exactly?
8. How many interpretations were required?

---

## Sprint 4: Window Layout & Panels

### Purpose
Implement the three-panel window structure: Specification Panel (left), Canvas (center), Inspector Panel (right).

### Entry Criteria
- Sprint 3 passed audit
- Element rendering verified accurate

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement three-panel split view | §10.1 |
| Set panel widths (320pt left, 260pt right) | §7.1, §6.6.1 |
| Implement minimum window size (960×600) | §10.2 |
| Implement panel collapse/expand | §10.3 |
| Implement panel toggle shortcuts | §10.3 |
| Implement Specification Panel structure | §7.2 |
| Implement Specification Panel document section | §7.2 |
| Implement Specification Panel selection section | §7.2 |
| Implement Specification Panel code preview | §7.2 |
| Implement Inspector Panel structure | §6.6.2 |
| Implement Inspector Transform section | §6.6.2 |
| Implement Inspector Fill section | §6.6.2 |
| Implement Inspector Stroke section | §6.6.2 |
| Implement Inspector Text section (conditional) | §6.6.2 |
| Implement Status Bar | §10.5 |
| Implement Toolbar | §10.4 |
| Implement Device Selector in toolbar | §10.4 |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Window cannot be resized below 960×600 | Drag resize test |
| Specification Panel is 320pt wide | Measurement |
| Inspector Panel is 260pt wide | Measurement |
| Cmd+Option+S toggles Specification Panel | Keyboard test |
| Cmd+Option+I toggles Inspector Panel | Keyboard test |
| Collapsed panels are 0pt width | Visual verification |
| Status bar shows zoom level | Visual verification |
| Status bar shows cursor position in center-origin | Move cursor, verify coordinates |
| Status bar shows selection name | Select element, verify |
| Status bar shows specification status shape (●/○/×) | Visual verification |
| Toolbar contains all items from §10.4 | Visual inspection |
| Device selector shows all devices | Click and inspect |
| Changing device updates canvas dimensions | Select different device |

### Audit Questions

1. Are panel widths exactly 320pt and 260pt?
2. Does the status bar cursor position show center-origin coordinates?
3. Does (0, 0) display when cursor is at canvas center?
4. Is the specification status indicator a shape (●/○/×) not a color?
5. Are all toolbar items present and in correct order?
6. Do panel toggle shortcuts match §10.3?
7. How many interpretations were required?

---

## Sprint 5: Interaction – Selection & Manipulation

### Purpose
Implement user interaction: selection, movement, resizing, rotation, and snapping.

### Entry Criteria
- Sprint 4 passed audit
- Window layout stable

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement click selection | §6.3.1 |
| Implement shift-click add to selection | §6.3.1 |
| Implement cmd-click toggle selection | §6.3.1 |
| Implement marquee selection (left-to-right contains) | §6.3.1 |
| Implement marquee selection (right-to-left intersects) | §6.3.1 |
| Implement select all (Cmd+A) | §6.3.1 |
| Implement deselect (Escape) | §6.3.1 |
| Implement selection appearance (white outline, handles) | §6.3.2 |
| Implement hover appearance (white dashed) | §6.3.2 |
| Implement move via drag | §6.4.1 |
| Implement constrained move (Shift+drag) | §6.4.1 |
| Implement nudge (arrow keys, 1pt) | §6.4.1 |
| Implement nudge (Shift+arrow, 10pt) | §6.4.1 |
| Implement resize via handles | §6.4.2 |
| Implement proportional resize (Shift+drag) | §6.4.2 |
| Implement resize from center (Option+drag) | §6.4.2 |
| Implement rotation (Cmd+drag) | §6.4.3 |
| Implement rotation snapping (Shift+Cmd+drag, 15°) | §6.4.3 |
| Implement grid snap | §4.2.3, §6.5.1 |
| Implement edge snap | §6.5.1 |
| Implement center snap | §6.5.1 |
| Implement snap feedback (white guides) | §6.5.4 |
| Implement snap tolerance (8 screen pixels) | §6.5.2 |
| Implement snap priority order | §6.5.3 |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Click selects single element | Interaction test |
| Shift+click adds to selection | Interaction test |
| Cmd+click toggles selection | Interaction test |
| Left-to-right marquee selects contained only | Interaction test |
| Right-to-left marquee selects intersecting | Interaction test |
| Escape deselects all | Interaction test |
| Selection shows white 2pt outline | Visual verification |
| Selection handles are 8×8pt white squares with black stroke | Visual verification |
| Hover shows white 1pt dashed outline | Visual verification |
| Drag moves element | Interaction test |
| Shift+drag constrains to H/V | Interaction test |
| Arrow keys nudge 1pt | Position verification before/after |
| Shift+arrow nudges 10pt | Position verification before/after |
| Corner handles resize element | Interaction test |
| Shift+drag maintains aspect ratio | Measurement before/after |
| Option+drag resizes from center | Position verification |
| Cmd+drag outside bounds rotates | Interaction test |
| Shift+Cmd+drag snaps to 15° increments | Rotation value verification |
| Snap guides appear as white lines | Visual verification |
| Snap activates within 8 screen pixels | Measurement |
| Edge snap takes priority over grid snap | Behavior verification |

### Audit Questions

1. Is selection outline exactly 2pt and `#FFFFFF`?
2. Are selection handles exactly 8×8pt?
3. Is hover outline dashed with 4pt dash, 4pt gap?
4. Does nudge move exactly 1pt/10pt (not approximate)?
5. Does 15° rotation snapping produce exact multiples of 15?
6. Are snap guides `#FFFFFF` per Appendix A?
7. Does snap tolerance remain 8 screen pixels regardless of zoom?
8. How many interpretations were required?

---

## Sprint 6: Interaction – Element Creation

### Purpose
Implement element creation via toolbar tools and keyboard shortcuts.

### Entry Criteria
- Sprint 5 passed audit
- Selection and manipulation stable

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement Selection Tool | §10.4 |
| Implement Rectangle Tool (click to place) | §6.2.1 |
| Implement Rectangle Tool (drag to size) | §6.2.1 |
| Implement Text Tool | §6.2.1 |
| Implement Line Tool | §6.2.1 |
| Implement Ellipse Tool | §6.2.1 |
| Implement keyboard shortcuts (R, T, L, O) | §6.2.2 |
| Implement default sizes per element type | §6.2.3 |
| Implement Group (Cmd+G) | §6.2.2 |
| Implement Ungroup (Cmd+Shift+G) | §6.2.2 |
| Implement Delete (Backspace/Delete) | §6.7.2 |
| Implement Duplicate (Cmd+D) | §6.7.2 |
| Implement Copy/Cut/Paste | §6.7.2 |
| Implement Paste in Place (Cmd+Shift+V) | §6.7.2 |
| Implement Z-order commands | §6.7.4 |
| Implement Lock (Cmd+L) | §6.7.4 |
| Implement Hide (Cmd+H) | §6.7.4 |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Pressing R activates Rectangle tool | Keyboard test |
| Clicking canvas with Rectangle tool creates 100×100 rect at click point | Creation + measurement |
| Dragging with Rectangle tool creates rect matching drag bounds | Creation + measurement |
| Created rectangle has default styles from Appendix C | Property inspection |
| Pressing T activates Text tool and creates text element | Keyboard + creation test |
| Created text has default "Label" content | Property inspection |
| Cmd+G groups selected elements | Grouping test |
| Cmd+Shift+G ungroups | Ungrouping test |
| Delete removes selected elements | Deletion test |
| Cmd+D duplicates with offset | Duplication test |
| Cmd+C/Cmd+V copies and pastes | Clipboard test |
| Cmd+Shift+V pastes at original position | Position verification |
| Bring to Front/Back commands work | Z-order test |
| Cmd+L locks element (cannot select/move) | Lock test |
| Locked elements show lock indicator | Visual verification |

### Audit Questions

1. Do keyboard shortcuts exactly match §6.2.2?
2. Do default element sizes exactly match §6.2.3?
3. Do default element styles exactly match Appendix C?
4. Does Cmd+H hide elements (not minimize app)? (Note: potential macOS conflict)
5. Is paste offset consistent and reasonable?
6. How many interpretations were required?

---

## Sprint 7: Inspector – Numeric Input

### Purpose
Implement the Inspector panel's numeric input system with scrubbing, expressions, and Tab navigation.

### Entry Criteria
- Sprint 6 passed audit
- Element creation stable

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement numeric text fields for X, Y, W, H, Rotation | §6.6.2 |
| Implement Tab navigation between fields | §6.6.3 |
| Implement direct value entry | §6.6.3 |
| Implement arrow key increment (±1) | §6.6.3 |
| Implement Shift+arrow increment (±10) | §6.6.3 |
| Implement Option+arrow increment (±0.1) | §6.6.3 |
| Implement scrubbing on field labels | §6.6.3 |
| Implement Shift+scrub (10× coarse) | §6.6.3 |
| Implement Option+scrub (0.1× fine) | §6.6.3 |
| Implement expression evaluation (+, -, *, /) | §6.6.4 |
| Implement percentage expressions | §6.6.4 |
| Implement mixed expressions | §6.6.4 |
| Implement color picker for fill/stroke | §6.6.2 |
| Implement pattern selector | §6.6.2 |
| Implement corner radius fields (4 values) | §5.2.2 |
| Implement stroke width, style, position fields | §5.4 |
| Implement text properties (font, size, weight, alignment, color) | §5.2.3 |
| Bind inspector fields to selected element | — |
| Update element on field change | — |
| Update fields on element change | — |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Selecting element populates inspector fields | Selection test |
| Typing value and pressing Enter updates element | Input test |
| Tab moves focus to next field | Keyboard test |
| Up arrow increments by 1 | Value verification |
| Shift+Up increments by 10 | Value verification |
| Option+Up increments by 0.1 | Value verification |
| Dragging on label scrubs value | Interaction test |
| Shift+scrub moves 10× faster | Rate verification |
| Option+scrub moves 0.1× slower | Rate verification |
| `100+50` evaluates to `150` | Expression test |
| `50%` evaluates to half of current value | Expression test |
| `50%+10` evaluates correctly | Expression test |
| Color picker updates fill/stroke | Color selection test |
| Pattern selector shows all 8 patterns | Visual verification |
| Inspector updates when element is manipulated on canvas | Drag element, watch inspector |

### Audit Questions

1. Do increment values exactly match §6.6.3 (1, 10, 0.1)?
2. Do scrub ratios exactly match §6.6.3 (1×, 10×, 0.1×)?
3. Are all expression operators from §6.6.4 supported?
4. Does percentage calculate against current value (not some other reference)?
5. Are expressions evaluated and discarded (not stored)?
6. How many interpretations were required?

---

## Sprint 8: Specification Panel & Validation

### Purpose
Implement the live specification panel and document validation system.

### Entry Criteria
- Sprint 7 passed audit
- Inspector panel stable

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement document section (device, screen, safe area, element count) | §7.2 |
| Implement selection section (type, position, size, fill, stroke, etc.) | §7.2 |
| Implement code preview section | §7.2 |
| Implement Copy button for code preview | §7.2 |
| Implement completeness indicator (●/○/×) | §7.3 |
| Implement validation: unnamed element | §7.4 |
| Implement validation: off-screen element | §7.4 |
| Implement validation: zero dimension | §7.4 |
| Implement validation: overlapping siblings | §7.4 |
| Update specification panel in real-time | — |
| Generate SwiftUI code preview for selected element | §8.3 |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Document section shows correct device name | Visual verification |
| Document section shows correct screen dimensions | Comparison to §3.1 |
| Document section shows correct safe area values | Comparison to §3.1 |
| Document section shows correct element count | Count verification |
| Selection section updates when selection changes | Selection test |
| Selection section shows all relevant properties | Visual verification |
| Code preview shows valid SwiftUI | Copy and compile test |
| Code preview coordinates are SwiftUI top-left origin | Value verification |
| Copy button copies code to clipboard | Paste test |
| ● shows when all elements fully specified | State test |
| ○ shows when element has default name | Create element, check |
| × shows when element has zero dimension | Set width to 0, check |
| Validation warnings appear in panel | Visual verification |

### Audit Questions

1. Is the completeness indicator shape-based (●/○/×) not color-based?
2. Does code preview use correct coordinate transformation per §8.3.2?
3. Are SwiftUI coordinates calculated as `specframe_x + (screenWidth/2)` and `(screenHeight/2) - specframe_y`?
4. Does validation trigger on the exact conditions in §7.4?
5. How many interpretations were required?

---

## Sprint 9: Export Pipeline

### Purpose
Implement all export formats: JSON specification, SwiftUI code, PNG, SVG.

### Entry Criteria
- Sprint 8 passed audit
- Specification panel stable

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement Export menu | §6.7.1 |
| Implement JSON specification export | §8.2 |
| Implement JSON schema compliance | §8.2 |
| Implement SwiftUI code export | §8.3 |
| Implement SwiftUI coordinate transformation | §8.3.2 |
| Implement SwiftUI Color extension generation | §8.3.1 |
| Implement SwiftUI Preview generation | §8.3.1 |
| Implement PNG export | §8.4 |
| Implement PNG scale presets (@1x, @2x, @3x, 300dpi, 600dpi) | §8.4.1 |
| Implement PNG background options | §8.4.2 |
| Implement PNG color profile options | §8.4.2 |
| Implement SVG export | §8.5 |
| Implement SVG pattern definitions | §8.5.1 |
| Implement SVG coordinate transformation | §8.5.2 |
| Implement SVG precision (2 decimal places) | §8.5.3 |
| Implement Markdown specification export | §8.1 |
| Implement PDF specification export | §8.1 |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Cmd+E opens export dialog | Keyboard test |
| JSON export produces valid JSON | JSON validator |
| JSON structure matches §8.2 schema | Schema comparison |
| SwiftUI export compiles in Xcode | Compilation test |
| SwiftUI positions match specification | Value comparison |
| PNG @1x dimensions match document points | Image measurement |
| PNG @2x dimensions are 2× document points | Image measurement |
| PNG @3x dimensions are 3× document points | Image measurement |
| PNG 300dpi has correct pixel density | Metadata inspection |
| PNG transparency works when selected | Visual verification |
| SVG is valid XML | XML validator |
| SVG viewBox matches document dimensions | Attribute inspection |
| SVG coordinates have max 2 decimal places | Text inspection |
| SVG patterns tile correctly | Visual verification |

### Audit Questions

1. Does JSON export include all fields from §8.2 schema?
2. Does SwiftUI code transformation exactly match formulas in §8.3.2?
3. Do PNG scale factors produce exact pixel multiples?
4. Does SVG coordinate transformation match formula in §8.5.2?
5. Are SVG coordinates truncated/rounded to exactly 2 decimal places?
6. How many interpretations were required?

---

## Sprint 10: Polish & App Store Preparation

### Purpose
Final refinements, accessibility implementation, and App Store submission preparation.

### Entry Criteria
- Sprint 9 passed audit
- All core features complete

### Scope

| Task | Specification Reference |
|------|------------------------|
| Implement Undo/Redo with correct granularity | §11.3 |
| Implement VoiceOver labels for all controls | §11.5 |
| Implement keyboard navigation | §11.5 |
| Implement Reduce Motion support | §11.5 |
| Implement Increase Contrast support | §11.5 |
| Performance optimization (60fps target) | §11.4 |
| Test with 500 elements | §11.4 |
| Implement document preview generation | §9.3 |
| Implement Finder thumbnail generation | §9.3 |
| Create app icon (all sizes) | App Store requirement |
| Create screenshots | App Store requirement |
| Write App Store description | App Store requirement |
| Final audit of all keyboard shortcuts | §6.7 |
| Final audit of all colors | Appendix A |
| Final audit of all typography | Appendix B |

### Exit Criteria

| Criterion | Verification Method |
|-----------|-------------------|
| Undo reverses single actions per §11.3 | Interaction test |
| Redo restores undone actions | Interaction test |
| All controls have VoiceOver labels | Accessibility audit |
| Full keyboard navigation possible | Keyboard-only test |
| Reduce Motion disables snap animations | System setting test |
| Increase Contrast thickens selection outlines | System setting test |
| Canvas maintains 60fps during pan/zoom | Performance profiling |
| 500 elements render without lag | Stress test |
| Document opens in < 500ms | Timing measurement |
| PNG export completes in < 2s | Timing measurement |
| Finder shows document thumbnail | Finder inspection |
| Quick Look shows document preview | Quick Look test |
| App passes App Store validation | Xcode organizer |

### Audit Questions

1. Does undo granularity exactly match §11.3?
2. Are all performance targets from §11.4 met?
3. Do accessibility features match §11.5?
4. Are all keyboard shortcuts from §6.7 implemented and working?
5. Have all colors been verified against Appendix A?
6. Have all typography specs been verified against Appendix B?
7. What is the total interpretation count across all sprints?
8. What patterns emerge in the Interpretation Register?

---

# Audit Protocol

## Per-Sprint Audit Process

### 1. Documentation Review

Before examining code:

1. Read ENGINEERING_LOG.md for the sprint
2. Read INTERPRETATION_REGISTER.md for new entries
3. Count interpretations and categorize by type
4. Note any unresolved questions

### 2. Specification Compliance Check

For each scope item:

1. Locate relevant code
2. Compare implementation to specification section
3. Document any deviations
4. Classify deviation as: Bug | Interpretation | Enhancement | Conflict

### 3. Exit Criteria Verification

Execute each verification method:

1. Record pass/fail
2. For failures, document the gap
3. Determine if failure is blocking

### 4. UX Sampling

Human tester (George) performs:

1. Execute primary workflows for sprint scope
2. Note friction points
3. Note expectation mismatches
4. Rate confidence in implementation (1-5)

### 5. Diff Analysis

Compare:
- Specification text → Implementation behavior
- Expected output → Actual output
- Intended interaction → Actual interaction

Document:
- Where language was insufficient
- Where specification was ambiguous
- Where implementation improved on specification
- Recommendations for specification revision

### 6. Audit Decision

| Outcome | Criteria | Next Step |
|---------|----------|-----------|
| **Pass** | All exit criteria met, interpretations acceptable | Proceed to next sprint |
| **Pass with Notes** | Exit criteria met, interpretations logged for spec revision | Proceed, update spec backlog |
| **Fail – Rework** | Exit criteria not met, issues are implementation errors | Rework within sprint |
| **Fail – Spec Gap** | Exit criteria not met, specification is insufficient | Halt, revise specification |

---

# Interpretation Classification

## Categories

| Category | Definition | Example |
|----------|------------|---------|
| **Gap** | Specification does not address this case | "Behavior when dragging outside window bounds" |
| **Ambiguity** | Specification language permits multiple interpretations | "'Approximately' 8 pixels" vs "Exactly 8 pixels" |
| **Conflict** | Specification contradicts itself | §A says X, §B says not-X |
| **Implicit** | Specification assumes knowledge not stated | "Standard macOS behavior" |
| **Technical** | Implementation reality prevents exact compliance | "CGFloat precision limits" |

## Severity

| Severity | Definition |
|----------|------------|
| **Critical** | Different interpretation would produce fundamentally different product |
| **Major** | Interpretation affects user-visible behavior significantly |
| **Minor** | Interpretation affects details unlikely to be noticed |
| **Trivial** | Interpretation affects only internal implementation |

---

# Success Metrics

## Quantitative

| Metric | Target | Measurement |
|--------|--------|-------------|
| Total Interpretations | < 50 across all sprints | Count from registers |
| Critical Interpretations | 0 | Count from registers |
| Specification Revisions Required | < 10 | Count of spec changes |
| Audit Pass Rate (first attempt) | > 80% | Pass/total sprints |
| Exit Criteria Pass Rate | > 95% | Pass/total criteria |

## Qualitative

| Metric | Target | Measurement |
|--------|--------|-------------|
| Code-to-Spec Traceability | Every line traceable | IMPLEMENTATION_RECORD coverage |
| Decision Documentation | Every decision logged | ENGINEERING_LOG completeness |
| UX Confidence | ≥ 4/5 per sprint | Human tester rating |

---

# Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-15 | SpecFrame Team | Initial blueprint |

---

**END OF BLUEPRINT**
