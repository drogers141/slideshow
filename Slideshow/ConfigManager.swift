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
//     appearanceTheme: enum := light | dark
//     autoplayDelay: Double
//
import Cocoa


enum AppearanceTheme: String {
    case light = "light"
    case dark = "dark"
}

class WinConfig: NSObject, NSCoding {

    // key for userdefaults
    var key = ""
    // screen width, height
    var screen = [0.0, 0.0]
    var window = [0.0, 0.0, 0.0, 0.0]
    var thumbsCollapsed = true
    var dividerPos = 0.0
    var appearanceTheme = AppearanceTheme.dark
    var autoplayDelay = 4.0

    static func defaultConfig() -> WinConfig {
        return WinConfig(key: "", screen: [0.0, 0.0], window: [0.0, 0.0, 0.0, 0.0],
                         thumbsCollapsed: true, dividerPos: 0.0, appearanceTheme: AppearanceTheme.dark, autoplayDelay: 4.0)
    }

    init(key: String, screen: [Double], window: [Double], thumbsCollapsed: Bool,
         dividerPos: Double, appearanceTheme: AppearanceTheme, autoplayDelay: Double) {
        self.key = key
        self.screen = screen
        self.window = window
        self.thumbsCollapsed = thumbsCollapsed
        self.dividerPos = dividerPos
        self.appearanceTheme = appearanceTheme
        self.autoplayDelay = autoplayDelay
//        super.init()
    }

    required init(coder decoder: NSCoder) {
        self.key = decoder.decodeObject(forKey: "key") as? String ?? ""
        self.screen = decoder.decodeObject(forKey: "screen") as? [Double] ?? [0.0, 0.0]
        self.window = decoder.decodeObject(forKey: "window") as? [Double] ?? [0.0, 0.0, 0.0, 0.0]
        self.thumbsCollapsed = decoder.decodeBool(forKey: "thumbsCollapsed")
        self.dividerPos = decoder.decodeDouble(forKey: "dividerPos")
        self.appearanceTheme = AppearanceTheme(rawValue: decoder.decodeObject(forKey: "appearanceTheme") as? String ?? "dark")!
        self.autoplayDelay = decoder.decodeDouble(forKey: "autoplayDelay") ?? 4.0
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(key, forKey: "key")
        encoder.encode(screen, forKey: "screen")
        encoder.encode(window, forKey: "window")
        encoder.encode(thumbsCollapsed, forKey: "thumbsCollapsed")
        encoder.encode(dividerPos, forKey: "dividerPos")
        encoder.encode(appearanceTheme.rawValue, forKey: "appearanceTheme")
        encoder.encode(autoplayDelay, forKey: "autoplayDelay")
    }
}

class ConfigManager {

    static let manager = ConfigManager()
    let userDefaults = UserDefaults.standard

    func getWinConfigKey() -> String? {
        if let screen = NSScreen.main {
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
            "k\t->\tshow keybindings",
            "c or double-click -> open image in Preview"
        ]
    }
}

