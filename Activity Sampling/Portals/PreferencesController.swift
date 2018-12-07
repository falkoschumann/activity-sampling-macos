//
//  PreferencesController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 05.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class PreferencesController: NSViewController {
    
    @IBOutlet weak var periodDurationTextField: NSTextField!
    @IBOutlet weak var periodDurationStepper: NSStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePeriod()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        updatePeriodDuration()
    }
    
    @IBAction func periodDurationChanged(_ sender: Any) {
        Preferences.shared.periodDuration = Double(periodDurationTextField.intValue * 60)
        updatePeriodDuration()
    }
    
    private func configurePeriod() {
        let periodFormatter = NumberFormatter()
        periodFormatter.allowsFloats = false
        periodDurationTextField.formatter = periodFormatter
    }
    
    private func updatePeriodDuration() {
        periodDurationTextField.intValue = Int32(Preferences.shared.periodDuration / 60)
    }
    
}
