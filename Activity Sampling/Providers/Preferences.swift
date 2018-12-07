//
//  Preferences.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 05.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

class Preferences {
    
    static let shared = Preferences()
    
    static let periodDurationChanged = Notification.Name.init(rawValue: "Preferences.PeriodDurationChanged")
    
    private static let defaultPeriodDuration = TimeInterval(20 * 60)
    
    var periodDuration: TimeInterval {
        get {
            let duration = UserDefaults.standard.double(forKey: "period.duration")
            if isDurationValid(duration) {
                return duration
            } else {
                return Preferences.defaultPeriodDuration
            }
        }
        set {
            if isDurationValid(newValue) {
                UserDefaults.standard.set(newValue, forKey: "period.duration")
                NotificationCenter.default.post(name: Preferences.periodDurationChanged, object: self)
            }
        }
    }
    
    private func isDurationValid(_ duration: TimeInterval) -> Bool {
        return duration > 0 && duration <= 24 * 60 * 60
    }
    
}
