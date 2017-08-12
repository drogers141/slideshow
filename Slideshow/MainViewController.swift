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
        previous()
    }

    @IBAction func pageForwardBtnClicked(_ sender: NSButton) {
        pageForward()
    }

    @IBAction func pageBackwardBtnClicked(_ sender: NSButton) {
        pageBackward()
    }

    @IBOutlet weak var mainImage: NSImageView!

    // note the need for an implicitly unwrapped optional to avoid null-checking, etc
    // everywhere this member is used
    var imagesManager: ImagesManager!

    func next() {
        imagesManager.incrementIndex(1)
        display(url: imagesManager.currentFile)
    }
    func previous() {
        imagesManager.incrementIndex(-1)
        display(url: imagesManager.currentFile)
    }
    func pageForward() {
        imagesManager.incrementIndex(10)
        display(url: imagesManager.currentFile)
    }
    func pageBackward() {
        imagesManager.incrementIndex(-10)
        display(url: imagesManager.currentFile)
    }

    func display(url: URL) {
        if isViewLoaded {
            print("\(imagesManager.currentIndex+1): \(url.path)")
            if url.pathExtension.lowercased() == "gif" {
                if let info = gifInfo(url: url) {
                    print("gif info: \(info)")
                }
            }
            mainImage.image = NSImage.init(contentsOf: url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let splitVC = parent as? TopViewController else { return }
        imagesManager = splitVC.imagesManager as ImagesManager
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

