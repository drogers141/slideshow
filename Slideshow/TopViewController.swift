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

    var savedDividerPos = 0.0

    let thumbSize = NSSize(width: 120.0, height: 120.0)

    func getThumbsWidth(_ numCols: Int) -> Float {
        // 302 == 2 cols (301.5 shifts to one)
        //        let numThumbCols = 2
        // sectionInset - left and right
        let margins = CGFloat(20.0 + 20.0)
        // layout.minimumInteritemSpacing
        let interSpace = CGFloat(20.0)
        let cushion = CGFloat(5)
        let w = (CGFloat(numCols) * thumbSize.width) + (CGFloat(numCols - 1) * interSpace)
            + margins + cushion

        return Float(w)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let divPos = getThumbsWidth(2) + 20
//        print("setting divider at \(divPos)")
//        splitView.setPosition(CGFloat(divPos), ofDividerAt: 0)
    }

    override func viewWillAppear() {
        let divPos = getThumbsWidth(2)
        print("setting divider at \(divPos)")
        splitView.setPosition(CGFloat(divPos), ofDividerAt: 0)
    }
    override func viewDidLayout() {
        let xAxisConstraints = view.constraintsAffectingLayout(for: NSLayoutConstraintOrientation.horizontal)
        printConstraints("topview x constraints:", xAxisConstraints)
    }

    func toggleThumbsView() {
        if let thumbsView = splitViewItem(for: childViewControllers[0]) {
            if thumbsView.isCollapsed {
                openThumbsView()
            } else {
                collapseThumbsView()
            }
        }
    }

    func collapseThumbsView() {
        if let thumbsView = splitViewItem(for: childViewControllers[0]) {
            savedDividerPos = Double(thumbsView.viewController.view.frame.width)
            print("collapsed thumbview - saved divider at: \(savedDividerPos)")
            thumbsView.canCollapse = true
            thumbsView.isCollapsed = true
//            thumbsView.minimumThickness = 0.0
//            splitView.setPosition(0.0, ofDividerAt: 0)
//            splitView.adjustSubviews()
        }
    }

    func openThumbsView() {
        if let thumbsView = splitViewItem(for: childViewControllers[0]) {
            if thumbsView.isCollapsed {
                thumbsView.isCollapsed = false
            }
            splitView.setPosition(CGFloat(savedDividerPos), ofDividerAt: 0)
            //            splitView.adjustSubviews()
        }
    }

    // NSSplitViewDelegate
    override func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        return true
    }
}

