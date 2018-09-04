//
//  ActivityDemand.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 31.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

protocol ActivityDemandDelegate {
    
    func log(_ activity: Activity)
    
    func logOtherActivity()
    
}

class ActivityDemand: NSObject, NSUserNotificationCenterDelegate {
    
    var delegate: ActivityDemandDelegate?
    
    private var firstActivityTimestamp: Date!
    
    private var lastActivity: Activity!
    private var lastNotification: NSUserNotification?
    
    override init() {
        super.init()
        
        NSUserNotificationCenter.default.delegate = self        
    }
    
    func logFirstActivity(timestamp: Date) {
        hideNotification()
        firstActivityTimestamp = timestamp
        
        let notification = NSUserNotification()
        notification.title = "What are you working on?"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasReplyButton = true
        notification.responsePlaceholder = "Your current activity"
        
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(notification)
        self.lastNotification = notification
    }
    
    func shouldLogSameActivity(_ lastActivity: Activity) {
        hideNotification()
        self.lastActivity = lastActivity
        
        let notification = NSUserNotification()
        notification.title = "What are you working on?"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.informativeText = lastActivity.title
        notification.hasActionButton = true
        notification.actionButtonTitle = "Other Activity"
        notification.otherButtonTitle = "Same Activity"
        
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(notification)
        self.lastNotification = notification
    }
    
    func activityDidLog(_ activity: Activity) {
        hideNotification()
    }
    
    private func hideNotification() {
        if let notification = lastNotification {
            let notificationCenter = NSUserNotificationCenter.default
            notificationCenter.removeDeliveredNotification(notification)
        }
    }
    
    // MARK: User Notification Center Delegate
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch (notification.activationType) {
        case .replied:
            print("log first activity")
            guard let activityTitle = notification.response else { return }
            let activity = Activity(timestamp: firstActivityTimestamp!, title: activityTitle.string)
            delegate?.log(activity)
            break
        case .actionButtonClicked:
            print("Other activity, activate app")
            delegate?.logOtherActivity()
            break
        default:
            break
        }
    }
    
    @objc
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDismissAlert notification: NSUserNotification) {
        print("Same activity, log last activity")
        if let activity = lastActivity {
            delegate?.log(activity)
        }
    }
    
}
