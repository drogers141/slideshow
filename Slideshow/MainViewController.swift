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
    @IBAction func gotoTextSent(_ sender: NSTextField) {
        let text = gotoTextField.stringValue.trimmingCharacters(in: .whitespaces)
        guard text != "" else { return }
        print("goto text=\(text)")
        let val = Int(text)
//        print("val=\(String(describing: val))")
        if val != nil {
//            print("going to index")
            gotoIndex(val!)
        } else {
//            print("going to glob")
            gotoGlob(text)
        }
        DispatchQueue.main.async {
            self.gotoTextField.stringValue = ""
            self.gotoTextField.window?.makeFirstResponder(self)
        }

    }

    @IBAction func copyBtnClicked(_ sender: NSButton) {
        copyCurrent()
    }
    @IBAction func deleteBtnClicked(_ sender: NSButton) {
        removeCurrent()
    }

    @IBOutlet var delayTextField: NSTextField!

    @IBAction func delayTextFieldSent(_ sender: NSTextField) {
        let text = delayTextField.stringValue.trimmingCharacters(in: .whitespaces)
        guard text != "" else { return }
        if let delay = Double(text) {
            print("set autoplayDelay = \(autoplayDelay)")
            autoplayDelay = delay
        }
        DispatchQueue.main.async {
            self.delayTextField.window?.makeFirstResponder(self)
        }
    }

    @IBOutlet var autoplayButton: NSButton!

    @IBAction func autoplayBtnClicked(_ sender: NSButton) {
        handleAutoplayAction()
    }

    func handleAutoplayAction() {
        if autoplay == true {
            print("autoplay off")
            autoplayButton.title = "Autoplay"
            autoplay = false
        } else {
            print("autoplay on")
            autoplayButton.title = "Stop"
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
    // direction for autoplay = "forward" or "backward" - previous() or pageBackward() set to "backward"
    var direction = "forward"

    func next() {
        direction = "forward"
        imagesManager.incrementIndex(1)
//        display(url: imagesManager.currentFile)
        displayCurrent()
    }
    func previous() {
        direction = "backward"
        imagesManager.incrementIndex(-1)
        displayCurrent()
    }
    func pageForward() {
        direction = "forward"
        imagesManager.incrementIndex(10)
        displayCurrent()
    }
    func pageBackward() {
        direction = "backward"
        imagesManager.incrementIndex(-10)
        displayCurrent()
    }
    // note we should be able to overload goto(), but obj-c based selector
    // is happening behind the scenes, so a clear workaround
    func gotoIndex(_ index: Int) {
        guard imagesManager.currentIndex != index && index < imagesManager.currentFiles.count
            && index >= 0 else { return }
        print("goto index")
        imagesManager.currentIndex = index
        displayCurrent()
    }
    func gotoGlob(_ glob: String) {
        print("goto glob")
        let index = imagesManager.searchForFile(glob)
        if index != -1 {
            imagesManager.currentIndex = index
            displayCurrent()
        }
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
        guard let thumbsVC = getThumbsVC() else {
            print("can't get thumbs view controller")
            return
        }
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
        display(url: imagesManager.currentFile)
        DispatchQueue.main.async {
            self.selectAndScrollToThumb(self.imagesManager.currentIndex)
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
        displayCurrent()
        imageIndexLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
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

    override func viewDidLayout() {
        let xAxisConstraints = view.constraintsAffectingLayout(for: NSLayoutConstraintOrientation.horizontal)
//        printConstraints("mainview x constraints:", xAxisConstraints)
    }


    override var acceptsFirstResponder: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        let arrowKeys: Set = [123, 124, 125, 126]
        let charKeys: Set = ["d", "D", "c", "g", "t", "k", " "]

        if arrowKeys.contains(Int(event.keyCode)) {
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
                break
            }
        } else if charKeys.contains(event.characters!) {
            switch event.characters! {
            case "d":
                print("got d")
                DispatchQueue.main.async {
                    self.mainImage.window?.makeFirstResponder(self.delayTextField)
                }
            case "D":
                print("got D")
                print("deleting current")
            case "c":
                print("got c")
            case "g":
                print("got g")
                DispatchQueue.main.async {
                    self.mainImage.window?.makeFirstResponder(self.gotoTextField)
                }
            case "t":
                print("got t")
                guard let splitVC = parent as? TopViewController else { return }
                splitVC.toggleThumbsView()

            case "k":
                print("got k")
            case " ":
                print("got space")
                handleAutoplayAction()

            default:
                break
            }
        } else {
            super.keyDown(with: event)
        }
    }

    override func mouseDown(with event: NSEvent) {
        DispatchQueue.main.async {
            self.mainImage.window?.makeFirstResponder(self)
        }
    }


    // TODO handle reverse direction
    func doAutoplay() {
        print("doAutoplay")
//        autoplayDelay = Double(delayTextField.stringValue)!
        if autoplay == true {
            if direction == "forward" {
                next()
            } else {
                previous()
            }
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

