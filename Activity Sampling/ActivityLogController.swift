//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class ActivityLogController: NSViewController, ActivityLogDelegate {
    
    @IBOutlet weak var currentActivityLabel: NSTextField!
    @IBOutlet weak var currentActivity: NSTextField!
    @IBOutlet weak var logCurrentActivity: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    private let remainingTimeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityLog = ActivityLog()
        activityLog.delegate = self
        activityLog.start()
        
        remainingTimeFormatter.dateStyle = .none
        remainingTimeFormatter.timeStyle = .medium
        remainingTimeFormatter.timeZone = TimeZone(identifier: "UTC");
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func resetElapsedTime(_ duration: TimeInterval) {
        elapsedTime.maxValue = duration;
        updatePeriodProgess(0, duration);
    }
    
    private func updatePeriodProgess(_ elapsedTime: TimeInterval, _ remainingTime: TimeInterval) {
        self.elapsedTime.doubleValue = elapsedTime;
        self.remainingTime.stringValue = remainingTimeFormatter.string(from: Date(timeIntervalSinceReferenceDate: remainingTime))
    }
    
    private func askForCurrentActivity(_ timestamp: Date) {
        currentActivityLabel.isEnabled = true
        currentActivity.isEnabled = true
        logCurrentActivity.isEnabled = true
        currentActivity.becomeFirstResponder()
    }
    
    // MARK: Activity Log Delegate
    
    func periodDidStart(_ activityLog: ActivityLog, duration: TimeInterval) {
        resetElapsedTime(duration)
    }
    
    func periodDidProgress(_ activityLog: ActivityLog, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        updatePeriodProgess(elapsedTime, remainingTime);
    }
    
    func periodDidEnd(_ activityLog: ActivityLog, timestamp: Date) {
        askForCurrentActivity(timestamp)
    }
    
}
