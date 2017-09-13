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

    // divider position - this is used to set the divider and store its
    // location at certain times, but thumbsview's frame width is canonical
    var dividerPos = 0.0
    // this flag is also just a proxy for thumbview's isCollapsed
    var thumbsCollapsed = false

    let thumbSize = NSSize(width: 120.0, height: 120.0)

    func getThumbsWidth(_ numCols: Int) -> Double {
        // 2 cols on laptop ends up being 305
        // on dell 26 screen - needs to be at 318
        // sectionInset - left and right
        let margins = CGFloat(20.0 + 20.0)
        // layout.minimumInteritemSpacing
        let interSpace = CGFloat(20.0)
//        let cushion = CGFloat(5)
        let cushion = CGFloat(18)
        let w = (CGFloat(numCols) * thumbSize.width) + (CGFloat(numCols - 1) * interSpace)
            + margins + cushion

        return Double(w)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        NSLog("topview \(#function)")

        let config = ConfigManager.manager
        if let winConfig = config.getWinConfig() {
            thumbsCollapsed = winConfig.thumbsCollapsed
            dividerPos = winConfig.dividerPos
//            NSLog("loading from userdefaults thumbsCollapsed: \(thumbsCollapsed), dividerPos: \(dividerPos)")
        } else {
            NSLog("did not get winConfig")
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
//        NSLog("topview \(#function)")

        guard let thumbsView = splitViewItem(for: childViewControllers[0])
            else { NSLog("topview: couldn't get thumbsview"); return }
        // probably unnecessary
        thumbsView.canCollapse = true

        if thumbsCollapsed {
            thumbsView.isCollapsed = true
//            NSLog("topview: thumbsview collapsed")
        } else {
            var divPos = dividerPos
            if divPos == 0.0 {
                if let screen = NSScreen.main() {
                    if screen.frame.width == 1440 {
                        // laptop
                        divPos = getThumbsWidth(2)
                    } else {
                        divPos = getThumbsWidth(1)
                    }
                }
            }
//            NSLog("topview: setting divider at \(divPos)")
            splitView.setPosition(CGFloat(divPos), ofDividerAt: 0)
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
//        NSLog("topview \(#function)")

//        var actualDividerPos = -1.0
        let thumbsVC = childViewControllers[0]
        let actualDividerPos = Double(thumbsVC.view.frame.width)
        if let thumbsView = splitViewItem(for: thumbsVC) {
            thumbsCollapsed = thumbsView.isCollapsed
//            NSLog("storing actual thumbs collapsed state: \(thumbsCollapsed)")
        } else {
            NSLog("couldn't get thumbsview to get latest thumbsCollapsed state")
        }
        let config = ConfigManager.manager
        if let winConfig = config.getWinConfig() {
//            NSLog("storing actualDividerPos: \(actualDividerPos)")
            winConfig.thumbsCollapsed = thumbsCollapsed
            winConfig.dividerPos = actualDividerPos
            config.storeWinConfig(winConfig)
        } else {
            NSLog("couldn't get winConfig")
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
//        NSLog("topview \(#function)")
//        let xAxisConstraints = view.constraintsAffectingLayout(for: NSLayoutConstraintOrientation.horizontal)
//        printConstraints("topview x constraints:", xAxisConstraints)
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
            dividerPos = Double(thumbsView.viewController.view.frame.width)
//            NSLog("collapsed thumbview - saved divider at: \(dividerPos)")
            thumbsView.isCollapsed = true
        }
    }

    func openThumbsView() {
        if let thumbsView = splitViewItem(for: childViewControllers[0]) {
            if thumbsView.isCollapsed {
                thumbsView.isCollapsed = false
            }
            // divider position wasn't saved
            dividerPos = max(dividerPos, getThumbsWidth(1))
            splitView.setPosition(CGFloat(dividerPos), ofDividerAt: 0)
        }
    }

    // NSSplitViewDelegate
    override func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
//        return true
        return false
    }
}

