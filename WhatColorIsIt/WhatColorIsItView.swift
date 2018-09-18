//
//  WhatColorIsItView.swift
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

import Foundation
import Cocoa
import ScreenSaver

/// The view that displays the screen saver.
class WhatColorIsItView: ScreenSaverView, WhatColorIsItDefaultsDelegate {
    
    //----------------------------
    // MARK: Properties
    //----------------------------
    
    /// The defaults controller.
    fileprivate let defaults: WhatColorIsItDefaults = WhatColorIsItDefaults()
    
    /// The date formatter that converts the current time to a hex string.
    fileprivate let hexTimeFormatter: DateFormatter = DateFormatter()
    
    /// The date formatter that converts the current time to a string.
    fileprivate let timeFormatter: DateFormatter = DateFormatter()
    
    /// The current date.
    fileprivate var currentDate: Date = Date()
    
    /// The main font.
    fileprivate var mainFont: NSFont = NSFont.monospacedDigitSystemFont(ofSize: 0.0, weight: NSFont.Weight.ultraLight)
    
    /// The paragraph style.
    fileprivate let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
    
    /// The secondary font.
    fileprivate var secondaryFont: NSFont = NSFont.monospacedDigitSystemFont(ofSize: 0.0, weight: NSFont.Weight.ultraLight)
    
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
        paragraphStyle.alignment = NSTextAlignment.center
        
        // Load the defauts
        loadFromDefaults()
    }
    
    //----------------------------
    // MARK: Configuration
    //----------------------------
    
    func whatColorIsItDefaultsConfigurationDidChange() {
        loadFromDefaults()
    }
    
    fileprivate func loadFromDefaults() {
        // Refresh the display.
        needsDisplay = true
    }
    
    //----------------------------
    // MARK: Screen Saver
    //----------------------------
    
    override func animateOneFrame() {
        // Update the display with the current date.
        currentDate = Date()
        setNeedsDisplay(bounds)
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        struct Holder {
            static var controller: WhatColorIsItConfigurationWindowController = WhatColorIsItConfigurationWindowController()
        }
        
        Holder.controller.loadWindow()
        return Holder.controller.window
    }
    
    //----------------------------
    // MARK: Drawing and Layout
    //----------------------------
    
    override func draw(_ rect: NSRect) {
        // Draw the background color.
        super.draw(rect)
        
        // Update the font size if necessary
        updateFontIfNecessary()
        
        // Get the strings to display
        let hexString: String = hexTimeFormatter.string(from: currentDate)
        let timeString: String = timeFormatter.string(from: currentDate)
        let mainString: String = defaults.mainLabelDisplayValue == .None ? "" : (defaults.mainLabelDisplayValue == .Hex ? hexString : timeString)
        let secondaryString: String = defaults.secondaryLabelDisplayValue == .None ? "" : (defaults.secondaryLabelDisplayValue == .Hex ? hexString : timeString)
        
        // Set the colors to display
        let hexColor: NSColor = colorFromHexString(hexString)!
        let textColor: NSColor = !defaults.inverted ? NSColor.white : hexColor
        let backgroundColor: NSColor = !defaults.inverted ? hexColor : NSColor.white
        
        // Draw the background
        backgroundColor.setFill()
        rect.fill()
        
        // Draw the main text
        let mainAttributes: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.font: mainFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let mainSize: NSSize = (mainString as NSString).size(withAttributes: mainAttributes)
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
        
        (mainString as NSString).draw(in: mainRect, withAttributes: mainAttributes)
        
        // Draw the secondary Text
        let secondaryAttributes: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.font: secondaryFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let secondarySize: NSSize = (secondaryString as NSString).size(withAttributes: secondaryAttributes)
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
        
        (secondaryString as NSString).draw(in: secondaryRect, withAttributes: secondaryAttributes)
    }
    
    fileprivate func updateFontIfNecessary() {
        if mainFont.pointSize != bounds.size.height / 7.0 {
            mainFont = NSFont.monospacedDigitSystemFont(ofSize: bounds.size.height / 7.0, weight: NSFont.Weight.ultraLight)
            secondaryFont = NSFont.monospacedDigitSystemFont(ofSize: bounds.size.height / 21.0, weight: NSFont.Weight.ultraLight)
        }
    }
    
    fileprivate func colorFromHexString(_ string: String) -> NSColor? {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if string.hasPrefix("#") {
            let index   = string.index(string.startIndex, offsetBy: 1)
            let hex     = string.suffix(from: index)
            let scanner = Scanner(string: String(hex))
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
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
