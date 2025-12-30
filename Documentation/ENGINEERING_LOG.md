# Engineering Log — SpecFrame

This document contains a chronological record of all engineering decisions made during implementation.

---

## Sprint 0: Project Scaffold

### [2024-12-30 20:30] Decision: Project Template Selection

**Context:** Sprint 0 requires creating an Xcode project using "Document-based App template (AppKit, not SwiftUI app lifecycle)" per §1.4 and §10.1.
**Options Considered:**
1. Use Xcode's Document App template with SwiftUI lifecycle
2. Use Xcode's Document App template with AppKit lifecycle
3. Manually create AppKit document-based app from existing SwiftUI project
**Decision:** Option 3 — Manually transform existing SwiftUI project into AppKit document-based app.
**Rationale:** The existing project was created with SwiftUI/SwiftData template. Per specification §1.4, the framework must be AppKit. The project was manually restructured to use NSDocument and NSApplicationDelegate patterns.
**Specification Reference:** §1.4, §10.1
**Interpretation Required:** No
**If Yes, Interpretation Detail:** N/A

---

### [2024-12-30 20:31] Decision: Deployment Target Configuration

**Context:** Specification §1.4 requires macOS 14.0 Sonoma or later.
**Options Considered:**
1. Set exactly macOS 14.0
2. Set to latest macOS version
**Decision:** Set MACOSX_DEPLOYMENT_TARGET to exactly 14.0.
**Rationale:** Specification explicitly states "macOS 14.0 Sonoma or later" — using exactly 14.0 ensures maximum compatibility while meeting requirements.
**Specification Reference:** §1.4
**Interpretation Required:** No
**If Yes, Interpretation Detail:** N/A

---

### [2024-12-30 20:32] Decision: Bundle Identifier Format

**Context:** Specification §9.2 requires bundle identifier `com.adfinium.specframe`.
**Options Considered:** None — specification is explicit.
**Decision:** Set PRODUCT_BUNDLE_IDENTIFIER to `com.adfinium.specframe`.
**Rationale:** Direct compliance with specification.
**Specification Reference:** §9.2
**Interpretation Required:** No
**If Yes, Interpretation Detail:** N/A

---

### [2024-12-30 20:33] Decision: App Lifecycle Architecture

**Context:** Sprint 0 instructions specify "AppKit, not SwiftUI app lifecycle".
**Options Considered:**
1. Use @main with SwiftUI App protocol
2. Use @main with NSApplicationDelegate
**Decision:** Use @main with NSApplicationDelegate (AppDelegate.swift).
**Rationale:** Explicit instruction in Sprint 0 scope, aligns with specification §1.4 requiring AppKit framework.
**Specification Reference:** §1.4, Sprint 0 Instructions Task #1
**Interpretation Required:** No
**If Yes, Interpretation Detail:** N/A

---

### [2024-12-30 20:34] Decision: Minimum Window Size

**Context:** Specification §10.2 defines minimum window size as 960×600 pt.
**Options Considered:** None — specification is explicit.
**Decision:** Set NSWindow.minSize to NSSize(width: 960, height: 600) in SpecFrameDocument.makeWindowControllers().
**Rationale:** Direct compliance with specification.
**Specification Reference:** §10.2
**Interpretation Required:** No
**If Yes, Interpretation Detail:** N/A

---

### [2024-12-30 20:35] Decision: Info.plist vs Generated Info.plist

**Context:** Need to include UTType declarations which require explicit Info.plist entries.
**Options Considered:**
1. Use GENERATE_INFOPLIST_FILE = YES with INFOPLIST_KEY_ settings
2. Use explicit Info.plist file with full control
**Decision:** Use explicit Info.plist file (GENERATE_INFOPLIST_FILE = NO).
**Rationale:** UTExportedTypeDeclarations requires explicit plist structure that cannot be fully expressed via build settings. Sprint 0 Instructions provide exact XML structure to use.
**Specification Reference:** §9.2, Sprint 0 Instructions
**Interpretation Required:** No
**If Yes, Interpretation Detail:** N/A

---

### [2024-12-30 20:36] Decision: Entitlements File Structure

**Context:** Specification §1.4 requires App Sandbox and Hardened Runtime.
**Options Considered:**
1. Use build settings only (ENABLE_APP_SANDBOX, ENABLE_HARDENED_RUNTIME)
2. Use explicit entitlements file
**Decision:** Use both — build settings for Hardened Runtime, explicit entitlements file for Sandbox with read-write file access.
**Rationale:** Document-based apps require com.apple.security.files.user-selected.read-write entitlement to save/open files. This must be in entitlements file.
**Specification Reference:** §1.4
**Interpretation Required:** Yes
**If Yes, Interpretation Detail:** Specification states "Sandbox: Required" but doesn't specify which sandbox entitlements. Interpreted that a document-based app needs read-write access to user-selected files.

---

### [2024-12-30 20:48] Decision: Swift 6 Actor Isolation Compliance

**Context:** Project uses Swift 6 with SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor. NSDocument override methods caused compilation errors due to actor isolation conflicts.
**Options Considered:**

1. Disable strict concurrency checking (SWIFT_STRICT_CONCURRENCY = minimal)
2. Add `nonisolated` keyword to affected overrides
3. Remove MainActor default isolation

**Decision:** Add `nonisolated` keyword to `autosavesInPlace`, `data(ofType:)`, and `read(from:ofType:)` overrides.
**Rationale:** Maintains Swift 6 strict concurrency while properly marking NSDocument methods that must be nonisolated per their base class declarations. This is the correct, forward-compatible approach.
**Specification Reference:** §1.4 (Swift language requirement implied)
**Interpretation Required:** Yes
**If Yes, Interpretation Detail:** Specification doesn't specify Swift language version or concurrency model. Project template defaulted to Swift 6 with strict concurrency. Decision was to maintain strict concurrency and adapt NSDocument overrides accordingly.

---

### [2024-12-30 22:50] Decision: Info.plist Required Bundle Keys

**Context:** Sandbox crash caused by missing CFBundleIdentifier in custom Info.plist. Crash occurred in `_libsecinit_appsandbox` with error "Unable to get bundle identifier because Info.plist from code signature information has no value for kCFBundleIdentifierKey."
**Options Considered:**

1. Switch to GENERATE_INFOPLIST_FILE = YES and use INFOPLIST_KEY_ settings
2. Add missing required keys to custom Info.plist

**Decision:** Option 2 — Add missing keys to custom Info.plist.
**Rationale:** Maintains explicit control over plist structure for UTType declarations while adding required bundle keys. Uses build setting variables (e.g., `$(PRODUCT_BUNDLE_IDENTIFIER)`) for values that should match project configuration.
**Specification Reference:** §9.2 (UTType), §1.4 (Sandbox)
**Interpretation Required:** No — standard required keys for macOS app bundle
**If Yes, Interpretation Detail:** N/A

---

### [2024-12-30 20:37] Decision: Folder Structure Organization

**Context:** Blueprint specifies folder structure with App/, Document/, Model/, Views/, Export/, Utilities/, Resources/ subdirectories.
**Options Considered:** None — blueprint is explicit.
**Decision:** Create exact folder structure as specified in Sprint 0 deliverables.
**Rationale:** Direct compliance with blueprint.
**Specification Reference:** Implementation Blueprint, Sprint 0 Deliverables
**Interpretation Required:** No
**If Yes, Interpretation Detail:** N/A

---
