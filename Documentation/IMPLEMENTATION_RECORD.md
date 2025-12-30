# Implementation Record — SpecFrame

This document provides line-level traceability from code to specification.

---

## Sprint 0: Project Scaffold

### SpecFrame/App/AppDelegate.swift

| Lines | Specification Reference | Notes |
|-------|------------------------|-------|
| 1-7 | — | File header |
| 8 | §1.4 | Import Cocoa for AppKit framework |
| 10-11 | §1.4, Sprint 0 Task #1 | @main entry point with NSApplicationDelegate |
| 13-15 | — | Application launch callback (placeholder) |
| 17-19 | — | Application termination callback (placeholder) |
| 21-23 | — | Secure restorable state support |
| 25-27 | §9.6 | Return true to open untitled document on launch |

### SpecFrame/Document/SpecFrameDocument.swift

| Lines | Specification Reference | Notes |
|-------|------------------------|-------|
| 1-7 | — | File header |
| 8 | §1.4 | Import Cocoa for AppKit framework |
| 10 | §9.6 | NSDocument subclass |
| 12-14 | — | Default initializer |
| 16-18 | §9.6 | autosavesInPlace = true per spec |
| 20-31 | §10.2 | Window creation with 960×600 min size |
| 33-38 | — | Placeholder for document save (Sprint 1) |
| 40-45 | — | Placeholder for document read (Sprint 1) |

### SpecFrame/Info.plist

| Lines | Specification Reference | Notes |
|-------|------------------------|-------|
| 1-5 | — | XML plist header |
| 6-19 | §9.2, Sprint 0 Instructions | CFBundleDocumentTypes declaration |
| 20-40 | §9.2, Sprint 0 Instructions | UTExportedTypeDeclarations |
| 41-42 | §1.4 | NSPrincipalClass for AppKit app |

### SpecFrame/SpecFrame.entitlements

| Lines | Specification Reference | Notes |
|-------|------------------------|-------|
| 1-5 | — | XML plist header |
| 6-7 | §1.4 | App Sandbox enabled |
| 8-9 | §1.4 (interpreted) | Read-write access for document handling |

### project.pbxproj (Build Settings)

| Setting | Value | Specification Reference |
|---------|-------|------------------------|
| MACOSX_DEPLOYMENT_TARGET | 14.0 | §1.4 |
| PRODUCT_BUNDLE_IDENTIFIER | com.adfinium.specframe | §9.2 |
| ENABLE_APP_SANDBOX | YES | §1.4 |
| ENABLE_HARDENED_RUNTIME | YES | §1.4 |
| INFOPLIST_FILE | SpecFrame/Info.plist | §9.2 |
| CODE_SIGN_ENTITLEMENTS | SpecFrame/SpecFrame.entitlements | §1.4 |

---
