//
//  CLI.swift
//  Slideshow
//
//  Created by David Rogers on 8/9/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//

import Foundation



func getProcessInfo() -> (Int, String) {
    let procName = ProcessInfo.processInfo.processName
    let pid = ProcessInfo.processInfo.processIdentifier
    print("pid: \(pid), proc: \(procName)")
    return (Int(pid), procName)
}

// returns tuple - (type, filelist|directorylist)
// type is "files" or "directories" indicating which
// second element of tuple is an array containing either a file list or a directory list
// directorylist - only directories
// filelist - only files
func handleProgramArgs() -> (String, Array<String>) {
    let usage = "Usage: <slideshow> args\n    args = sequence of files or sequence of dirs"
    let fileManager = FileManager.default
    var content = [String]()
    var type = "directories"
    print("command line args:")
    var checkforDir : ObjCBool = false
    if CommandLine.argc > 1 {
        let firstArg = CommandLine.arguments[1]
        print("firstArg: \(firstArg)")

        if fileManager.fileExists(atPath: firstArg, isDirectory: &checkforDir) {
            if checkforDir.boolValue == true {
                print("directories")
                for i in 1...CommandLine.argc-1 {
                    let index = Int(i);

                    let arg = CommandLine.arguments[index] //String.fromCString(C_ARGV[index])
                    //                        print("\(index): \(arg)")
                    if fileManager.fileExists(atPath: arg, isDirectory: &checkforDir) {
                        content.append(arg)
                    }
                }
            } else {
                print("files")
                type = "files"
                checkforDir = false
                if fileManager.fileExists(atPath: firstArg, isDirectory: &checkforDir) {
                    for i in 1...CommandLine.argc-1 {
                        let index = Int(i);

                        let arg = CommandLine.arguments[index] //String.fromCString(C_ARGV[index])
                        //                            print("\(index): \(arg)")
                        if fileManager.fileExists(atPath: arg, isDirectory: &checkforDir) {
                            content.append(arg)
                        }
                    }
                }
            }
        } else {
            print(usage)
        }
    } else {
        print(usage)
    }
    return (type, content)
}


// print out gif info for all dirs on the command line
func testAllGifs() {
    let (type, content) = handleProgramArgs()
    if type == "files" && content.count > 0 {
        print("content: \(content)")
        for dir in content {
            let imgs = ImagesManager.getImages(dirPath: dir)
            for url in imgs {
                if url.pathExtension.lowercased() == "gif" {
                    if let info = gifInfo(url: url) {
                        print("\(url.lastPathComponent): \(info)")
                    } else {
                        print("failed: \(url)")
                    }
                }
            }
        }
    } else {
        print("testAllGifs: only handling dirs on command line")
    }
}

