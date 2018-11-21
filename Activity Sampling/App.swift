//
//  App.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 21.11.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

class App {
    
    static let shared = App()
    
    let clock = Clock()
    let period = Period()
    let logFile = LogFile()
    
    private init() {
        clock.delegate = period
    }
    
}

extension Period : ClockDelegate {
    
    func ticked(_ clock: Clock, currentTime: Date) {
        check(currentTime)
    }
    
}

extension ActivityLogController : PeriodDelegate {
    
    convenience init() {
        self.init()
        App.shared.period.delegate = self
        delegate = App.shared.logFile
    }
    
    func started(_ period: Period, duration: TimeInterval) {
        startPeriod(duration: duration)
    }
    
    func progressed(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        progressPeriod(elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    func ended(_ period: Period, timestamp: Date) {
        endPeriod(timestamp: timestamp)
    }
    
}

extension LogFile : ActivityLogDelegate {
    
    func logged(_ activityLog: ActivityLogController, activity: Activity) {
        write(activity)
    }
    
}
