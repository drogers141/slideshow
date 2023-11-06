//
//  ThumbsViewController.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class ThumbsViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {

    @IBOutlet weak var collectionView: NSCollectionView!

    let thumbSize = NSSize(width: 120.0, height: 120.0)

    // no headers so this is the only background
    var backgroundColor = NSColor.black.cgColor

    // could do these more swiftly as optional computed property I believe
    fileprivate func getMainVC() -> MainViewController? {
        guard let splitVC = parent as? TopViewController else { return nil}
        return splitVC.childViewControllers[1] as? MainViewController
    }

    fileprivate func getImagesManager() -> ImagesManager? {
        if let mainVC = getMainVC() {
            return mainVC.imagesManager
        } else {
            return nil
        }
    }

    fileprivate func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = thumbSize
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        collectionView.allowsMultipleSelection = false
        view.wantsLayer = true
        // layer not available here, unfortunately
//        collectionView.layer?.backgroundColor = backgroundColor
//        print("\(#function): configured")
    }

    func setBackgroundColor() {
        if let cvLayer = collectionView.layer {
            cvLayer.backgroundColor = backgroundColor
        } else {
            NSLog("\(#function) no collectionView layer")
        }
    }

    func setAppearanceTheme() {
        guard let winConfig = ConfigManager.manager.getWinConfig()  else {
            NSLog("ThumbsViewController: did not get winConfig")
            return
        }
        if winConfig.appearanceTheme == .dark {
            backgroundColor = NSColor.black.cgColor
        } else {
            backgroundColor = NSColor.windowBackgroundColor.cgColor
        }
    }
    
    func reloadData() {
        self.collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("thumbsview \(#function)")
        setAppearanceTheme()
        configureCollectionView()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        NSLog("thumbsview \(#function)")
        if let cvLayer = collectionView.layer {
            cvLayer.backgroundColor = backgroundColor
        } else {
            NSLog("\(#function) no collectionView layer")
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
//        NSLog("thumbsview \(#function)")
//        NSLog("thumbsview: frame size = \(view.frame.size)")
    }

    override func viewDidAppear() {
        // sloppy but it works
        // can't get the background layer until after everything is initialized
        // though it should be available now
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.setBackgroundColor()
            }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
//        NSLog("thumbsview \(#function)")
//        let width = view.frame.width
//        NSLog("width: \(width)")
//        let xAxisConstraints = view.constraintsAffectingLayout(for: NSLayoutConstraintOrientation.horizontal)
//        printConstraints("thumbview x constraints:", xAxisConstraints)
    }


    // NSCollectionViewDataSource protocol

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if let mgr = getImagesManager() {
            return mgr.currentFiles.count
        } else {
            return 0
        }
    }

    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        guard let splitVC = parent as? TopViewController else { return item }

        if let mainVC = splitVC.childViewControllers[1] as? MainViewController {
            let imageFile = ThumbImageFile(url: mainVC.imagesManager.currentFiles[indexPath.item])
            collectionViewItem.imageFile = imageFile
        }
        return item
    }

    // NSCollectionViewDelegate protocol

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
//        print("selected: indexPaths=\(indexPaths)")
        // assume single selection
        if let elem = indexPaths.first {
            let newIndex = elem.item
//            print("newIndex: \(newIndex)")
            if let mainVC = getMainVC() {
                mainVC.gotoIndex(newIndex)
            }
//            let selectedIndexes = collectionView.selectionIndexes
//            let selectedIndexPaths = collectionView.selectionIndexPaths
//            print("selectedIndexes: \(selectedIndexes)")
//            print("selectedIndexPaths: \(selectedIndexPaths)")
//            let visibleIndexPaths = collectionView.indexPathsForVisibleItems()
//            print("visibleIndexPaths: \(visibleIndexPaths)")
//            if !selectedIndexPaths.isEmpty && visibleIndexPaths.contains(selectedIndexPaths.first!) {
//                print("selectedIndexPath is in visibleIndexPaths")
//            } else {
//                print("selectedIndexPath is not in visibleIndexPaths")
//            }
        }
    }
}

