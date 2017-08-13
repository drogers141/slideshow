//
//  ThumbsViewController.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class ThumbsViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    fileprivate func configureCollectionView() {
        // 1
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120.0, height: 120.0)
        flowLayout.sectionInset = EdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        // 2
        view.wantsLayer = true
        // 3
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

}

