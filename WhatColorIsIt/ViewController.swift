//
//  ViewController.swift
//  WhatColorIsIt
//
//  Created by Brandon McQuilkin on 12/21/19.
//  Copyright © 2019 Marxon13. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, WhatColorIsItDefaultsDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var configurationContainerView: NSView!
    @IBOutlet var screenSaverView: WhatColorIsItView!
    
    @IBOutlet var mainLabelDisplayPopUpButton: NSPopUpButton!
    @IBOutlet var showSecondaryLabelCheckbox: NSButton!
    
    var defaults: WhatColorIsItDefaults = WhatColorIsItDefaults()
    
    // MARK: - Initalization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSaverView.startAnimation()
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
