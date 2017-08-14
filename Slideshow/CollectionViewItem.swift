//
//  CollectionViewItem.swift
//  Slideshow
//
//  Created by David Rogers on 8/12/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    let regularBackgroundColor = NSColor.darkGray.cgColor
    let gifBackgroundColor = NSColor.lightGray.cgColor
    // only shown when selected
    let borderColor = NSColor.white.cgColor

    var imageFile: ThumbImageFile? {
        didSet {
            guard isViewLoaded else { return }
            if let imageFile = imageFile {
                if imageFile.fileName.lowercased().hasSuffix(".gif") {
                    view.layer?.backgroundColor = gifBackgroundColor
                }
                imageView?.image = imageFile.thumbnail
            } else {
                imageView?.image = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = regularBackgroundColor
        // border not showing
        view.layer?.borderColor = borderColor
        view.layer?.borderWidth = 0.0
    }

    override var isSelected: Bool {
        didSet {
            // if selected add border
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
}

