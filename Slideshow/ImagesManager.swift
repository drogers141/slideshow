//
//  ImagesManager.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Foundation


class ImagesManager {

    // the image files currently working with
    var currentFiles = [URL]()

    // if working with images in directories, currentFiles are in the current directory
    // and this holds the remaining directories if there are any
    // if images are coming from a file list, this should stay empty
    var remainingDirs = [String]()

    var currentIndex = 0
    var currentFile: URL {
        get {
            return currentFiles[currentIndex]
        }
    }
    // make sure implementation handles uppercase as well
    static let imageFileExts = [".jpg", ".png", ".gif"]

    // TODO - configure copying and trash more, but still minimal
    var copyDir = URL(fileURLWithPath: "/Users/drogers/atemp/slideshow-copy")
    var trashDir = URL(fileURLWithPath: "/Users/drogers/atemp/slideshow-trash")

    // initialize the manager with either a directory list or a files list
    // this can't be done in the constructor due to vagaries of swift

    func initFiles(dirList: [String]) {
        var dirs = dirList
        let currentDir = dirs.remove(at: 0)
        remainingDirs = dirs
        currentFiles = ImagesManager.getImages(dirPath: currentDir)
    }

    func initFiles(fileList: [String]) {
        currentFiles = ImagesManager.getImages(fileList: fileList)
    }

    // increment currentIndex - negative or positive
    func incrementIndex(_ n: Int) {
        currentIndex = (currentIndex + n) % currentFiles.count
        if currentIndex < 0 {
            currentIndex = currentFiles.count + currentIndex
        }
    }

    // get images from a directory
    static func getImages(dirPath: String) -> [URL] {
        var ret = [URL]()
        let fileManager = FileManager.default
        do {
            let allFiles = try fileManager.contentsOfDirectory(atPath: dirPath)
            for f in allFiles
            {
                //                print("checking \(f)")
                for suffix in imageFileExts {
                    if f.lowercased().hasSuffix(suffix) {
                        ret.append(URL.init(fileURLWithPath: dirPath + "/" + f))
                        break
                    }
                }

            }
        } catch {
            print("error getting dir contents")
        }
        return ret
    }

    // filter list of files for images
    static func getImages(fileList: [String]) -> [URL] {
        var ret = [URL]()
        for f in fileList {
            for suffix in imageFileExts {
                if f.lowercased().hasSuffix(suffix) {
                    ret.append(URL.init(fileURLWithPath: f))
                    break
                }
            }
        }
        return ret
    }

    func copyCurrent() throws {
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: copyDir, withIntermediateDirectories: true, attributes: nil)
        var dest = copyDir
        dest.appendPathComponent(currentFile.lastPathComponent)
        if !fileManager.fileExists(atPath: dest.path) {
            try fileManager.copyItem(at: currentFile, to: dest)
        } else {
            print("file exists: \(dest.path)")
        }
    }

    func removeCurrent() throws {
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: trashDir, withIntermediateDirectories: true, attributes: nil)
        var dest = trashDir
        dest.appendPathComponent(currentFile.lastPathComponent)
        if !fileManager.fileExists(atPath: dest.path) {
            try fileManager.moveItem(at: currentFile, to: dest)
        }
        currentFiles.remove(at: currentIndex)
    }

    // returns index of first matching file or -1
    func searchForFile(_ glob: String) -> Int {
        var retVal = -1
        for (i, f) in currentFiles.enumerated() {
            let target = f.lastPathComponent
            if Glob.match(glob, target) {
                retVal = i
                break
            }
        }
        return retVal
    }

}

