//
//  WindowController.swift
//  Slideshow
//
//  Created by David Rogers on 8/12/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()

        // set window frame to size custom by screen, on right edge
        if let window = window, let screen = NSScreen.main() {
            let screenRect = screen.visibleFrame
            print("screen.visibleFrame: \(screenRect)")
            // desktop
            let y = screenRect.origin.y
            let h = screenRect.height
            var w = screenRect.width/2.0

            if screenRect.width == 1440 {
                print("laptop screen")
                w = 1152
            }
            let x = screenRect.width - w
            window.setFrame(NSRect(x: x, y: y, width: w, height: h), display: true)
        }
    }

    func windowWillClose(_ notification: Notification) {
//        NSLog("windowWillClose notification: \(notification)")
        if let window = window {
            let frame = window.frame
            NSLog("windowWillClose frame: \(frame)")
        }
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    // handles escape key - cancelOperation is in an NSWindow
    // that would get it first - if not implemented gets caught by this
    // note no override
    func cancel(_ id: Any?) {
        print("cancelOperation")
        if let window = window {
            window.close()
        }
    }

}

