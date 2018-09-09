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
    
    @IBOutlet weak var activityLogFileTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePeriod()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadPreferences()
    }
    
    @IBAction func periodDurationChanged(_ sender: Any) {
        Preferences.shared.periodDuration = Double(periodDurationTextField.intValue * 60)
    }
    
    @IBAction func logFileChanged(_ sender: Any?) {
        Preferences.shared.activityLogFile = URL(fileURLWithPath: activityLogFileTextField.stringValue)
    }
    
    @IBAction func chooseLogFile(_ sender: Any) {
        let panel = NSSavePanel()
        panel.title = "Save activity log file"
        panel.prompt = "Save"
        panel.worksWhenModal = true
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = "activity-log.csv"
        panel.runModal()
        if let url = panel.url {
            activityLogFileTextField.stringValue = url.path
            logFileChanged(nil)
        }
    }
    
    private func configurePeriod() {
        let periodFormatter = NumberFormatter()
        periodFormatter.allowsFloats = false
        periodDurationTextField.formatter = periodFormatter
    }
    
    private func loadPreferences() {
        periodDurationTextField.intValue = Int32(Preferences.shared.periodDuration / 60)
        activityLogFileTextField.stringValue = Preferences.shared.activityLogFile.path
    }
    
}
