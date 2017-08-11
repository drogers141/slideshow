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
        next()
    }

    @IBAction func prevBtnClicked(_ sender: NSButton) {
    }

    @IBAction func pageForwardBtnClicked(_ sender: NSButton) {
    }

    @IBAction func pageBackwardBtnClicked(_ sender: NSButton) {
    }


    @IBOutlet weak var mainImage: NSImageView!

    func next() {
        let mgr = getImageManager()
        mgr!.incrementIndex(1)
        display(url: mgr!.currentFile)
    }

    func getImageManager() -> ImagesManager? {
        guard let splitVC = parent as? TopViewController else { return nil }
        guard var imagesManager = splitVC.imagesManager as? ImagesManager else { return nil }
        return imagesManager
    }

    func display(url: URL) {
        if isViewLoaded {
            let mgr = getImageManager()
            if mgr != nil {
                print("\(mgr!.currentIndex+1): \(url.path)")
                if url.pathExtension.lowercased() == "gif" {
                    if let info = gifInfo(url: url) {
                        print("gif info: \(info)")
                    }
                }
                mainImage.image = NSImage.init(contentsOf: url)
            }
        }
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

