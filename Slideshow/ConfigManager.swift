//
//  ConfigManager.swift
//  Slideshow
//
//  Created by David Rogers on 8/22/17.
//  Copyright © 2017 David Rogers. All rights reserved.
//
//  key: String -> "screenWidthxScreenHeight" - e.g. "1440x900"
//     screen: [w, h] (Double)
//     window: [x, y, w, h] (Double)
//     thumbsCollapsed: Bool
//     dividerPos: Double
//
import Cocoa

class Person: NSObject, NSCoding {
    var name = ""
    var age = 0
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.age = decoder.decodeInteger(forKey: "age")
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(age, forKey: "age")
    }
}


class WinConfig: NSObject, NSCoding {

    // key for userdefaults
    var key = ""
    // screen width, height
    var screen = [0.0, 0.0]
    var window = [0.0, 0.0, 0.0, 0.0]
    var thumbsCollapsed = true
    var dividerPos = 0.0

    static func defaultConfig() -> WinConfig {
        return WinConfig(key: "", screen: [0.0, 0.0], window: [0.0, 0.0, 0.0, 0.0],
                         thumbsCollapsed: true, dividerPos: 0.0)
    }

    init(key: String, screen: [Double], window: [Double], thumbsCollapsed: Bool,
         dividerPos: Double) {
        self.key = key
        self.screen = screen
        self.window = window
        self.thumbsCollapsed = thumbsCollapsed
        self.dividerPos = dividerPos
//        super.init()
    }

    required init(coder decoder: NSCoder) {
        self.key = decoder.decodeObject(forKey: "key") as? String ?? ""
        self.screen = decoder.decodeObject(forKey: "screen") as? [Double] ?? [0.0, 0.0]
        self.window = decoder.decodeObject(forKey: "window") as? [Double] ?? [0.0, 0.0, 0.0, 0.0]
        self.thumbsCollapsed = decoder.decodeBool(forKey: "thumbsCollapsed")
        self.dividerPos = decoder.decodeDouble(forKey: "dividerPos")
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(key, forKey: "key")
        encoder.encode(screen, forKey: "screen")
        encoder.encode(window, forKey: "window")
        encoder.encode(thumbsCollapsed, forKey: "thumbsCollapsed")
        encoder.encode(dividerPos, forKey: "dividerPos")
    }
}

class ConfigManager {

    static let manager = ConfigManager()
    let userDefaults = UserDefaults.standard

    func getWinConfigKey() -> String? {
        if let screen = NSScreen.main() {
            let f = screen.frame
            let width = Int(f.width)
            let height = Int(f.height)
            return "\(width)x\(height)"
        } else {
            return nil
        }
    }

    // returns stored config object or default with correct key set
    func getWinConfig() -> WinConfig? {
        guard let key = getWinConfigKey()
            else { NSLog(#function, "couldn't get key")
                return nil }
        var winConfig = WinConfig.defaultConfig()
        winConfig.key = key
        if let data = userDefaults.data(forKey: key),
            let wc = NSKeyedUnarchiver.unarchiveObject(with: data) as? WinConfig {
            winConfig = wc
        }
        return winConfig
    }

    // store the config object
    func storeWinConfig(_ winConfig: WinConfig) {
        guard let key = getWinConfigKey() else { NSLog("Couldn't store config"); return }
        let data = NSKeyedArchiver.archivedData(withRootObject: winConfig)
        userDefaults.set(data, forKey: key)
    }

    static func getKeyBindings() -> [String] {
        return [
            "->\t->\tnext",
            "<-\t->\tprevious",
            "up\t->\tpage forward (+10)",
            "down\t->\tpage backward (-10)",
            "c\t->\tcopy current",
            "shift+d\t->\tdelete current",
            "Space\t->\ttoggle autoplay",
            "d\t->\tset autoplay delay",
            "t\t->\ttoggle thumbs",
            "k\t->\tshow keybindings"
        ]
    }
}

