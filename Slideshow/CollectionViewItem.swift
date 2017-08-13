//
//  CollectionViewItem.swift
//  Slideshow
//
//  Created by David Rogers on 8/12/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    var imageFile: ThumbImageFile? {
        didSet {
            guard isViewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
            } else {
                imageView?.image = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        // border not showing
        view.layer?.borderColor = NSColor.white.cgColor
        view.layer?.borderWidth = 0.0
    }

    override var isSelected: Bool {
        didSet {
            // if selected add border
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
}

