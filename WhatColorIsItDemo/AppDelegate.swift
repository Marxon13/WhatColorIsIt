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
    
    var saverView: WhatColorIsItView!
    var timer: Timer?
    
    @IBAction func showConfiguration(_ sender: NSObject!) {
        if saverView.hasConfigureSheet() {
            if let window = window {
                window.beginSheet(saverView.configureSheet()!) { (result: NSModalResponse) -> Void in
                    
                }
            }
        }
    }
    
    // MARK: - Private
    
    func endSheet(_ sheet: NSWindow) {
        sheet.close()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        saverView = WhatColorIsItView(frame: window.contentView!.bounds, isPreview: false)
        // Set the resizing mask of the screen saver
        saverView.autoresizingMask = [NSAutoresizingMaskOptions.viewWidthSizable, NSAutoresizingMaskOptions.viewHeightSizable]
        // Add the view to the window
        window.contentView!.addSubview(saverView)
        
        // Start animating the screen saver
        saverView.startAnimation()
        timer = Timer(timeInterval: saverView.animationTimeInterval, target: saverView, selector: #selector(ScreenSaverView.animateOneFrame), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

