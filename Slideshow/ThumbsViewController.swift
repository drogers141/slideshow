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
    let backgroundColor = NSColor.black.cgColor

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
        flowLayout.sectionInset = EdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout

        view.wantsLayer = true
        collectionView.layer?.backgroundColor = backgroundColor
        collectionView.allowsMultipleSelection = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        let numThumbCols = 5
        let margins = 20 + 20
        let w = CGFloat(numThumbCols) * (20 + thumbSize.width)
        print("thumbsview: setting width = \(w)")
        view.setFrameSize(NSSize(width: w, height: view.frame.height))
    }

    override func viewDidLayout() {
        let xAxisConstraints = view.constraintsAffectingLayout(for: NSLayoutConstraintOrientation.horizontal)
//        print("thumbsview x constraints:\n\(xAxisConstraints)")
        printConstraints("thumbview x constraints:", xAxisConstraints)
        print("thumbview: frame width = \(view.frame.size)")
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

        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
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
        print("selected: indexPaths=\(indexPaths)")
        // assume single selection
        if let elem = indexPaths.first {
            let newIndex = elem.item
            print("newIndex: \(newIndex)")
            if let mainVC = getMainVC() {
                mainVC.gotoIndex(newIndex)
            }
            let selectedIndexes = collectionView.selectionIndexes
            let selectedIndexPaths = collectionView.selectionIndexPaths
            print("selectedIndexes: \(selectedIndexes)")
            print("selectedIndexPaths: \(selectedIndexPaths)")
            let visibleIndexPaths = collectionView.indexPathsForVisibleItems()
            print("visibleIndexPaths: \(visibleIndexPaths)")
            if !selectedIndexPaths.isEmpty && visibleIndexPaths.contains(selectedIndexPaths.first!) {
                print("selectedIndexPath is in visibleIndexPaths")
            } else {
                print("selectedIndexPath is not in visibleIndexPaths")
            }
        }
    }
}

