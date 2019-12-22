//
//  WhatColorIsItConfigurationViewController.swift
//  WhatColorIsItExtension
//
//  Created by Brandon McQuilkin on 12/21/19.
//  Copyright © 2019 Marxon13. All rights reserved.
//

import Foundation
import Cocoa
import ScreenSaver

/// The view controller that allows the user to configure the screen saver's settings.
class WhatColorIsItConfigurationViewController: ScreenSaverConfigurationViewController, WhatColorIsItDefaultsDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var mainLabelDisplayPopUpButton: NSPopUpButton!
    @IBOutlet var showSecondaryLabelCheckbox: NSButton!
    
    var defaults: WhatColorIsItDefaults = WhatColorIsItDefaults()
    
    // MARK: - Initalization
    
    override func nibName() -> Any! {
        return "WhatColorIsItConfigurationViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults.delegate = self
        whatColorIsItDefaultsConfigurationDidChange()
    }
    
    // MARK: - Actions
    
    @IBAction func mainLabelDisplayValueChanged(sender: NSPopUpButton) {
        defaults.mainLabelDisplayValue = sender.indexOfSelectedItem == 0 ? .hex : .time
    }
    
    @IBAction func showSecondaryLabelChanged(sender: NSButton) {
        defaults.showSecondaryLabel = sender.state == .on
    }
    
    // MARK: - Defaults
    
    func whatColorIsItDefaultsConfigurationDidChange() {
        showSecondaryLabelCheckbox.state = defaults.showSecondaryLabel ? .on : .off
        mainLabelDisplayPopUpButton.selectItem(at: defaults.mainLabelDisplayValue == .hex ? 0 : 1)
    }
    
}
