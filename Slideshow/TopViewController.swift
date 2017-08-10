//
//  TopViewController.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

class TopViewController: NSSplitViewController {

    var imagesManager = ImagesManager()

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initImages()
    }


}

