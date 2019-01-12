//
//  ActivityLogController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class ActivityLogDialogController: NSViewController {
    
    @IBOutlet weak var activityTitleLabel: NSTextField!
    @IBOutlet weak var activityTitle: NSTextField!
    @IBOutlet weak var logActivityButton: NSButton!
    
    @IBOutlet weak var remainingTime: NSTextField!
    @IBOutlet weak var elapsedTime: NSProgressIndicator!
    
    @IBOutlet var log: NSTextView!
    
    private var periodTimestamp: Date!
    
    private var periodDuration: TimeInterval {
        get { return elapsedTime.maxValue }
        set { elapsedTime.maxValue = newValue }
    }
    
    private var lastActivityTitle: String {
        get { return activityTitle.stringValue }
        set { activityTitle.stringValue = newValue }
    }
    
    private let notifications = Notifications()
    private var lastTimestamp: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifications.delegate = self
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
        disableFormular()
        printCurrentDate(periodTimestamp)
        let activity = Activity(timestamp: periodTimestamp, duration: periodDuration, title: lastActivityTitle)
        printActivity(activity)
        Head.shared.write(activity: activity)
        
        lastTimestamp = periodTimestamp
    }
    
    private func enableFormular() {
        activityTitleLabel.isEnabled = true
        activityTitle.isEnabled = true
        logActivityButton.isEnabled = true
        
        activityTitle.becomeFirstResponder()
        if lastTimestamp == nil {
            notifications.askAboutCurrentActivity()
        } else {
            notifications.askIfSameActivity(title: lastActivityTitle)
        }
    }
    
    private func disableFormular() {
        activityTitleLabel.isEnabled = false
        activityTitle.isEnabled = false
        logActivityButton.isEnabled = false
        
        notifications.removeNotifivation()
    }
    
    private func printCurrentDate(_ timestamp: Date) {
        if sameDay(timestamp) {
            return
        }
        let date = DateFormatter.localizedString(from: timestamp, dateStyle: .full, timeStyle: .none)
        log.textStorage?.append(NSAttributedString(string: date + "\n",
                                                   attributes: [.foregroundColor: NSColor.textColor]))
    }
    
    private func sameDay(_ timestamp: Date) -> Bool {
        guard lastTimestamp != nil else {
            return false
        }
        
        return Calendar.current.compare(lastTimestamp, to: timestamp, toGranularity: .day) == .orderedSame
    }
    
    private func printActivity(_ activity: Activity){
        let timestamp = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .none, timeStyle: .short)
        log.textStorage?.append(NSAttributedString(string: timestamp + " - " + activity.title + "\n",
                                                   attributes: [.foregroundColor: NSColor.textColor]))
    }
    
}

extension ActivityLogDialogController: PeriodDelegate {
    
    func periodStarted(duration: TimeInterval) {
        periodDuration = duration
        periodProgressed(remainingTime: duration)
    }
    
    func periodProgressed(remainingTime: TimeInterval) {
        elapsedTime.doubleValue = periodDuration - remainingTime
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC")
        let time = Date(timeIntervalSinceReferenceDate: remainingTime)
        self.remainingTime.stringValue = formatter.string(from: time)
    }
    
    func periodEnded(timestamp: Date) {
        periodTimestamp = timestamp
        enableFormular()
    }
    
}

extension ActivityLogDialogController: NotificationsDelegate {
    
    func logActivity(title: String) {
        activityTitle.stringValue = title
        logActivity(self)
    }
    
    func logSameActivity() {
        logActivity(self)
    }
    
}
