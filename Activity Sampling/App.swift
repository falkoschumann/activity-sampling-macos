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
    let log = Log()
    
    private init() {
        period.duration = Preferences.shared.periodDuration
        log.fileURL = Preferences.shared.activityLogFile
        
        clock.delegate = period
        
        NotificationCenter.default.addObserver(forName: Preferences.periodDurationChanged, object: nil, queue: nil) { (_) in
            self.period.duration = Preferences.shared.periodDuration
        }
        NotificationCenter.default.addObserver(forName: Preferences.activityLogFileChanged, object: nil, queue: nil) { (_) in
            self.log.fileURL = Preferences.shared.activityLogFile
        }
    }
    
}

extension Period : ClockDelegate {
    
    func ticked(_ clock: Clock, currentTime: Date) {
        check(currentTime)
    }
    
}

extension ActivityLogController : PeriodDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        App.shared.period.delegate = self
        delegate = App.shared.log
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

extension Log : ActivityLogDelegate {
    
    func logged(_ activityLog: ActivityLogController, activity: Activity) {
        write(activity)
    }
    
}
