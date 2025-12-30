//
//  AppDelegate.swift
//  SpecFrame
//
//  Created by SpecFrame Team on 2024-12-30.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Application has finished launching
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Application is about to terminate
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return true
    }
}
