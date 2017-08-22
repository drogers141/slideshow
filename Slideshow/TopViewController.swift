//
//  TopViewController.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Cocoa

// TODO - debug - put this somewhere
func printConstraints(_ msg: String, _ constraints: [NSLayoutConstraint]) {
    print("\(msg)")
    for c in constraints {
        print("\(c)")
    }
}

class TopViewController: NSSplitViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayout() {
        let xAxisConstraints = view.constraintsAffectingLayout(for: NSLayoutConstraintOrientation.horizontal)
//        print("splitview x constraints:\n\(xAxisConstraints)")
        printConstraints("topview x constraints:", xAxisConstraints)
    }

}

