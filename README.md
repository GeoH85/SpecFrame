# SpecFrame

A specification-first wireframing application for macOS.

## Overview

SpecFrame is a precision tool for creating UI specifications. Unlike traditional design tools that prioritize freeform creativity, SpecFrame treats the specification as the product and the wireframe as its visual representation.

Users input mathematical definitions; the canvas renders those definitions. One source of truth, zero interpretation.

## Key Features

- **Specification-First Design:** Every element has explicit coordinates and dimensions
- **Center-Origin Coordinate System:** Origin (0,0) at screen center for intuitive positioning
- **Device-Accurate Templates:** 30+ Apple device specifications with exact safe areas
- **Multiple Export Formats:** JSON specification, SwiftUI code, PNG, SVG
- **Generated Code:** SwiftUI views that match visual output exactly

## Requirements

- macOS 14.0 Sonoma or later
- Apple Silicon (native) or Intel (supported)

## Project Structure

```
SpecFrame/
├── App/                    # Application lifecycle
├── Document/               # NSDocument subclass
├── Model/                  # Data models (Sprint 1)
├── Views/
│   ├── Canvas/            # Canvas rendering (Sprint 2)
│   ├── Inspector/         # Inspector panel (Sprint 4)
│   ├── Specification/     # Specification panel (Sprint 4)
│   └── Toolbar/           # Toolbar (Sprint 4)
├── Export/                # Export pipeline (Sprint 9)
├── Utilities/             # Shared utilities
└── Resources/             # Assets
```

## Documentation

- [Technical Specification](Docs/TechnicalSpecification.md) — Complete product definition
- [Implementation Blueprint](Docs/ImplementationBlueprint.md) — Build sequence and audit framework
- [Engineering Log](Documentation/ENGINEERING_LOG.md) — Decision record
- [Design Notes](Documentation/DESIGN_NOTES.md) — Architectural patterns
- [Implementation Record](Documentation/IMPLEMENTATION_RECORD.md) — Code traceability
- [Interpretation Register](Documentation/INTERPRETATION_REGISTER.md) — Specification gaps
- [Test Manifest](Documentation/TEST_MANIFEST.md) — Verification coverage

## Current Status

**Sprint 0: Project Scaffold** — Complete

The project foundation is established with:
- AppKit document-based application architecture
- Custom UTType for `.specframe` documents
- App Sandbox and Hardened Runtime enabled
- Documentation framework initialized

## Building

```bash
xcodebuild -project SpecFrame.xcodeproj -scheme SpecFrame build
```

Or open `SpecFrame.xcodeproj` in Xcode 15+ and build.

## License

Copyright © 2024 Adfinium. All rights reserved.
