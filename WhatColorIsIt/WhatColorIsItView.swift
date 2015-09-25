//
//  WhatColorIsItView.swift
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

import Foundation
import Cocoa
import ScreenSaver

class WhatColorIsItView: ScreenSaverView, WhatColorIsItDefaultsDelegate {
    
    //----------------------------
    // MARK: Properties
    //----------------------------
    
    /**
    The defaults controller.
    */
    private let defaults: WhatColorIsItDefaults = WhatColorIsItDefaults()
    
    /**
    The date formatter that converts the current time to a hex string.
    */
    private let hexTimeFormatter: NSDateFormatter = NSDateFormatter()
    
    /**
    The date formatter that converts the current time to a string.
    */
    private let timeFormatter: NSDateFormatter = NSDateFormatter()
    
    /**
    The current date.
    */
    private var currentDate: NSDate = NSDate()
    
    /**
    The main font.
    */
    private var mainFont: NSFont = NSFont.monospacedDigitSystemFontOfSize(0.0, weight: NSFontWeightUltraLight)
    
    /**
    The paragraph style.
    */
    private let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
    
    /**
    The secondary font.
    */
    private var secondaryFont: NSFont = NSFont.monospacedDigitSystemFontOfSize(0.0, weight: NSFontWeightUltraLight)
    
    //----------------------------
    // MARK: Initalization
    //----------------------------
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        sharedSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }
    
    func sharedSetup() {
        // Set the screen saver properties
        animationTimeInterval = 1.0
        
        // Set the defaults delegate
        defaults.delegate = self
        
        // Set the time formatter
        hexTimeFormatter.dateFormat = "'#'HHmmss"
        timeFormatter.dateFormat = "HH:mm:ss"
        
        // Set the paragraph style
        paragraphStyle.alignment = NSTextAlignment.Center
        
        // Load the defauts
        loadFromDefaults()
    }
    
    //----------------------------
    // MARK: Configuration
    //----------------------------
    
    func whatColorIsItDefaultsConfigurationDidChange() {
        loadFromDefaults()
    }
    
    private func loadFromDefaults() {
        // Refresh the display.
        needsDisplay = true
    }
    
    //----------------------------
    // MARK: Screen Saver
    //----------------------------
    
    override func animateOneFrame() {
        // Update the display with the current date.
        currentDate = NSDate()
        setNeedsDisplayInRect(bounds)
    }
    
    override func hasConfigureSheet() -> Bool {
        return true
    }
    
    override func configureSheet() -> NSWindow? {
        struct Holder {
            static var controller: WhatColorIsItConfigurationWindowController = WhatColorIsItConfigurationWindowController()
        }
        
        Holder.controller.loadWindow()
        return Holder.controller.window
    }
    
    //----------------------------
    // MARK: Drawing and Layout
    //----------------------------
    
    override func drawRect(rect: NSRect) {
        // Draw the background color.
        super.drawRect(rect)
        
        // Update the font size if necessary
        updateFontIfNecessary()
        
        // Get the strings to display
        let hexString: String = hexTimeFormatter.stringFromDate(currentDate)
        let timeString: String = timeFormatter.stringFromDate(currentDate)
        let mainString: String = defaults.mainLabelDisplayValue == .None ? "" : (defaults.mainLabelDisplayValue == .Hex ? hexString : timeString)
        let secondaryString: String = defaults.secondaryLabelDisplayValue == .None ? "" : (defaults.secondaryLabelDisplayValue == .Hex ? hexString : timeString)
        
        // Set the colors to display
        let hexColor: NSColor = colorFromHexString(hexString)!
        let textColor: NSColor = !defaults.inverted ? NSColor.whiteColor() : hexColor
        let backgroundColor: NSColor = !defaults.inverted ? hexColor : NSColor.whiteColor()
        
        // Draw the background
        backgroundColor.setFill()
        NSRectFill(rect)
        
        // Draw the main text
        let mainAttributes: [String: AnyObject] = [
            NSFontAttributeName: mainFont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor
        ]
        let mainSize: NSSize = (mainString as NSString).sizeWithAttributes(mainAttributes)
        let mainRect: NSRect = defaults.secondaryLabelDisplayValue != .None ?
            NSMakeRect(
                bounds.origin.x,
                bounds.origin.y + (bounds.size.height / 2.0),
                bounds.size.width,
                mainSize.height) :
            NSMakeRect(
                bounds.origin.x,
                (bounds.size.height - mainSize.height) / 2.0,
                bounds.size.width,
                mainSize.height)
        
        (mainString as NSString).drawInRect(mainRect, withAttributes: mainAttributes)
        
        // Draw the secondary Text
        let secondaryAttributes: [String: AnyObject] = [
            NSFontAttributeName: secondaryFont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor
        ]
        let secondarySize: NSSize = (secondaryString as NSString).sizeWithAttributes(secondaryAttributes)
        let secondaryRect: NSRect = defaults.mainLabelDisplayValue != .None ?
            NSMakeRect(
            bounds.origin.x,
            (bounds.size.height / 2.0) - mainSize.height,
            bounds.size.width,
                secondarySize.height) :
            NSMakeRect(
                bounds.origin.x,
                (bounds.size.height - secondarySize.height) / 2.0,
                bounds.size.width,
                secondarySize.height)
        
        (secondaryString as NSString).drawInRect(secondaryRect, withAttributes: secondaryAttributes)
    }
    
    private func updateFontIfNecessary() {
        if mainFont.pointSize != bounds.size.height / 7.0 {
            mainFont = NSFont.monospacedDigitSystemFontOfSize(bounds.size.height / 7.0, weight: NSFontWeightUltraLight)
            secondaryFont = NSFont.monospacedDigitSystemFontOfSize(bounds.size.height / 21.0, weight: NSFontWeightUltraLight)
        }
    }
    
    private func colorFromHexString(string: String) -> NSColor? {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if string.hasPrefix("#") {
            let index   = string.startIndex.advancedBy(1)
            let hex     = string.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    Swift.print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                    return nil
                }
            } else {
                Swift.print("Scan hex error")
                return nil
            }
        } else {
            Swift.print("Invalid RGB string, missing '#' as prefix")
            return nil
        }
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
