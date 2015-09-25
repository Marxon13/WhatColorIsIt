//
//  AppDelegate.swift
//  WhatColorIsItDemo
//
//  Created by Brandon McQuilkin on 9/24/15.
//  Copyright © 2015 BrandonMcQuilkin. All rights reserved.
//

import Cocoa
import ScreenSaver

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    let saverView: WhatColorIsItView = WhatColorIsItView()
    var timer: NSTimer?
    
    @IBAction func showConfiguration(sender: NSObject!) {
        if saverView.hasConfigureSheet() {
            if let window = window {
                window.beginSheet(saverView.configureSheet()!) { (result: NSModalResponse) -> Void in
                    
                }
            }
        }
    }
    
    
    // MARK: - Private
    
    func endSheet(sheet: NSWindow) {
        sheet.close()
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Set the resizing mask of the screen saver
        saverView.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
        // Add the view to the window
        saverView.frame = window.contentView!.bounds
        window.contentView!.addSubview(saverView)
        
        // Start animating the screen saver
        saverView.startAnimation()
        timer = NSTimer(timeInterval: saverView.animationTimeInterval, target: saverView, selector: "animateOneFrame", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

