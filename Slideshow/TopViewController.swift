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
        // 2 cols here ends up being 305
        // on dell 26 screen - needs to be at 318
        // sectionInset - left and right
        let margins = CGFloat(20.0 + 20.0)
        // layout.minimumInteritemSpacing
        let interSpace = CGFloat(20.0)
//        let cushion = CGFloat(5)
        let cushion = CGFloat(18)
        let w = (CGFloat(numCols) * thumbSize.width) + (CGFloat(numCols - 1) * interSpace)
            + margins + cushion

        return Float(w)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let config = ConfigManager.manager
        print(#function)
        if let winConfig = config.getWinConfig() {
            let key = winConfig.key
            let isCollapsed = winConfig.thumbsCollapsed
            let dividerPos = winConfig.dividerPos
            print("topview \(#function)")
            print("winConfig: key: \(key), isCollapsed: \(isCollapsed), dividerPos: \(dividerPos)")
        } else {
            print("did not get winConfig")
            //                config.storeWinGeo(frame: [x, y, w, h])
        }
//        let divPos = getThumbsWidth(2) + 20
//        print("setting divider at \(divPos)")
//        splitView.setPosition(CGFloat(divPos), ofDividerAt: 0)
        
        // setting a value for a key
        let newPerson = Person(name: "Joe", age: 10)
        var people = [Person]()
        people.append(newPerson)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: people)
        UserDefaults.standard.set(encodedData, forKey: "people")
        
        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey: "people"),
            let myPeopleList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Person] {
            myPeopleList.forEach({print( $0.name, $0.age)})  // Joe 10
        } else {
            print("There is an issue")
        }
        let person2 = Person(name: "Joe", age: 21)
        let encoded = NSKeyedArchiver.archivedData(withRootObject: person2)
        UserDefaults.standard.set(encoded, forKey: "person2")
        
        if let data2 = UserDefaults.standard.data(forKey: "person2"),
            let p2 = NSKeyedUnarchiver.unarchiveObject(with: data2) as? Person {
            print("p2: \(p2.name), \(p2.age)")
        } else {
            print("issue with person2 case")
        }
    }

    override func viewWillAppear() {
        var divPos = getThumbsWidth(1)
        if let screen = NSScreen.main() {
            if screen.frame.width == 1440 {
                print("laptop screen")
                divPos = getThumbsWidth(2)
            }
        }
        print("setting divider at \(divPos)")
        splitView.setPosition(CGFloat(divPos), ofDividerAt: 0)
    }
    
    override func viewWillDisappear() {
        NSLog("topview controller will disappear")
        let config = ConfigManager.manager
        if let winConfig = config.getWinConfig() {
            let key = winConfig.key
            let isCollapsed = winConfig.thumbsCollapsed
            let dividerPos = winConfig.dividerPos
            print("topview \(#function)")
            print("winConfig: key: \(key)  isCollapsed: \(String(describing: isCollapsed))  dividerPos: \(String(describing: dividerPos))")
        } else {
            print("topview couldn't get winConfig")
//            config.storeSplitViewInfo(thumbsCollapsed: isCollapsed, dividerPos: dividerPos)
        }
    }
    
    override func viewDidLayout() {
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

