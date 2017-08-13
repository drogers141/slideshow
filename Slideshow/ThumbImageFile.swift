//
//  ThumbImageFile.swift
//  Slideshow
//
//  Created by David Rogers on 8/12/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class ThumbImageFile {

    fileprivate(set) var thumbnail: NSImage?
    fileprivate(set) var fileName: String
    let maxPixelSize = 120

    init?(url: URL) {
        fileName = url.lastPathComponent
        thumbnail = nil
        let imageSource = CGImageSourceCreateWithURL(url.absoluteURL as CFURL, nil)
        if let imageSource = imageSource {
            guard CGImageSourceGetType(imageSource) != nil else { return }
            let thumbnailOptions = [
                String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
                String(kCGImageSourceThumbnailMaxPixelSize): maxPixelSize
                ] as [String : Any]
            if let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary?) {
                thumbnail = NSImage(cgImage: thumbnailRef, size: NSSize.zero)
            } else {
                return nil
            }
        }
    }

}

