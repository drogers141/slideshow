//
//  AppDelegate.swift
//  Slideshow
//
//  Created by David Rogers on 8/8/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // necessary when launching from the commandline
        NSApp.activate(ignoringOtherApps: true)
        // NSApp is global within app - below is how to do it otherwise
        //        NSApplication.shared().activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let screen = NSScreen.main()
        let screenRect = screen?.visibleFrame
        NSLog("screen.visibleFrame: \(String(describing: screenRect))")
//        print("screen.visibleFrame: \(screenRect)")
//        if let win = NSApp.mainWindow {
//            let rect = win.frame
//            print("win: \(rect)")
//        } else {
//            print("window gone")
//        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

