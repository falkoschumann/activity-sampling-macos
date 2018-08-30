//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class ActivityLogController: NSViewController, ActivityLogDelegate {
    
    @IBOutlet weak var activityLabel: NSTextField!
    @IBOutlet weak var activity: NSTextField!
    @IBOutlet weak var logActivity: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    @IBOutlet var log: NSTextView!
    
    private let remainingTimeFormatter = createRemainingTimeFormatter()
    
    private let activityLog = ActivityLog()
    private var lastActivity: Activity?
    
    static func createRemainingTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC");
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityLog.delegate = self
        activityLog.start()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func logActivity(_ sender: Any) {
        activityLog.logCurrentActivity(activity.stringValue)
        activityLabel.isEnabled = false
        activity.isEnabled = false
        logActivity.isEnabled = false
    }
    
    private func resetElapsedTime(_ duration: TimeInterval) {
        elapsedTime.maxValue = duration;
        updatePeriodProgess(0, duration);
    }
    
    private func updatePeriodProgess(_ elapsedTime: TimeInterval, _ remainingTime: TimeInterval) {
        self.elapsedTime.doubleValue = elapsedTime;
        self.remainingTime.stringValue = remainingTimeFormatter.string(from: Date(timeIntervalSinceReferenceDate: remainingTime))
    }
    
    private func askForCurrentActivity() {
        activityLabel.isEnabled = true
        activity.isEnabled = true
        logActivity.isEnabled = true
        activity.becomeFirstResponder()
    }
    
    private func ifIsNewDay(timestamp: Date, then: (Date) -> Void) {
        let calendar = Calendar.current;
        if (lastActivity == nil || calendar.compare(lastActivity!.timestamp, to: timestamp, toGranularity: .day) != .orderedSame) {
            then(timestamp)
        }
    }
    
    private func printDay(_ timestamp: Date) {
        let text = DateFormatter.localizedString(from: timestamp, dateStyle: .full, timeStyle: .none)
        log.textStorage?.append(NSAttributedString(string: text))
        log.textStorage?.append(NSAttributedString(string: "\n"))
    }
    
    private func printActivity(_ activity: Activity) {
        let timestamp = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .none, timeStyle: .short)
        log.textStorage?.append(NSAttributedString(string: timestamp))
        log.textStorage?.append(NSAttributedString(string: " - "))
        log.textStorage?.append(NSAttributedString(string: activity.title))
        log.textStorage?.append(NSAttributedString(string: "\n"))
    }
    
    // MARK: Activity Log Delegate
    
    func periodDidStart(_ activityLog: ActivityLog, duration: TimeInterval) {
        resetElapsedTime(duration)
    }
    
    func periodDidProgress(_ activityLog: ActivityLog, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        updatePeriodProgess(elapsedTime, remainingTime);
    }
    
    func periodDidEnd(_ activityLog: ActivityLog) {
        askForCurrentActivity()
    }
    
    func activityDidLog(_ activityLog: ActivityLog, activity: Activity) {
        ifIsNewDay(timestamp: activity.timestamp, then: printDay);
        printActivity(activity)
        lastActivity = activity
    }
    
}
