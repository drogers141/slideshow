//
//  Glob.swift
//  Slideshow
//
//  Created by David Rogers on 8/18/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Foundation

class Glob {
    // if the substring is found in the target string, return the remainder of the target
    // after the substring
    static private func findAndGetRemaining(sub: String, target: String) -> String? {
        if let matchRange = target.range(of: sub) {
            return target[matchRange.upperBound..<target.endIndex]
        } else {
            return nil
        }
    }

    // * -> 0 or more characters
    // case insensitive
    static func match(_ glob: String,_ target: String) -> Bool {
        guard glob != "" else { return true }
        var remainingInput = target.lowercased()
        var globParts = glob.components(separatedBy: "*").filter{!$0.isEmpty}
        guard globParts.count > 0 else { return true }
        //    print("globParts: \(globParts)")

        // "sub*[..]", "[..]*sub" cases
        if !glob.hasPrefix("*") {
            if !remainingInput.hasPrefix(globParts[0]) {
                print("not prefix")
                return false
            }
        } else if !glob.hasSuffix("*") {
            if !remainingInput.hasSuffix(globParts[globParts.count-1]) {
                print("not suffix")
                return false
            }
        }

        for g in globParts {
            if let matched = findAndGetRemaining(sub: g, target: remainingInput) {
                //            print("g=\(g) matched remainingInput=\(remainingInput)")
                remainingInput = matched
                //            print("remainingInput=\(remainingInput)")
            } else {
                return false
            }
        }
        return true
    }

}

