//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class ActivityLogDialogController: NSViewController, PeriodDelegate {
    
    @IBOutlet weak var activityTitleLabel: NSTextField!
    @IBOutlet weak var activityTitle: NSTextField!
    @IBOutlet weak var logActivityButton: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    @IBOutlet var log: NSTextView!
    
    private var timestamp: Date?
    private var lastActivity: Activity?
    
    private var periodDuration: TimeInterval {
        get { return elapsedTime.maxValue }
        set { elapsedTime.maxValue = newValue }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        Head.shared.periodDelegate = self
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        Head.shared.periodDelegate = nil
    }
    
    @IBAction func logActivity(_ sender: Any) {
        lastActivity = Activity(timestamp: timestamp!, duration: periodDuration, title: activityTitle.stringValue)
        disableFormular()
        activityTitle.stringValue = lastActivity!.title
        printCurrentDate(activity: lastActivity!)
        printActivity(lastActivity!)
        Head.shared.write(activity: lastActivity!)
    }
    
    private func enableFormular() {
        activityTitleLabel.isEnabled = true
        activityTitle.isEnabled = true
        logActivityButton.isEnabled = true
        
        activityTitle.becomeFirstResponder()
    }
    
    private func disableFormular() {
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
    
    // MARK: Period Delegate
    
    func periodStarted(duration: TimeInterval) {
        periodDuration = duration
        periodProgressed(remainingTime: duration)
    }
    
    func periodProgressed(remainingTime: TimeInterval) {
        elapsedTime.doubleValue = periodDuration - remainingTime
        
        let time = Date(timeIntervalSinceReferenceDate: remainingTime)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC")
        self.remainingTime.stringValue = formatter.string(from: time)
    }
    
    func periodEnded(timestamp: Date) {
        self.timestamp = timestamp
        enableFormular()
    }
    
}
