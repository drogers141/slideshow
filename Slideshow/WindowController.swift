//
//  WindowController.swift
//  Slideshow
//
//  Created by David Rogers on 8/12/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        // set window to right half of screen
        if let window = window, let screen = NSScreen.main() {
            let screenRect = screen.visibleFrame
            window.setFrame(NSRect(x: screenRect.width/2.0, y: screenRect.origin.y, width: screenRect.width/2.0,
                                   height: screenRect.height), display: true)
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

