//
//  WhatColorIsItView.swift
//  WhatColorIsItExtension
//
//  Created by Brandon McQuilkin on 12/21/19.
//  Copyright © 2019 Marxon13. All rights reserved.
//

import Foundation
import Cocoa
import ScreenSaver

/// The primary view of the screen saver.
@objc public class WhatColorIsItView: ScreenSaverExtensionView, WhatColorIsItDefaultsDelegate {
    
    // MARK: - Properties
    
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
    
    /// The timer that updates the view.
    fileprivate var timer: Timer?
    
    /// The defaults to pull the settings from.
    fileprivate var defaults: WhatColorIsItDefaults = WhatColorIsItDefaults()
    
    // MARK: - Initalization
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        sharedSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }
    
    func sharedSetup() {
        // Set the time formatter
        hexTimeFormatter.dateFormat = "'#'HHmmss"
        timeFormatter.dateFormat = "HH:mm:ss"
        
        // Set the paragraph style
        paragraphStyle.alignment = NSTextAlignment.center
        
        // Respond to any changes in configuration
        defaults.delegate = self
    }
    
    // MARK: - Animation
    
    public override func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (_) in
            self?.currentDate = Date()
            self?.setNeedsDisplay(self?.bounds ?? .zero)
        })
    }
    
    public override func stopAnimation() {
        timer = nil
    }
    
    // MARK: - Drawing
    
    override public func draw(_ rect: NSRect) {
        // Draw the background color.
        super.draw(rect)
        
        // Update the font size if necessary
        updateFontIfNecessary()
        
        // Get the strings to display
        let hexString: String = hexTimeFormatter.string(from: currentDate)
        let timeString: String = timeFormatter.string(from: currentDate)
        let mainString: String = defaults.mainLabelDisplayValue == .hex ? hexString : timeString
        let secondaryString: String = defaults.mainLabelDisplayValue == .hex ? timeString : hexString
        
        // Set the colors to display
        let hexColor: NSColor = colorFromHexString(hexString)!
        let textColor: NSColor = NSColor.white
        let backgroundColor: NSColor = hexColor
        
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
        let mainRect: NSRect = defaults.showSecondaryLabel ?
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
        if defaults.showSecondaryLabel {
            let secondaryAttributes: [NSAttributedString.Key: AnyObject] = [
                NSAttributedString.Key.font: secondaryFont,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: textColor
            ]
            let secondarySize: NSSize = (secondaryString as NSString).size(withAttributes: secondaryAttributes)
            let secondaryRect: NSRect = NSMakeRect(
                bounds.origin.x,
                (bounds.size.height / 2.0) - mainSize.height,
                bounds.size.width,
                secondarySize.height)
            
            
            (secondaryString as NSString).draw(in: secondaryRect, withAttributes: secondaryAttributes)
        }
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
    
    // MARK: - Defaults
    
    func whatColorIsItDefaultsConfigurationDidChange() {
        setNeedsDisplay(bounds)
    }

}
