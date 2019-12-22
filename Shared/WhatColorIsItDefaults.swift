//
//  WhatColorIsItDefaults.swift
//  WhatColorIsItExtension
//
//  Created by Brandon McQuilkin on 12/21/19.
//  Copyright © 2019 Marxon13. All rights reserved.
//

import Foundation
import ScreenSaver
import os.log

/// The possible display values to display in the labels.
enum WhatColorIsItLabelDisplayValue: String, RawRepresentable {
    case hex = "Hex"
    case time = "Time"
}

/// The delegate protocol for the defaults.
protocol WhatColorIsItDefaultsDelegate {
    
    /// Notifies the delegate that the configuration did change.
    func whatColorIsItDefaultsConfigurationDidChange()
    
}

private let WhatColorIsItConfigurationDidChangeNotificationName = "WhatColorIsItConfigurationDidChangeNotification"
private let WhatColorIsItBundleIdentifier = "com.marxon13.WhatColorIsIt.WhatColorIsItExtension"

private let WhatColorIsItMainDisplayValueKey: String = "mainLabelDisplayValue"
private let WhatColorIsItShowSecondaryLabelKey: String = "showSecondaryLabel"

private let subsystem = "com.marxon13.WhatColorIsIt.WhatColorIsItExtension"
private let defaultsContainer = "3RCGQ2RRJJ.com.marxon13.WhatColorIsIt.Shared"

/// Stores user settings for the screen saver.
class WhatColorIsItDefaults: NSObject {
    
    //----------------------------
    // MARK: Properties
    //----------------------------
    
    /// The defaults used to load and save the values to/from disk.
    fileprivate var screenSaverDefaults: UserDefaults?
    
    /// The defaults delegate.
    var delegate: WhatColorIsItDefaultsDelegate?
    
    /// Whether or not to save the changes.
    fileprivate var saveChanges: Bool = true
    
    /// The logger to use when logging to console.
    var logger: OSLog = OSLog(subsystem: subsystem, category: "WhatColorIsItDefaults")
    
    /// What the main label will display on the screen.
    var mainLabelDisplayValue: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue.hex {
        didSet {
            os_log(.info, log: logger, "Main label display value updated: %{public}@", mainLabelDisplayValue.rawValue)
            save()
        }
    }
    
    /// Whether or not to show the secondary label.
    @objc var showSecondaryLabel: Bool = false {
        didSet {
            os_log(.info, log: logger, "Show secondary label updated: %{public}@", showSecondaryLabel ? "on" : "off")
            save()
        }
    }
    
    //----------------------------
    // MARK: Initalization
    //----------------------------
    
    override init() {
        super.init()
        screenSaverDefaults = UserDefaults(suiteName: defaultsContainer)
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
        os_log(.info, log: logger, "Configuration changed")
        // Load the values from defaults
        revert()
        // Notify the delegate
        if let delegate = delegate {
            delegate.whatColorIsItDefaultsConfigurationDidChange()
        }
    }
    
    /// Registers the default values.
    func register() {
        os_log(.info, log: logger, "Registering defaults")
        screenSaverDefaults?.register(defaults: [
            WhatColorIsItMainDisplayValueKey: mainLabelDisplayValue.rawValue,
            WhatColorIsItShowSecondaryLabelKey: showSecondaryLabel
            ])
    }
    
    /// Saves the current values to disk and notifies the observers.
    func save() {
        if saveChanges {
            os_log(.info, log: logger, "Saving changes")
            // Save all parameters to defaults.
            screenSaverDefaults?.set(mainLabelDisplayValue.rawValue, forKey: WhatColorIsItMainDisplayValueKey)
            screenSaverDefaults?.set(showSecondaryLabel, forKey: WhatColorIsItShowSecondaryLabelKey)
            notify()
        }
    }
    
    /// Reverts the current values to the values saved on disk and notifies the observers.
    func revert() {
        os_log(.info, log: logger, "Reverting changes to defaults")
        saveChanges = false
        // Revert all changes to properties.
        if let value: String = screenSaverDefaults?.string(forKey: WhatColorIsItMainDisplayValueKey) {
            if let type: WhatColorIsItLabelDisplayValue = WhatColorIsItLabelDisplayValue(rawValue: value) {
                mainLabelDisplayValue = type
            }
        }
        if let value: Bool = screenSaverDefaults?.bool(forKey: WhatColorIsItShowSecondaryLabelKey) {
            showSecondaryLabel = value
        }
        saveChanges = true
    }
    
    /// Notifies the observers that the values changed.
    func notify() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: WhatColorIsItConfigurationDidChangeNotificationName), object: nil)
    }
    
}
