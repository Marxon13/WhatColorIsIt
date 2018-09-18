//
//  WhatColorIsItDefaults.swift
//  WhatColorIsIt
//
// Copyright (c) 2018 Brandon McQuilkin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Cocoa
import ScreenSaver


/// The possible display values to display in the labels.
enum WhatColorIsItLabelDisplayValue: String, RawRepresentable {
    case Hex = "Hex (#120000)"
    case Time = "Time (12:00:00)"
    case None = "None"
    
    static func allValues() -> [WhatColorIsItLabelDisplayValue] {
        return [WhatColorIsItLabelDisplayValue.Hex, WhatColorIsItLabelDisplayValue.Time, WhatColorIsItLabelDisplayValue.None]
    }
}


/// The delegate protocol for the defaults.
protocol WhatColorIsItDefaultsDelegate {
    /// Notifies the delegate that the configuration did change.
    func whatColorIsItDefaultsConfigurationDidChange()
}

private let WhatColorIsItConfigurationDidChangeNotificationName = "WhatColorIsItConfigurationDidChangeNotification"
private let WhatColorIsItBundleIdentifier = "com.BrandonMcQuilkin.WhatColorIsIt"

private let WhatColorIsItMainDisplayValueKey: String = "mainLabelDisplayValue"
private let WhatColorIsItSecondaryDisplayValueKey: String = "secondaryLabelDisplayValue"
private let WhatColorIsItInvertedKey: String = "inverted"

/// Stores user settings for the screen saver.
class WhatColorIsItDefaults: NSObject {
    
    //----------------------------
    // MARK: Properties
    //----------------------------
    
    /// The defaults used to load and save the values to/from disk.
    fileprivate var screenSaverDefaults: ScreenSaverDefaults?
    
    /// The defaults delegate.
    var delegate: WhatColorIsItDefaultsDelegate?
    
    /// Whether or not to save the changes.
    fileprivate var saveChanges: Bool = true
    
    /// What the main label will display on the screen.
    var mainLabelDisplayValue: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue.Time {
        didSet {
            save()
        }
    }
    
    ///  What the secondary label will display on the screen.
    var secondaryLabelDisplayValue: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue.Hex {
        didSet {
            save()
        }
    }
    
    /// Whether or not to display inverted.
    @objc var inverted: Bool = false {
        didSet {
            save()
        }
    }
    
    //----------------------------
    // MARK: Initalization
    //----------------------------
    
    override init() {
        super.init()
        screenSaverDefaults = ScreenSaverDefaults(forModuleWithName: WhatColorIsItBundleIdentifier)
        register()
        revert()
        
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(WhatColorIsItDefaults.configurationDidChange(_:)), name: NSNotification.Name(rawValue: WhatColorIsItConfigurationDidChangeNotificationName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WhatColorIsItConfigurationDidChangeNotificationName), object: nil)
    }
    
    //----------------------------
    // MARK: Actions
    //----------------------------
    
    @objc internal func configurationDidChange(_ notification: Notification) {
        // Load the values from defaults
        revert()
        // Notify the delegate
        if let delegate = delegate {
            delegate.whatColorIsItDefaultsConfigurationDidChange()
        }
    }
    
    /// Registers the default values.
    func register() {
        screenSaverDefaults?.register(defaults: [
            WhatColorIsItMainDisplayValueKey: mainLabelDisplayValue.rawValue,
            WhatColorIsItSecondaryDisplayValueKey: secondaryLabelDisplayValue.rawValue,
            WhatColorIsItInvertedKey: inverted
            ])
    }
    
    /// Saves the current values to disk and notifies the observers.
    func save() {
        if saveChanges {
            // Save all parameters to defaults.
            screenSaverDefaults?.set(mainLabelDisplayValue.rawValue, forKey: WhatColorIsItMainDisplayValueKey)
            screenSaverDefaults?.set(secondaryLabelDisplayValue.rawValue, forKey: WhatColorIsItSecondaryDisplayValueKey)
            screenSaverDefaults?.set(inverted, forKey: WhatColorIsItInvertedKey)
            notify()
        }
    }
    
    /// Reverts the current values to the values saved on disk and notifies the observers.
    func revert() {
        saveChanges = false
        // Revert all changes to properties.
        if let value: String = screenSaverDefaults?.string(forKey: WhatColorIsItMainDisplayValueKey) {
            if let type: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue(rawValue: value) {
                mainLabelDisplayValue = type
            }
        }
        if let value: String = screenSaverDefaults?.string(forKey: WhatColorIsItSecondaryDisplayValueKey) {
            if let type: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue(rawValue: value) {
                secondaryLabelDisplayValue = type
            }
        }
        if let value: Bool = screenSaverDefaults?.bool(forKey: WhatColorIsItInvertedKey) {
            inverted = value
        }
        saveChanges = true
    }
    
    /// Notifies the observers that the values changed.
    func notify() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: WhatColorIsItConfigurationDidChangeNotificationName), object: nil)
    }
    
}
