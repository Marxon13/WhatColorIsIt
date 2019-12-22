//
//  WhatColorIsItViewController.swift
//  WhatColorIsItExtension
//
//  Created by Brandon McQuilkin on 12/21/19.
//  Copyright © 2019 Marxon13. All rights reserved.
//

import Foundation
import Cocoa
import ScreenSaver

/// The view controller that displays the screen saver view.
@objc public class WhatColorIsItViewController: ScreenSaverViewController {
    
    public override func loadView() {
        view = WhatColorIsItView(frame: WhatColorIsItViewController.expectedViewFrame(), isPreview: false)!
    }
    
}
