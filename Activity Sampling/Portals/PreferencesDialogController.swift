//
//  PreferencesController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 05.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class PreferencesDialogController: NSViewController {
    
    @IBOutlet weak var periodDurationTextField: NSTextField!
    @IBOutlet weak var periodDurationStepper: NSStepper!
    
    private let head = Head.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPeriodDuration()
    }
    
    private func initPeriodDuration() {
        let periodFormatter = NumberFormatter()
        periodFormatter.allowsFloats = false
        periodDurationTextField.formatter = periodFormatter
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadPeriodDuration()
    }
    
    private func loadPeriodDuration() {
        periodDurationTextField.intValue = Int32(head.periodDuration / 60)
    }
    
    @IBAction func periodDurationChanged(_ sender: Any) {
        storePeriodDuration()
        loadPeriodDuration()
    }
    
    private func storePeriodDuration() {
        head.periodDuration = Double(periodDurationTextField.intValue * 60)
    }
    
}
