//
//  SlideshowTests.swift
//  SlideshowTests
//
//  Created by David Rogers on 8/18/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import XCTest
@testable import Slideshow

class SlideshowTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGlobMatch() {
        // check "*str" ->  "a string"
        // and "str*" -> "a string"
//        let globs = ["*str*", "str*", "*str", "*", "", "*str*str*"]
//        let strings = ["string1", "a string", "part of a str", "a string then a string"]
//        let expected = [
//        ]
        let expected = [
            ("", "string", true),
            ("*str*", "string", true),
            ("*str*", "a string", true),
            ("*str*", "end of str", true),
            ("*str*", "a string then a string", true),
            ("*str*", "String", true),

            ("", "string", true),
            ("*str*", "string", true),
            ("*str*", "a string", true),
            ("*str*", "end of str", true),
            ("*str*", "a string then a string", true),

            ("str*", "string", true),
            ("str*", "a string", false),
            ("str*", "end of str", false),
            ("str*", "a string then a string", false),

            ("*", "string", true),
            ("*", "a string", true),
            ("*", "end of str", true),
            ("*", "a string then a string", true),
        ]
        for (glob, target, result) in expected {
            XCTAssertEqual(Glob.match(glob, target), result, "glob: \(glob), target: \(target)")
        }

//        for target in strings {
//            for glob in globs {
//                var result = false
//                if match(glob, target) {
//                    result = true
//                }
//                print("glob: \(glob), target: \(target), match: \(result)")
//            }
//        }
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

