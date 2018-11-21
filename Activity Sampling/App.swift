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
        period.duration = Preferences.shared.periodDuration
        logFile.fileURL = Preferences.shared.activityLogFile
        
        clock.delegate = period
    }
    
}

extension Period : ClockDelegate {
    
    func ticked(_ clock: Clock, currentTime: Date) {
        print("clock ticked", currentTime)
        check(currentTime)
    }
    
}

extension ActivityLogController : PeriodDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("activity log view did load")
        App.shared.period.delegate = self
        delegate = App.shared.logFile
    }
    
    func started(_ period: Period, duration: TimeInterval) {
        print("period started", duration)
        startPeriod(duration: duration)
    }
    
    func progressed(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        print("period progressed", elapsedTime, remainingTime)
        progressPeriod(elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    func ended(_ period: Period, timestamp: Date) {
        print("period ended", timestamp)
        endPeriod(timestamp: timestamp)
    }
    
}

extension LogFile : ActivityLogDelegate {
    
    func logged(_ activityLog: ActivityLogController, activity: Activity) {
        print("activity log logged", activity)
        write(activity)
    }
    
}
