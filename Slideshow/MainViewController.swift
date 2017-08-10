//
//  MainViewController.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet var imageIndexLabel: NSTextField!
    @IBOutlet var imageFilenameLabel: NSTextField!

    @IBOutlet var gotoTextField: NSTextField!
    @IBAction func gotoTextChanged(_ sender: NSTextField) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case 123:
            print("left arrow")
            //            displayNth(increment: -1)

        case 124:
            print("right arrow")
            //            displayNth(increment: 1)

        case 125:
            print("down arrow")
            //            displayNth(increment: -10)

        case 126:
            print("up arrow")
            //            displayNth(increment: 10)

        default:
            print("another key: \(event.keyCode)")
            super.keyDown(with: event)
        }
    }

}

