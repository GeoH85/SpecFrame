# Interpretation Register — SpecFrame

This document records every instance where the specification did not fully determine the implementation.

---

## Sprint 0: Project Scaffold

### Interpretation #1

**Location:** SpecFrame/SpecFrame.entitlements:8-9
**Specification Gap:** §1.4 states "Sandbox: Required" but does not specify which sandbox entitlements are needed for document-based app functionality.
**Interpretation Made:** Added `com.apple.security.files.user-selected.read-write` entitlement to allow the document-based app to save and open files selected by the user through Open/Save dialogs.
**Confidence:** High
**Risk:** Without this entitlement, the app would not be able to save or open documents despite being a document-based app. Low risk of incorrect interpretation.
**Recommendation:** Clarification needed? N — This is standard practice for sandboxed document-based apps.

---

### Interpretation #2

**Location:** SpecFrame/Document/SpecFrameDocument.swift:20-31
**Specification Gap:** §10.1 shows window structure but doesn't specify initial window size (only minimum in §10.2).
**Interpretation Made:** Set initial window size to match minimum size (960×600) and center window on screen.
**Confidence:** Medium
**Risk:** Users might expect a larger initial window. Can be adjusted based on feedback.
**Recommendation:** Clarification needed? Y — Consider specifying default window size in addition to minimum.

---

### Interpretation #3

**Location:** SpecFrame/App/AppDelegate.swift:25-27
**Specification Gap:** Sprint 0 Instructions do not specify whether the app should automatically open an untitled document on launch.
**Interpretation Made:** Implemented `applicationShouldOpenUntitledFile(_:)` returning `true` to match standard document-based app behavior.
**Confidence:** High
**Risk:** Low — this is expected behavior for document-based apps. File > New should work.
**Recommendation:** Clarification needed? N — Standard macOS document app behavior.

---
