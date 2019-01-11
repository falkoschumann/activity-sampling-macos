//
//  Notifications.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 21.11.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

// Ab macOS 10.4 Mojave:
// import UserNotifications
// UNUserNotificationCenter.current()

protocol NotificationsDelegate {
    func logActivity(title: String)
    func logSameActivity()
    func logOtherActivity()
}

class Notifications: NSObject {
    
    static let askAboutCurrentActivityNotification = "askAboutCurrentActivityNotification"
    static let askIfSameActivityNotification = "askIfSameActivityNotification"
    
    var delegate: NotificationsDelegate?
    
    private var lastNotification: NSUserNotification?
    
    override init() {
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    func askAboutCurrentActivity() {
        let notification = NSUserNotification()
        notification.identifier = Notifications.askAboutCurrentActivityNotification
        notification.title = "What are you working on?"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasReplyButton = true
        notification.responsePlaceholder = "Your current activity"
        
        NSUserNotificationCenter.default.deliver(notification)
        lastNotification = notification
    }
    
    func askIfSameActivity(title: String) {
        let notification = NSUserNotification()
        notification.identifier = Notifications.askIfSameActivityNotification
        notification.title = "What are you working on?"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.informativeText = title
        notification.hasActionButton = true
        notification.actionButtonTitle = "Other Activity"
        notification.otherButtonTitle = "Same Activity"
        
        NSUserNotificationCenter.default.deliver(notification)
        lastNotification = notification
    }
    
    func removeNotifivation() {
        NSUserNotificationCenter.default.removeDeliveredNotification(lastNotification!)
        lastNotification = nil
    }
    
}

extension Notifications : NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        print("did deliver")
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        print("did activate")
        switch (notification.activationType) {
        case .actionButtonClicked:
            print("action button clicked: log other activity")
            delegate?.logOtherActivity()
            break
        case .additionalActionClicked:
            print("additional action clicked")
            break
        case .contentsClicked:
            print("contents clicked")
            // TODO: What to do?
            break
        case .none:
            print("none")
            break
        case .replied:
            print("replied: log activity")
            delegate?.logActivity(title: notification.response!.string)
            break
        default:
            break
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    @objc func userNotificationCenter(_ center: NSUserNotificationCenter, didDismissAlert notification: NSUserNotification) {
        if (notification.activationType == .none && notification.identifier == Notifications.askIfSameActivityNotification) {
            print("did dismiss alert: log same activity")
            delegate?.logSameActivity()
        } else {
            print("did dismiss alert")
        }
    }
    
}
