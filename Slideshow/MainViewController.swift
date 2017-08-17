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
        copyCurrent()
    }
    @IBAction func deleteBtnClicked(_ sender: NSButton) {
        removeCurrent()
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

    // ************************************************************//

    // OTHER CONFIG - TODO: use userdefaults

    // default: NSColor.windowBackgroundColor.cgColor
    // background for everything but imageview
    // e.g. NSColor.black.cgColor
    let backgroundColor = NSColor.windowBackgroundColor.cgColor
    // not working
    let imageBackgroundColor = NSColor.black.cgColor
    let imageBorderWidth = CGFloat(5.0)
//    let imageBorderRadius = CGFloat(8.0)

    // rgb(73%, 80%, 81%) - cool gray
    // rgb(71%, 46%, 68%) - purple
    let imageBorderColor = NSColor(red: 0.71, green: 0.46, blue: 0.68, alpha: 1.0).cgColor

    // note the need for an implicitly unwrapped optional to avoid null-checking, etc
    // everywhere this member is used
    var imagesManager = ImagesManager()

    var autoplay = false
    var autoplayDelay = 4.0

    func next() {
        imagesManager.incrementIndex(1)
//        display(url: imagesManager.currentFile)
        displayCurrent()
    }
    func previous() {
        imagesManager.incrementIndex(-1)
        displayCurrent()
    }
    func pageForward() {
        imagesManager.incrementIndex(10)
        displayCurrent()
    }
    func pageBackward() {
        imagesManager.incrementIndex(-10)
        displayCurrent()
    }
    func goto(_ index: Int) {
        guard imagesManager.currentIndex != index && index < imagesManager.currentFiles.count
            && index >= 0 else { return }
        imagesManager.currentIndex = index
        displayCurrent()
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
//            mainImage.image?.backgroundColor = imageBackgroundColor
            imageIndexLabel.title = "\(imagesManager.currentIndex+1)/\(imagesManager.currentFiles.count)"
            imageFileName.title = imagesManager.currentFile.path
        }
    }

    func getThumbsVC() -> ThumbsViewController? {
        guard let splitVC = parent as? TopViewController else { return nil}
        return splitVC.childViewControllers[0] as? ThumbsViewController
    }

    // note - even with allowsMultipleSelection set to false
    // it appears programmatic selection allows multiple - so forcing the issue
    func selectAndScrollToThumb(_ index: Int) {
        guard let thumbsVC = getThumbsVC() else { return }
        if let collectionView = thumbsVC.collectionView {

            var selectedIndexPaths = collectionView.selectionIndexPaths
            print("before: selectedIndexPaths: \(selectedIndexPaths)")

            collectionView.deselectAll(nil)

            let selected: Set = [IndexPath(item: index, section: 0)]
            collectionView.selectItems(at: selected, scrollPosition: NSCollectionViewScrollPosition.centeredVertically)

            selectedIndexPaths = collectionView.selectionIndexPaths
            print("after: selectedIndexPaths: \(selectedIndexPaths)")
        }
    }

    // wrap display() to sync thumbs collectionview
    func displayCurrent() {
        selectAndScrollToThumb(imagesManager.currentIndex)
        display(url: imagesManager.currentFile)
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
        displayCurrent()
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

        view.wantsLayer = true
        view.layer?.backgroundColor = backgroundColor

        mainImage.wantsLayer = true
        mainImage.layer?.backgroundColor = imageBackgroundColor
        mainImage.layer?.masksToBounds = true
        mainImage.layer?.borderWidth = imageBorderWidth
        mainImage.layer?.borderColor = imageBorderColor
        mainImage.layer?.borderWidth = imageBorderWidth

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

    func copyCurrent() {
        do {
            try imagesManager.copyCurrent()
        }
        catch let error as NSError {
            print("copyCurrent error:\nerror: \(error)\nerror domain: \(error.domain)")
        }
    }

    func removeCurrent() {
        do {
            try imagesManager.removeCurrent()
            if let thumbsVC = getThumbsVC() {
                thumbsVC.collectionView.deselectAll(nil)
                thumbsVC.collectionView.deleteItems(at: thumbsVC.collectionView.selectionIndexPaths)
                thumbsVC.collectionView.reloadData()
            }
        }
        catch let error as NSError {
            print("copyCurrent error:\nerror: \(error)\nerror domain: \(error.domain)")
        }
    }
}

