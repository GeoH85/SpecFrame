# Test Manifest — SpecFrame

This document tracks verification coverage.

---

## Sprint 0: Project Scaffold

| Test ID | Description | Specification Reference | Status |
|---------|-------------|------------------------|--------|
| S0-001 | Project builds without error | §1.4 | Pass |
| S0-002 | App launches to empty window | §10.1 | Pending |
| S0-003 | File > New creates untitled document | §10.1 | Pending |
| S0-004 | UTType `com.adfinium.specframe.document` declared in Info.plist | §9.2 | Pass |
| S0-005 | Document type associates with `.specframe` extension | §9.2 | Pass |
| S0-006 | App Sandbox entitlement present | §1.4 | Pass |
| S0-007 | Hardened Runtime enabled | §1.4 | Pass |
| S0-008 | Deployment target is exactly macOS 14.0 | §1.4 | Pass |
| S0-009 | Bundle identifier is exactly `com.adfinium.specframe` | §9.2 | Pass |
| S0-010 | All five documentation files exist with correct headers | Blueprint | Pass |
| S0-011 | ENGINEERING_LOG.md contains at least one decision entry | Blueprint | Pass |
| S0-012 | Minimum window size is 960×600 | §10.2 | Pending |
| S0-013 | autosavesInPlace returns true | §9.6 | Pass |

---

### Verification Notes

**S0-004:** Verified by inspecting SpecFrame/Info.plist — UTExportedTypeDeclarations contains `com.adfinium.specframe.document`.

**S0-005:** Verified by inspecting SpecFrame/Info.plist — UTTypeTagSpecification/public.filename-extension contains `specframe`.

**S0-006:** Verified by inspecting SpecFrame/SpecFrame.entitlements — `com.apple.security.app-sandbox` is `true`.

**S0-007:** Verified by inspecting project.pbxproj — ENABLE_HARDENED_RUNTIME is YES.

**S0-008:** Verified by inspecting project.pbxproj — MACOSX_DEPLOYMENT_TARGET is 14.0.

**S0-009:** Verified by inspecting project.pbxproj — PRODUCT_BUNDLE_IDENTIFIER is `com.adfinium.specframe`.

**S0-010:** Verified — All five files created:
- ENGINEERING_LOG.md ✓
- DESIGN_NOTES.md ✓
- IMPLEMENTATION_RECORD.md ✓
- INTERPRETATION_REGISTER.md ✓
- TEST_MANIFEST.md ✓

**S0-011:** Verified — ENGINEERING_LOG.md contains 7 decision entries for Sprint 0.

**S0-013:** Verified by inspecting SpecFrameDocument.swift:16-18 — `autosavesInPlace` returns `true`.

---

### Pending Tests (Require Build/Run)

- S0-002: Launch app and verify window appears
- S0-003: Select File > New and verify new document window
- S0-012: Attempt to resize window below 960×600 and verify constraint

**S0-001:** Verified — `xcodebuild -project SpecFrame.xcodeproj -scheme SpecFrame build` completed with `BUILD SUCCEEDED` (2024-12-30).

---
