//
//  ActivityLog.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 30.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol ActivityLogDelegate {
    
    func periodDidStart(_ activityLog: ActivityLog, duration: TimeInterval)
    
    func periodDidProgress(_ activityLog: ActivityLog, elapsedTime: TimeInterval, remainingTime: TimeInterval)
    
    func periodDidEnd(_ activityLog: ActivityLog)
    
    func activityDidLog(_ activityLog: ActivityLog, activity: Activity)

}

class ActivityLog : ClockDelegate, PeriodDelegate {
    
    var delegate: ActivityLogDelegate?
    
    private let clock = Clock()
    private let period = Period()
    
    private var timestamp: Date?

    init() {
        clock.delegate = self
        period.delegate = self
    }
    
    func start() {
        period.start()
    }
    
    func logCurrentActivity(_ currentActivity: String) {
        delegate?.activityDidLog(self, activity: Activity(timestamp: timestamp!, title: currentActivity))
    }
    
    // MARK: Clock Delegate
    
    func clockDidTick(_ clock: Clock, currentTime: Date) {
        period.check(currentTime: currentTime)
    }
    
    // MARK: Period Delegate
    
    func periodDidStart(_ period: Period, duration: TimeInterval) {
        delegate?.periodDidStart(self, duration: duration)
    }
    
    func periodDidProgress(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        delegate?.periodDidProgress(self, elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    func periodDidEnd(_ period: Period, timestamp: Date) {
        self.timestamp = timestamp
        delegate?.periodDidEnd(self)
    }
    
}
