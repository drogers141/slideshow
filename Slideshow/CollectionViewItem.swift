//
//  CollectionViewItem.swift
//  Slideshow
//
//  Created by David Rogers on 8/12/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    // muted dark gray w blue
    // NSColor(red: 0.07, green: 0.09, blue: 0.16, alpha: 1.0).cgColor
    // lightish green
    // NSColor(red: 0.72, green: 0.85, blue: 0.41, alpha: 1.0).cgColor
    // slate gray 112-138-144
    // light gray 211
    // NSColor.darkGray.cgColor
    // NSColor.gray.cgColor
    let regularBackgroundColor = NSColor.lightGray.cgColor
    // NSColor.lightGray.cgColor  rgb(72%, 85%, 41%)
    let gifBackgroundColor = NSColor.darkGray.cgColor
    // only shown when selected
    // NSColor.white.cgColor
    var borderColor = NSColor(red: 0.72, green: 0.85, blue: 0.41, alpha: 1.0).cgColor

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

    func setAppearanceTheme() {
        if ConfigManager.manager.appearanceTheme == .dark {
            borderColor = NSColor(red: 0.72, green: 0.85, blue: 0.41, alpha: 1.0).cgColor
        } else {
            borderColor = NSColor.black.cgColor
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = regularBackgroundColor
        // border not showing
        view.layer?.borderWidth = 0.0
        setAppearanceTheme()
        view.layer?.borderColor = borderColor

    }

    override var isSelected: Bool {
        didSet {
            // if selected add border
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
}

