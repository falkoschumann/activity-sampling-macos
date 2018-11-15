//
//  AppDelegate.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ClockDelegate {
    
    private let clock = Clock()
    private let period = Period()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        App.shared.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        App.shared.stop()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    // MARK: Clock Delegate
    
    func clockTicked(_ clock: Clock, currentTime: Date) {
        period.check(currentTime)
    }
    
    // MARK: Period Delegate
    
    func periodStarted(_ period: Period, duration: TimeInterval) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "PeriodStarted"),
                                        object: period,
                                        userInfo: ["duration": duration])
    }
    
    func periodProgressed(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "PeriodProgressed"),
                                        object: period,
                                        userInfo: ["elapsedTime": elapsedTime, "remainingTime": remainingTime])
    }
    
    func periodEnded(_ period: Period, timestamp: Date) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "PeriodEnded"),
                                        object: period,
                                        userInfo: ["timestamp": timestamp])
    }
    
}
