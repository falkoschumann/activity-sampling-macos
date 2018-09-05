//
//  App.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 30.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

class App: NSObject, PeriodDelegate, ActivityDemandDelegate, ActivityLogDelegate, ClockDelegate, LogDelegate {
    
    static let shared = App()
    
    var activityLog: ActivityLog? {
        willSet(newValue) {
            newValue?.periodDidStart(duration: period.duration)
        }
        didSet(oldValue) {
            activityLog?.delegate = self
        }
    }
    
    private let period = Period()
    private let activityDemand = ActivityDemand()
    private let clock = Clock()
    private let log = Log()
    
    @objc var preferences = Preferences.shared
    var periodDurationObservation: NSKeyValueObservation?
    
    override init() {
        super.init()
        
        period.duration = preferences.periodDuration
        period.delegate = self
        activityDemand.delegate = self
        clock.delegate = self
        log.delegate = self
        
        periodDurationObservation = observe(\.preferences.periodDuration, options: [.new]
        ) { object, change in
            self.period.duration = change.newValue!
        }
    }
    
    func start() {
        clock.start()
    }
    
    func stop() {
        clock.stop()
        activityDemand.hideNotification()
    }
        
    // MARK: Period Delegate
    
    func periodDidStart(_ period: Period, duration: TimeInterval) {
        activityLog?.periodDidStart(duration: duration)
    }
    
    func periodDidProgress(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        activityLog?.periodDidProgress(elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    func periodDidEnd(_ period: Period, timestamp: Date) {
        activityLog?.periodDidEnd(timestamp: timestamp)
        log.periodDidEnd(timestamp: timestamp)
    }
    
    // MARK: Activity Demand Delegate and Activity Log Delegate

    func log(_ activity: Activity) {
        log.log(activity)
    }
    
    // MARK: Activity Demand Delegate
    
    func logOtherActivity() {
        // nothing to do
    }

    // MARK: Clock Delegate
    
    func clockDidTick(_ clock: Clock, currentTime: Date) {
        period.check(currentTime)
    }
    
    // MARK: Log Delegate

    func logFirstActivity(timestamp: Date) {
        activityDemand.logFirstActivity(timestamp: timestamp, period: period.duration)
    }
    
    func shouldLogSameActivity(_ lastActivity: Activity) {
        activityDemand.shouldLogSameActivity(lastActivity)
    }

    func activityDidLog(_ log: Log, activity: Activity) {
        activityDemand.activityDidLog(activity)
        activityLog?.activityDidLog(activity: activity)        
    }
    
}
