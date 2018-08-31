//
//  ActivityLog.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 30.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol ActivityLogDelegate {
    
    func periodDidStart(_ activityLog: App, duration: TimeInterval)
    
    func periodDidProgress(_ activityLog: App, elapsedTime: TimeInterval, remainingTime: TimeInterval)
    
    func periodDidEnd(_ activityLog: App)
    
    func activityDidLog(_ activityLog: App, activity: Activity)

}

class App : ClockDelegate, PeriodDelegate {
    
    static let shared = App()
    
    var activityLogDelegate: ActivityLogDelegate?

    var periodDuration: TimeInterval {
        get { return period.duration }
        set { period.duration = newValue }
    }
    
    private let clock = Clock()
    private let period = Period()
    
    private var timestamp: Date?

    init() {
        clock.delegate = self
        period.delegate = self
        period.start()
    }
    
    func logCurrentActivity(_ currentActivity: String) {
        activityLogDelegate?.activityDidLog(self, activity: Activity(timestamp: timestamp!, title: currentActivity))
    }
    
    // MARK: Clock Delegate
    
    func clockDidTick(_ clock: Clock, currentTime: Date) {
        period.check(currentTime: currentTime)
    }
    
    // MARK: Period Delegate
    
    func periodDidStart(_ period: Period, duration: TimeInterval) {
        activityLogDelegate?.periodDidStart(self, duration: duration)
    }
    
    func periodDidProgress(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        activityLogDelegate?.periodDidProgress(self, elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    func periodDidEnd(_ period: Period, timestamp: Date) {
        self.timestamp = timestamp
        activityLogDelegate?.periodDidEnd(self)
    }
    
}
