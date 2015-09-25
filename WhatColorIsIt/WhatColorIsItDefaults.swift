//
//  WhatColorIsItDefaults.swift
//  WhatColorIsIt
//
// Copyright (c) 2015 Brandon McQuilkin
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

/**
The possible display values to display in the labels.
*/
enum WhatColorIsItLabelDisplayValue: String, RawRepresentable {
    case Hex = "Hex (#120000)"
    case Time = "Time (12:00:00)"
    case None = "None"
    
    static func allValues() -> [WhatColorIsItLabelDisplayValue] {
        return [WhatColorIsItLabelDisplayValue.Hex, WhatColorIsItLabelDisplayValue.Time, WhatColorIsItLabelDisplayValue.None]
    }
}

/**
The delegate protocol for the defaults.
*/
protocol WhatColorIsItDefaultsDelegate {
    
    /**
    Notifies the delegate that the configuration did change.
    */
    func whatColorIsItDefaultsConfigurationDidChange()
}

let WhatColorIsItConfigurationDidChangeNotificationName = "WhatColorIsItConfigurationDidChangeNotification"
let WhatColorIsItBundleIdentifier = "com.BrandonMcQuilkin.WhatColorIsIt"

let WhatColorIsItMainDisplayValueKey: String = "mainLabelDisplayValue"
let WhatColorIsItSecondaryDisplayValueKey: String = "secondaryLabelDisplayValue"
let WhatColorIsItInvertedKey: String = "inverted"

class WhatColorIsItDefaults: NSObject {
    
    //----------------------------
    // MARK: Properties
    //----------------------------
    
    /**
    The defaults used to load and save the values to/from disk.
    */
    private var screenSaverDefaults: ScreenSaverDefaults?
    
    /**
    The defaults delegate.
    */
    var delegate: WhatColorIsItDefaultsDelegate?
    
    /**
    Whether or not to save the changes.
    */
    private var saveChanges: Bool = true
    
    /**
    What the main label will display on the screen.
    */
    var mainLabelDisplayValue: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue.Time {
        didSet {
            save()
        }
    }
    
    /**
    What the secondary label will display on the screen.
    */
    var secondaryLabelDisplayValue: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue.Hex {
        didSet {
            save()
        }
    }
    
    /**
    Whether or not to display inverted.
    */
    var inverted: Bool = false {
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "configurationDidChange:", name: WhatColorIsItConfigurationDidChangeNotificationName, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WhatColorIsItConfigurationDidChangeNotificationName, object: nil)
    }
    
    //----------------------------
    // MARK: Actions
    //----------------------------
    
    internal func configurationDidChange(notification: NSNotification) {
        // Load the values from defaults
        revert()
        // Notify the delegate
        if let delegate = delegate {
            delegate.whatColorIsItDefaultsConfigurationDidChange()
        }
    }
    
    /**
    Registers the default values.
    */
    func register() {
        screenSaverDefaults?.registerDefaults([
            WhatColorIsItMainDisplayValueKey: mainLabelDisplayValue.rawValue,
            WhatColorIsItSecondaryDisplayValueKey: secondaryLabelDisplayValue.rawValue,
            WhatColorIsItInvertedKey: inverted
            ])
    }
    
    /**
    Saves the current values to disk and notifies the observers.
    */
    func save() {
        if saveChanges {
            // Save all parameters to defaults.
            screenSaverDefaults?.setObject(mainLabelDisplayValue.rawValue, forKey: WhatColorIsItMainDisplayValueKey)
            screenSaverDefaults?.setObject(secondaryLabelDisplayValue.rawValue, forKey: WhatColorIsItSecondaryDisplayValueKey)
            screenSaverDefaults?.setBool(inverted, forKey: WhatColorIsItInvertedKey)
            notify()
        }
    }
    
    /**
    Reverts the current values to the values saved on disk and notifies the observers.
    */
    func revert() {
        saveChanges = false
        // Revert all changes to properties.
        if let value: String = screenSaverDefaults?.stringForKey(WhatColorIsItMainDisplayValueKey) {
            if let type: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue(rawValue: value) {
                mainLabelDisplayValue = type
            }
        }
        if let value: String = screenSaverDefaults?.stringForKey(WhatColorIsItSecondaryDisplayValueKey) {
            if let type: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue(rawValue: value) {
                secondaryLabelDisplayValue = type
            }
        }
        if let value: Bool = screenSaverDefaults?.boolForKey(WhatColorIsItInvertedKey) {
            inverted = value
        }
        saveChanges = true
    }
    
    /**
    Notifies the observers that the values changed.
    */
    func notify() {
        NSNotificationCenter.defaultCenter().postNotificationName(WhatColorIsItConfigurationDidChangeNotificationName, object: nil)
    }
}
