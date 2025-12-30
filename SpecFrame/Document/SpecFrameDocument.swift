//
//  SpecFrameDocument.swift
//  SpecFrame
//
//  Created by SpecFrame Team on 2024-12-30.
//

import Cocoa

class SpecFrameDocument: NSDocument {

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    nonisolated override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Create the window controller with a standard window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 960, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.minSize = NSSize(width: 960, height: 600)
        window.title = "Untitled"
        window.center()

        let windowController = NSWindowController(window: window)
        self.addWindowController(windowController)
    }

    nonisolated override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type,
        // throwing an error in case of failure.
        // Alternatively, you could remove this method and override
        // fileWrapper(ofType:) or write(to:ofType:) instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    nonisolated override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the
        // specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override
        // read(from:ofType:) instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
}
