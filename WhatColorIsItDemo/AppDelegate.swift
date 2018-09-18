//
//  AppDelegate.swift
//  WhatColorIsItDemo
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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    var saverView: WhatColorIsItView!
    var timer: Timer?
    
    @IBAction func showConfiguration(_ sender: NSObject!) {
        if saverView.hasConfigureSheet {
            if let window = window {
                window.beginSheet(saverView.configureSheet!) { (result: NSApplication.ModalResponse) -> Void in
                    
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
        saverView.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
        // Add the view to the window
        window.contentView!.addSubview(saverView)
        
        // Start animating the screen saver
        saverView.startAnimation()
        timer = Timer(timeInterval: saverView.animationTimeInterval, target: saverView, selector: #selector(ScreenSaverView.animateOneFrame), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

