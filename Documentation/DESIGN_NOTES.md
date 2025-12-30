# Design Notes — SpecFrame

This document contains architectural decisions and patterns employed in the implementation.

---

## Sprint 0: Project Scaffold

### Project Architecture

**Purpose:** Establish the foundational structure for a document-based macOS application using AppKit.
**Pattern:** Model-View-Controller (MVC) via NSDocument architecture
**Specification Alignment:** §1.4 (AppKit framework), §10.1 (Window structure), §9.6 (NSDocument autosave)
**Deviations:** None

---

### Application Entry Point

**Purpose:** Define the application lifecycle entry point.
**Pattern:** NSApplicationDelegate with @main attribute
**Dependencies:** Cocoa framework
**Dependents:** All application-level functionality
**Specification Alignment:** §1.4 (AppKit framework requirement)
**Deviations:** None

---

### Document Architecture

**Purpose:** Define the document model and window management.
**Pattern:** NSDocument subclass (SpecFrameDocument)
**Dependencies:** Cocoa framework
**Dependents:** All document-related functionality (save, open, window management)
**Specification Alignment:**
- §9.1 (File extension: .specframe)
- §9.2 (UTType: com.adfinium.specframe.document)
- §9.6 (Autosave enabled, system-managed)
- §10.1 (Window structure)
- §10.2 (Minimum window size: 960×600)
**Deviations:** None

---

### Folder Organization

**Purpose:** Organize source code by architectural responsibility.
**Pattern:** Feature-based folder structure

| Folder | Purpose | Sprint |
|--------|---------|--------|
| App/ | Application lifecycle (AppDelegate) | Sprint 0 |
| Document/ | NSDocument subclass and document management | Sprint 0+ |
| Model/ | Data models (Device, Element, Fill, Stroke, etc.) | Sprint 1 |
| Views/Canvas/ | Canvas rendering (CanvasView) | Sprint 2 |
| Views/Inspector/ | Inspector panel UI | Sprint 4 |
| Views/Specification/ | Specification panel UI | Sprint 4 |
| Views/Toolbar/ | Toolbar configuration | Sprint 4 |
| Export/ | Export pipeline (JSON, SwiftUI, PNG, SVG) | Sprint 9 |
| Utilities/ | Shared utilities and extensions | As needed |
| Resources/ | Assets, localization | As needed |

**Specification Alignment:** §10.1 (Application architecture), Implementation Blueprint folder structure
**Deviations:** None

---

### Security Configuration

**Purpose:** Configure application security for Mac App Store distribution.
**Pattern:** Entitlements-based sandboxing with Hardened Runtime

| Setting | Value | Purpose |
|---------|-------|---------|
| App Sandbox | Enabled | §1.4 requirement |
| Hardened Runtime | Enabled | §1.4 requirement |
| User-Selected Files | Read-Write | Document open/save |

**Specification Alignment:** §1.4 (Sandbox Required, Hardened Runtime Required)
**Deviations:** None

---
