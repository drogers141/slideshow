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

    @IBAction func copyBtnClicked(_ sender: NSButton) {
    }
    @IBAction func deleteBtnClicked(_ sender: NSButton) {
    }

    @IBOutlet var delayTextField: NSTextField!

    @IBAction func delayTextFieldChanged(_ sender: NSTextField) {
    }

    @IBOutlet var autoplayButton: NSButton!

    @IBAction func autoplayBtnClicked(_ sender: NSButton) {
    }

    @IBAction func nextBtnClicked(_ sender: NSButton) {
    }

    @IBAction func prevBtnClicked(_ sender: NSButton) {
    }

    @IBAction func pageForwardBtnClicked(_ sender: NSButton) {
    }

    @IBAction func pageBackwardBtnClicked(_ sender: NSButton) {
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

