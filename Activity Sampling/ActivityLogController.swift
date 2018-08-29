//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class ActivityLogController: NSViewController, ClockDelegate, PeriodDelegate {
    
    @IBOutlet weak var currentActivityLabel: NSTextField!
    @IBOutlet weak var currentActivity: NSTextField!
    @IBOutlet weak var logCurrentActivity: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    private let clock = Clock()
    private let period = Period()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clock.delegate = self
        period.delegate = self
        period.start()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // MARK: Clock Delegate
    
    func clockDidTick(_ clock: Clock, currentTime: Date) {
        period.check(currentTime: currentTime)
    }
    
    // MARK: Period Delegate
    
    func periodDidStart(_ period: Period) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC");
        remainingTime.stringValue = formatter.string(from: Date(timeIntervalSinceReferenceDate: period.duration))
        
        elapsedTime.maxValue = period.duration;
        elapsedTime.doubleValue = 0;
    }
    
    func periodDidProgress(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC");
        self.remainingTime.stringValue = formatter.string(from: Date(timeIntervalSinceReferenceDate: remainingTime))
        
        self.elapsedTime.doubleValue = elapsedTime
    }
    
    func periodDidEnd(_ period: Period, timestamp: Date) {
        currentActivityLabel.isEnabled = true
        currentActivity.isEnabled = true
        logCurrentActivity.isEnabled = true
        
        currentActivity.becomeFirstResponder()
    }
    
}
