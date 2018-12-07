//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

protocol ActivityLogDelegate : class {
    func logged(activity: Activity)
}

class ActivityLogController: NSViewController {
    
    weak var delegate: ActivityLogDelegate?
    
    @IBOutlet weak var activityTitleLabel: NSTextField!
    @IBOutlet weak var activityTitle: NSTextField!
    @IBOutlet weak var logActivityButton: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    @IBOutlet var log: NSTextView!
    
    internal var timestamp: Date?
    internal var lastActivity: Activity?
    
    internal var periodDuration: TimeInterval {
        get { return elapsedTime.maxValue }
        set { elapsedTime.maxValue = newValue }
    }
    
    @IBAction func logActivity(_ sender: Any) {
        lastActivity = Activity(timestamp: timestamp!, duration: periodDuration, title: activityTitle.stringValue)
        disableFormular()
        activityTitle.stringValue = lastActivity!.title
        printCurrentDate(activity: lastActivity!)
        printActivity(lastActivity!)
        delegate?.logged(activity: lastActivity!)
    }
    
    func startPeriod(duration: TimeInterval) {
        periodDuration = duration
        progressPeriod(elapsedTime: 0, remainingTime: duration)
    }
    
    func progressPeriod(elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        self.elapsedTime.doubleValue = elapsedTime
        
        let time = Date(timeIntervalSinceReferenceDate: remainingTime)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC")
        self.remainingTime.stringValue = formatter.string(from: time)
    }
    
    func endPeriod(timestamp: Date) {
        self.timestamp = timestamp
        enableFormular()
    }
    
    func enableFormular() {
        activityTitleLabel.isEnabled = true
        activityTitle.isEnabled = true
        logActivityButton.isEnabled = true
        
        activityTitle.becomeFirstResponder()
    }
    
    func disableFormular() {
        activityTitleLabel.isEnabled = false
        activityTitle.isEnabled = false
        logActivityButton.isEnabled = false
    }
    
    private func printCurrentDate(activity: Activity) {
        if sameDay(activity: activity) {
            return
        }
        let date = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .full, timeStyle: .none)
        log.textStorage?.append(NSAttributedString(string: date + "\n",
                                                   attributes: [.foregroundColor: NSColor.textColor]))
    }
    
    private func sameDay(activity: Activity) -> Bool {
        guard lastActivity != nil else {
            return false
        }
        return Calendar.current.compare(lastActivity!.timestamp, to: activity.timestamp, toGranularity: .day) != .orderedSame
    }
    
    private func printActivity(_ activity: Activity){
        let timestamp = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .none, timeStyle: .short)
        log.textStorage?.append(NSAttributedString(string: timestamp + " - " + activity.title + "\n",
                                                   attributes: [.foregroundColor: NSColor.textColor]))
    }
    
}
