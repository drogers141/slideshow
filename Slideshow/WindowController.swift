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
            let config = ConfigManager.manager
            if let winConfig = config.getWinConfig() {
                let key = winConfig.key
                let win = winConfig.window
                print("winConfig: key: \(key) win: \(win)")
                if win == [0.0, 0.0, 0.0, 0.0] {
                    print("no window stored for this screen")
                }
            }
            let screenRect = screen.visibleFrame
            print("screen.visibleFrame: \(screenRect)")
//            let frame = screen.frame
            print("screen.frame: \(screen.frame)")
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
            NSLog("\(#function) frame: \(frame)")
            
            let (x, y) = (Double(frame.minX), Double(frame.minY))
            let (w, h) = (Double(frame.width), Double(frame.height))
            let config = ConfigManager.manager
            if let winConfig = config.getWinConfig() {
                let key = winConfig.key
                let win = winConfig.window
                print("window will close: winConfig: key: \(key) win: \(win)")
            } else {
                print("did not get winConfig")
//                config.storeWinGeo(frame: [x, y, w, h])
            }
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

