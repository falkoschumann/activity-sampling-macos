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
    let notifications = Notifications()
    
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

extension ActivityLogController : PeriodDelegate, NotificationsDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        App.shared.period.delegate = self
        App.shared.notifications.delegate = self
        delegate = App.shared.log
    }
    
    // MARK: PeriodDelegate
    
    func started(_ period: Period, duration: TimeInterval) {
        startPeriod(duration: duration)
    }
    
    func progressed(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        progressPeriod(elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    func ended(_ period: Period, timestamp: Date) {
        endPeriod(timestamp: timestamp)
        if let activity = lastActivity {
            App.shared.notifications.askIfSameActivity(title: activity.title)
        } else {
            App.shared.notifications.askAboutCurrentActivity()
        }
    }
    
    // MARK: NotificationsDelegate
    
    func logActivity(_ notifications: Notifications, title: String) {
        // TODO Not implemented yet.
        lastActivity = Activity(timestamp: timestamp!, duration: periodDuration, title: title)
    }
    
    func logSameActivity(_ notifications: Notifications) {
        // TODO Not implemented yet.
    }
    
    func logOtherActivity(_ notifications: Notifications) {
        // TODO Not implemented yet.
    }
    
}

extension Log : ActivityLogDelegate {
    
    func logged(_ activityLog: ActivityLogController, activity: Activity) {
        write(activity)
    }
    
}
