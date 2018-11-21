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
    func logActivity(_ notifications: Notifications, title: String)
    func logSameActivity(_ notifications: Notifications)
    func logOtherActivity(_ notifications: Notifications)
}

class Notifications : NSObject {
    
    var delegate: NotificationsDelegate?
    
    private var lastNotification: NSUserNotification?
    
    override init() {
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    func askAboutCurrentActivity() {
        let notification = NSUserNotification()
        notification.title = "What are you working on?"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasReplyButton = true
        notification.responsePlaceholder = "Your current activity"
        
        NSUserNotificationCenter.default.deliver(notification)
        self.lastNotification = notification
    }
    
    func askIfSameActivity(title: String) {
        let notification = NSUserNotification()
        notification.title = "What are you working on?"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.informativeText = title
        notification.hasActionButton = true
        notification.actionButtonTitle = "Other Activity" // bottom buttom
        notification.otherButtonTitle = "Same Activity" // top buttom aka close -> no action?
        
        NSUserNotificationCenter.default.deliver(notification)
        self.lastNotification = notification
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
            delegate?.logOtherActivity(self)
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
            delegate?.logActivity(self, title: notification.title!)
            break
        default:
            break
        }
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    @objc func userNotificationCenter(_ center: NSUserNotificationCenter, didDismissAlert notification: NSUserNotification) {
        if (notification.activationType == .none) {
            print("did dismiss alert: log same activity")
            delegate?.logSameActivity(self)
        } else {
            print("did dismiss alert")
        }
    }

}
