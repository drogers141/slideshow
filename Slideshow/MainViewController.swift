//
//  MainViewController.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var imageIndexLabel: NSTextFieldCell!
    @IBOutlet weak var imageFileName: NSTextFieldCell!

    @IBOutlet weak var mainImage: NSImageView!

    @IBOutlet var gotoTextField: NSTextField!
    @IBAction func gotoTextChanged(_ sender: NSTextField) {
    }

    @IBAction func copyBtnClicked(_ sender: NSButton) {
    }
    @IBAction func deleteBtnClicked(_ sender: NSButton) {
    }

    @IBOutlet var delayTextField: NSTextField!

    @IBAction func delayTextFieldChanged(_ sender: NSTextField) {
        autoplayDelay = Double(delayTextField.stringValue)!
        print("autoplayDelay = \(autoplayDelay)")
        DispatchQueue.main.async {
            self.delayTextField.window?.makeFirstResponder(self)
        }
    }

    @IBOutlet var autoplayButton: NSButton!

    @IBAction func autoplayBtnClicked(_ sender: NSButton) {
        if autoplay == true {
            print("autoplay off")
            sender.title = "Autoplay"
            autoplay = false
        } else {
            print("autoplay on")
            sender.title = "Stop"
            autoplay = true
            doAutoplay()
        }
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


    // note the need for an implicitly unwrapped optional to avoid null-checking, etc
    // everywhere this member is used
    var imagesManager = ImagesManager()

    var autoplay = false
    var autoplayDelay = 4.0

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
            imageIndexLabel.title = "\(imagesManager.currentIndex+1)/\(imagesManager.currentFiles.count)"
            imageFileName.title = imagesManager.currentFile.path
        }
    }

    func initImages() {
        (_, _) = getProcessInfo()
        let (type, content) = handleProgramArgs()
        guard content.count > 0 else {
            print("** no files or dirs **")
            return
        }
        if type == "directories" {
            self.imagesManager.initFiles(dirList: content)
        } else if type == "files" {
            self.imagesManager.initFiles(fileList: content)
        } else {
            print("** not directories or files? **")
        }
        print("top view init images")
    }

    func startGUI() {
        display(url: imagesManager.currentFile)
        imageIndexLabel.title = "\(imagesManager.currentIndex+1)/\(imagesManager.currentFiles.count)"
        imageFileName.title = imagesManager.currentFile.path
        delayTextField.stringValue = "\(autoplayDelay)"
        print("autoplayDelay = \(autoplayDelay)")

        // allows the viewcontroller to be a first responder and the key events will be sent to it
        // otherwise, default behavior was for any keys to go to the text field
        DispatchQueue.main.async {
            self.delayTextField.window?.makeFirstResponder(self)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let splitVC = parent as? TopViewController else { return }
//        imagesManager = splitVC.imagesManager as ImagesManager

        initImages()
        print("currentFiles: \(imagesManager.currentFiles.count)")
        print("images manager currentFile: \(imagesManager.currentFile)")
        startGUI()
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case 123:
//            print("left arrow")
            previous()

        case 124:
//            print("right arrow")
            next()

        case 125:
//            print("down arrow")
            pageBackward()

        case 126:
//            print("up arrow")
            pageForward()

        default:
            if Int(event.keyCode) != 53 {
                // 53 is ESC - handled by window controller as cancel()
                print("another key: \(event.keyCode)")
            }
            super.keyDown(with: event)
        }
    }

    // TODO handle reverse direction
    func doAutoplay() {
        print("doAutoplay")
//        autoplayDelay = Double(delayTextField.stringValue)!
        if autoplay == true {
            next()
            var delay = autoplayDelay
            // handle gif timing
            let url = imagesManager.currentFile
            if url.pathExtension.lowercased() == "gif" {
                delay = calculateGifTime(url: url, delay: delay, minLoops: 2)
            }
            Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(doAutoplay),
                                 userInfo: nil, repeats: false)
        } else {
            print("autoplay off")
        }
    }
}

