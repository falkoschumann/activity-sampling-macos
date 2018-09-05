//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class ActivityLogController: NSViewController, ActivityLog {
    
    @IBOutlet weak var activityTitleLabel: NSTextField!
    @IBOutlet weak var activityTitle: NSTextField!
    @IBOutlet weak var logActivity: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    @IBOutlet var log: NSTextView!
    
    var delegate: ActivityLogDelegate?
    
    private let remainingTimeFormatter = createRemainingTimeFormatter()
    
    private var timestamp: Date?
    private var lastActivity: Activity?
    
    private static func createRemainingTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC");
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        App.shared.activityLog = self
    }
    
    @IBAction func logActivity(_ sender: Any) {
        let activity = Activity(timestamp: timestamp!, period: elapsedTime.maxValue, title: self.activityTitle.stringValue)
        delegate?.log(activity)
    }
    
    private func resetElapsedTime(_ duration: TimeInterval) {
        elapsedTime.maxValue = duration;
        updatePeriodProgess(0, duration);
    }
    
    private func updatePeriodProgess(_ elapsedTime: TimeInterval, _ remainingTime: TimeInterval) {
        self.elapsedTime.doubleValue = elapsedTime;
        self.remainingTime.stringValue = remainingTimeFormatter.string(from: Date(timeIntervalSinceReferenceDate: remainingTime))
    }
    
    private func askForCurrentActivity(timestamp: Date) {
        self.timestamp = timestamp
        activityTitleLabel.isEnabled = true
        activityTitle.isEnabled = true
        logActivity.isEnabled = true
        activityTitle.becomeFirstResponder()
    }
    
    private func ifIsNewDay(_ timestamp: Date, then: (Date) -> Void) {
        let calendar = Calendar.current;
        if lastActivity == nil || calendar.compare(lastActivity!.timestamp, to: timestamp, toGranularity: .day) != .orderedSame {
            then(timestamp)
        }
    }
    
    private func printDay(_ timestamp: Date) {
        let text = DateFormatter.localizedString(from: timestamp, dateStyle: .full, timeStyle: .none)
        log.textStorage?.append(NSAttributedString(string: text))
        log.textStorage?.append(NSAttributedString(string: "\n"))
    }
    
    private func printActivity(_ activity: Activity) {
        lastActivity = activity
        
        activityTitleLabel.isEnabled = false
        self.activityTitle.stringValue = activity.title
        self.activityTitle.isEnabled = false
        logActivity.isEnabled = false
        
        let timestamp = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .none, timeStyle: .short)
        log.textStorage?.append(NSAttributedString(string: timestamp))
        log.textStorage?.append(NSAttributedString(string: " - "))
        log.textStorage?.append(NSAttributedString(string: activity.title))
        log.textStorage?.append(NSAttributedString(string: "\n"))
    }
    
    // MARK: Activity Log
    
    func periodDidStart(duration: TimeInterval) {
        resetElapsedTime(duration)
    }
    
    func periodDidProgress(elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        updatePeriodProgess(elapsedTime, remainingTime);
    }
    
    func periodDidEnd(timestamp: Date) {
        askForCurrentActivity(timestamp: timestamp)
    }
    
    func activityDidLog(activity: Activity) {
        ifIsNewDay(activity.timestamp, then: printDay);
        printActivity(activity)
    }
    
}
