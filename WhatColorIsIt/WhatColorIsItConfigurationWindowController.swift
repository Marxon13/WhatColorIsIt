//
//  WhatColorIsItConfigurationWindowController.swift
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

/// The window controller that allows the user to configure the screen saver.
class WhatColorIsItConfigurationWindowController: NSWindowController {

    //----------------------------
    // MARK: Properties
    //----------------------------
    
    /// The defaults object instantiated by the nib.
    @IBOutlet weak var defaults: WhatColorIsItDefaults?
    
    /// Controls the list of objects to display in the main popup.
    @IBOutlet weak var mainLabelArrayController: NSArrayController?
    
    /// Controls the list of objects to display in the secondary popup.
    @IBOutlet weak var secondaryLabelArrayController: NSArrayController?
    
    /// The values to display in the array controllers.
    @objc let options: [String] = WhatColorIsItLabelDisplayValue.allValues().map {$0.rawValue}
    
    /// Converts the value selected by the main popover button to the proper enum value, and sets it to the defaults.
    @objc var mainSelectionIndex: String {
        get {
            if let defaults = defaults {
                return defaults.mainLabelDisplayValue.rawValue
            }
            return WhatColorIsItLabelDisplayValue.None.rawValue
        }
        set(newValue) {
            if let value = WhatColorIsItLabelDisplayValue(rawValue: newValue) {
                defaults?.mainLabelDisplayValue = value
            }
        }
    }
    
    /// Converts the value selected by the secondary popover button to the proper enum value, and sets it to the defaults.
    @objc var secondarySelectionIndex: String {
        get {
            if let defaults = defaults {
                return defaults.secondaryLabelDisplayValue.rawValue
            }
            return WhatColorIsItLabelDisplayValue.None.rawValue
        }
        set(newValue) {
            if let value = WhatColorIsItLabelDisplayValue(rawValue: newValue) {
                defaults?.secondaryLabelDisplayValue = value
            }
        }
    }
    
    override var windowNibName: String {
        return "WhatColorIsItConfigurationWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    //----------------------------
    // MARK: Actions
    //----------------------------
    
    @IBAction func close(_ sender: AnyObject) {
        // Close
        if let window = window {
            window.sheetParent?.endSheet(window, returnCode: NSApplication.ModalResponse.OK)
        }
    }

}
