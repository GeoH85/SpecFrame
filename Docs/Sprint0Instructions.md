# Sprint 0: Project Scaffold
## Instruction Package for Codey

---

# Mission

Establish the Xcode project structure, build configuration, and documentation framework for SpecFrame. This sprint produces no functional code — only the foundation upon which all subsequent sprints build.

---

# Reference Documents

You are operating under two governing documents:

1. **SpecFrame Technical Specification v1.0.0** — The complete product definition
2. **SpecFrame Implementation Blueprint v1.0.0** — The build sequence and audit framework

These documents are the authority. When in doubt, consult them. When they are silent, log an interpretation.

---

# Scope

Execute exactly these tasks:

| # | Task | Specification Reference |
|---|------|------------------------|
| 1 | Create Xcode project using Document-based App template (AppKit, not SwiftUI app lifecycle) | §1.4, §10.1 |
| 2 | Configure bundle identifier: `com.adfinium.specframe` | §9.2 |
| 3 | Configure product name: `SpecFrame` | — |
| 4 | Set deployment target: macOS 14.0 | §1.4 |
| 5 | Configure UTType for `.specframe` documents: `com.adfinium.specframe.document` | §9.2 |
| 6 | Add UTType declaration to Info.plist with correct conforms-to types | §9.2 |
| 7 | Configure App Sandbox entitlement (enabled) | §1.4 |
| 8 | Configure Hardened Runtime (enabled) | §1.4 |
| 9 | Create folder structure per deliverables section below | Blueprint |
| 10 | Initialize all five documentation files with correct headers | Blueprint |
| 11 | Create README.md with project overview | — |
| 12 | Commit to GitHub with meaningful commit message | — |

---

# Deliverables

## Folder Structure

```
SpecFrame/
├── SpecFrame.xcodeproj/
├── SpecFrame/
│   ├── App/
│   │   ├── AppDelegate.swift
│   │   └── main.swift (if needed)
│   ├── Document/
│   │   └── SpecFrameDocument.swift
│   ├── Model/
│   │   └── (empty, placeholder for Sprint 1)
│   ├── Views/
│   │   ├── Canvas/
│   │   │   └── (empty, placeholder for Sprint 2)
│   │   ├── Inspector/
│   │   │   └── (empty, placeholder for Sprint 4)
│   │   ├── Specification/
│   │   │   └── (empty, placeholder for Sprint 4)
│   │   └── Toolbar/
│   │       └── (empty, placeholder for Sprint 4)
│   ├── Export/
│   │   └── (empty, placeholder for Sprint 9)
│   ├── Utilities/
│   │   └── (empty, for shared utilities)
│   ├── Resources/
│   │   └── Assets.xcassets/
│   └── Info.plist
├── SpecFrameTests/
│   └── (test target)
├── Documentation/
│   ├── ENGINEERING_LOG.md
│   ├── DESIGN_NOTES.md
│   ├── IMPLEMENTATION_RECORD.md
│   ├── INTERPRETATION_REGISTER.md
│   └── TEST_MANIFEST.md
└── README.md
```

## Info.plist Requirements

The Info.plist must contain:

### Document Type Declaration
```xml
<key>CFBundleDocumentTypes</key>
<array>
    <dict>
        <key>CFBundleTypeName</key>
        <string>SpecFrame Document</string>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>LSHandlerRank</key>
        <string>Owner</string>
        <key>LSItemContentTypes</key>
        <array>
            <string>com.adfinium.specframe.document</string>
        </array>
        <key>NSDocumentClass</key>
        <string>$(PRODUCT_MODULE_NAME).SpecFrameDocument</string>
    </dict>
</array>
```

### Exported UTType Declaration
```xml
<key>UTExportedTypeDeclarations</key>
<array>
    <dict>
        <key>UTTypeIdentifier</key>
        <string>com.adfinium.specframe.document</string>
        <key>UTTypeConformsTo</key>
        <array>
            <string>public.composite-content</string>
            <string>public.data</string>
        </array>
        <key>UTTypeDescription</key>
        <string>SpecFrame Document</string>
        <key>UTTypeTagSpecification</key>
        <dict>
            <key>public.filename-extension</key>
            <array>
                <string>specframe</string>
            </array>
        </dict>
    </dict>
</array>
```

## Documentation File Templates

### ENGINEERING_LOG.md
```markdown
# Engineering Log — SpecFrame

This document contains a chronological record of all engineering decisions made during implementation.

---

## Sprint 0: Project Scaffold

### [YYYY-MM-DD HH:MM] Decision: [Title]

**Context:** [What prompted this decision]
**Options Considered:** [List alternatives]
**Decision:** [What was chosen]
**Rationale:** [Why]
**Specification Reference:** [§X.X.X or "Not specified"]
**Interpretation Required:** [Yes/No]
**If Yes, Interpretation Detail:** [What was assumed]

---
```

### DESIGN_NOTES.md
```markdown
# Design Notes — SpecFrame

This document contains architectural decisions and patterns employed in the implementation.

---

## Project Architecture

**Purpose:** [Description]
**Pattern:** [Named pattern or "Custom"]
**Specification Alignment:** [How this maps to spec sections]

---
```

### IMPLEMENTATION_RECORD.md
```markdown
# Implementation Record — SpecFrame

This document provides line-level traceability from code to specification.

---

## Sprint 0: Project Scaffold

### SpecFrame/App/AppDelegate.swift

| Lines | Specification Reference | Notes |
|-------|------------------------|-------|
| — | — | — |

### SpecFrame/Document/SpecFrameDocument.swift

| Lines | Specification Reference | Notes |
|-------|------------------------|-------|
| — | — | — |

---
```

### INTERPRETATION_REGISTER.md
```markdown
# Interpretation Register — SpecFrame

This document records every instance where the specification did not fully determine the implementation.

---

## Sprint 0: Project Scaffold

### Interpretation #1

**Location:** [File:Line or Config]
**Specification Gap:** [What was not specified]
**Interpretation Made:** [What was assumed/decided]
**Confidence:** [High/Medium/Low]
**Risk:** [What could break if wrong]
**Recommendation:** [Clarification needed? Y/N]

---
```

### TEST_MANIFEST.md
```markdown
# Test Manifest — SpecFrame

This document tracks verification coverage.

---

## Sprint 0: Project Scaffold

| Test ID | Description | Specification Reference | Status |
|---------|-------------|------------------------|--------|
| S0-001 | Project builds without error | §1.4 | Pending |
| S0-002 | App launches to empty window | §10.1 | Pending |
| S0-003 | UTType registered correctly | §9.2 | Pending |
| S0-004 | Sandbox entitlement present | §1.4 | Pending |
| S0-005 | Hardened runtime enabled | §1.4 | Pending |

---
```

---

# Exit Criteria

Sprint 0 is complete when ALL of the following are true:

| # | Criterion | Verification Method |
|---|-----------|-------------------|
| 1 | Project builds without error | Run `xcodebuild -project SpecFrame.xcodeproj -scheme SpecFrame build` |
| 2 | App launches and displays an empty document window | Manual launch |
| 3 | File > New creates a new untitled document | Manual test |
| 4 | UTType `com.adfinium.specframe.document` is declared in Info.plist | Inspect plist |
| 5 | Document type associates with `.specframe` extension | Inspect plist |
| 6 | App Sandbox entitlement is enabled | Inspect entitlements file |
| 7 | Hardened Runtime is enabled | Inspect build settings |
| 8 | Deployment target is exactly macOS 14.0 | Inspect build settings |
| 9 | Bundle identifier is exactly `com.adfinium.specframe` | Inspect build settings |
| 10 | All five documentation files exist with correct headers | File inspection |
| 11 | ENGINEERING_LOG.md contains at least one decision entry | File inspection |
| 12 | Changes committed to GitHub | `git log` inspection |

---

# Constraints

1. **No functional code** — This sprint creates structure only. The document class should be the default NSDocument subclass with minimal implementation.

2. **No UI customization** — The window should be whatever the template provides. UI comes in Sprint 4.

3. **Document everything** — Every decision, even seemingly obvious ones, gets logged.

4. **Flag interpretations** — If the specification doesn't explicitly state something and you must decide, log it in INTERPRETATION_REGISTER.md.

5. **Commit atomically** — One commit for the complete sprint, with a message following format: `Sprint 0: Project Scaffold - [summary]`

---

# Questions to Answer in Documentation

As you work, document answers to these:

1. Which Xcode template did you select and why?
2. Did you use Swift or SwiftUI app lifecycle? Why?
3. What decisions did the template make that you kept vs. modified?
4. Were there any conflicts between template defaults and specification requirements?
5. What, if anything, was not specified that you had to decide?

---

# Success Looks Like

After Sprint 0:

- A clean Xcode project that builds and runs
- An app that opens to an empty document window
- A file type association ready for `.specframe` files
- A documentation framework ready to capture Sprint 1+ decisions
- Zero ambiguity about what was done and why

---

**Begin when ready. Document as you go. Commit when complete.**
