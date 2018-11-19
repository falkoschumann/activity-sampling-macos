//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

protocol ActivityLogDelegate {
    func log(_ activityLog: ActivityLogController, activity: Activity)
}

class ActivityLogController: NSViewController {
    
    var delegate: ActivityLogDelegate?
    
    @IBOutlet weak var activityTitleLabel: NSTextField!
    @IBOutlet weak var activityTitle: NSTextField!
    @IBOutlet weak var logActivity: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    @IBOutlet var log: NSTextView!
    
    private var timestamp: Date?
    private var lastActivity: Activity?
    
    @IBAction func logActivity(_ sender: Any) {
        let activity = Activity(timestamp: timestamp!, duration: elapsedTime.maxValue, title: activityTitle.stringValue)
        lastActivity = activity
        
        disableFormular(activity: activity)
        printCurrentDate(activity: activity)
        printActivity(activity)
        
        delegate?.log(self, activity: activity)
    }
    
    func startPeriod(duration: TimeInterval) {
        elapsedTime.maxValue = duration
        progressPeriod(elapsedTime: 0, remainingTime: duration)
    }
    
    func progressPeriod(elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        self.elapsedTime.doubleValue = elapsedTime
        let time = Date(timeIntervalSinceReferenceDate: remainingTime)
        self.remainingTime.stringValue = DateFormatter.localizedString(from: time, dateStyle: .none, timeStyle: .medium)
    }
    
    func endPeriod(timestamp: Date) {
        self.timestamp = timestamp
        enableFormular()
    }
    
    private static func createRemainingTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }
    
    private func enableFormular() {
        activityTitleLabel.isEnabled = true
        activityTitle.isEnabled = true
        logActivity.isEnabled = true
        activityTitle.becomeFirstResponder()
    }
    
    private func disableFormular(activity: Activity) {
        activityTitleLabel.isEnabled = false
        activityTitle.stringValue = activity.title
        activityTitle.isEnabled = false
        logActivity.isEnabled = false
    }
    
    private func printCurrentDate(activity: Activity) {
        if sameDay(activity: activity) {
            return
        }
        let date = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .full, timeStyle: .none)
        log.textStorage?.append(NSAttributedString(string: date))
        log.textStorage?.append(NSAttributedString(string: "\n"))
    }
    
    private func sameDay(activity: Activity) -> Bool {
        guard lastActivity != nil else {
            return false
        }
        return Calendar.current.compare(lastActivity!.timestamp, to: activity.timestamp, toGranularity: .day) != .orderedSame
    }
    
    private func printActivity(_ activity: Activity){
        let timestamp = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .none, timeStyle: .short)
        log.textStorage?.append(NSAttributedString(string: timestamp))
        log.textStorage?.append(NSAttributedString(string: " - "))
        log.textStorage?.append(NSAttributedString(string: activity.title))
        log.textStorage?.append(NSAttributedString(string: "\n"))
    }
    
}
