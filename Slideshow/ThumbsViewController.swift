//
//  ThumbsViewController.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class ThumbsViewController: NSViewController, NSCollectionViewDataSource {

    @IBOutlet weak var collectionView: NSCollectionView!

    let thumbSize = NSSize(width: 120.0, height: 120.0)

    fileprivate func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = thumbSize
        flowLayout.sectionInset = EdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout

        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    // NSCollectionViewDataSource protocol

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let splitVC = parent as? TopViewController else { return 0}
        if let mainVC = splitVC.childViewControllers[1] as? MainViewController {
            return mainVC.imagesManager.currentFiles.count
        } else {
            return 0
        }
    }

    // 3
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        // 4
        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        guard let splitVC = parent as? TopViewController else { return item }

        if let mainVC = splitVC.childViewControllers[1] as? MainViewController {
            let imageFile = ThumbImageFile(url: mainVC.imagesManager.currentFiles[indexPath.item])
            collectionViewItem.imageFile = imageFile
        }
        return item

        // 5
//        let imageFile = ThumbImageFile(url:)
//        collectionViewItem.imageFile = imageFile
//        return item
    }
}

