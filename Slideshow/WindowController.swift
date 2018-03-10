//
//  WindowController.swift
//  Slideshow
//
//  Created by David Rogers on 8/12/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    func getDefaultFrame() -> NSRect? {
        guard let screen = NSScreen.main() else { return nil }
        let screenRect = screen.visibleFrame
//        print("screen.visibleFrame: \(screenRect)")
//        print("screen.frame: \(screen.frame)")

        // desktop screen
        let y = screenRect.origin.y
        let h = screenRect.height
        var w = screenRect.width/2.0

        // laptop screen
        if screenRect.width == 1440 {
            w = 1152
        }
        let x = screenRect.width - w

        return NSRect(x: x, y: y, width: w, height: h)

    }

    override func windowDidLoad() {
        super.windowDidLoad()
        NSLog("window controller: \(#function)")

        guard let win = window else { NSLog("couldn't get window"); return }
        var winFrame = getDefaultFrame()
        let config = ConfigManager.manager
        if let winConfig = config.getWinConfig() {
            let key = winConfig.key
            let storedWin = winConfig.window
            NSLog("winConfig: key: \(key) storedWin: \(storedWin)")
            if storedWin != [0.0, 0.0, 0.0, 0.0] {
                NSLog("setting win frame from userdefaults")
                winFrame = NSRect(x: CGFloat(storedWin[0]), y: CGFloat(storedWin[1]),
                                  width: CGFloat(storedWin[2]), height: CGFloat(storedWin[3]))
            }
        }
        if winFrame != nil {
            win.setFrame(winFrame!, display: true)
        }
    }

    func windowWillClose(_ notification: Notification) {
//        NSLog("window controller: \(#function)")
        if let window = window {
            let frame = window.frame
            let (x, y) = (Double(frame.minX), Double(frame.minY))
            let (w, h) = (Double(frame.width), Double(frame.height))

            let config = ConfigManager.manager
            if let winConfig = config.getWinConfig() {
                let key = winConfig.key
                let win = winConfig.window
//                NSLog("winConfig: key: \(key) win: \(win)")
                let newWin = [x, y, w, h]
//                NSLog("storing window frame = \(newWin)")
                winConfig.window = newWin
                config.storeWinConfig(winConfig)

            } else {
                NSLog("did not get winConfig")
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
//        print("cancelOperation")
        if let window = window {
            window.close()
        }
    }

}

