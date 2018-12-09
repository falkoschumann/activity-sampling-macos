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
        clock.delegate = period
        
        NotificationCenter.default.addObserver(forName: Preferences.periodDurationChanged, object: nil, queue: nil) { (_) in
            self.period.duration = Preferences.shared.periodDuration
        }
    }
    
}

extension Period : ClockDelegate {
    
    func ticked(currentTime: Date) {
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
    
    override func viewWillDisappear() {
        App.shared.notifications.removeNotifivation()
    }
    
    // MARK: PeriodDelegate
    
    func started(duration: TimeInterval) {
        startPeriod(duration: duration)
    }
    
    func progressed(elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        progressPeriod(elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    func ended(timestamp: Date) {
        endPeriod(timestamp: timestamp)
        if let activity = lastActivity {
            App.shared.notifications.askIfSameActivity(title: activity.title)
        } else {
            App.shared.notifications.askAboutCurrentActivity()
        }
    }
    
    // MARK: NotificationsDelegate
    
    func logActivity(title: String) {
        activityTitle.stringValue = title
        logActivity(self)
    }
    
    func logSameActivity() {
        logActivity(self)
    }
    
    func logOtherActivity() {
        // TODO: Not implemented yet.
    }
    
}

extension Log : ActivityLogDelegate {
    
    func logged(activity: Activity) {
        write(activity)
        App.shared.notifications.removeNotifivation()
    }
    
}
