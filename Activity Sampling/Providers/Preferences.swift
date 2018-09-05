//
//  Preferences.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 05.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

class Preferences: NSObject {
    
    static let shared = Preferences()
    
    @objc dynamic var periodDuration: TimeInterval {
        get {
            let duration = UserDefaults.standard.double(forKey: "period.duration")
            if duration > 0 && duration <= 24 * 60 * 60 {
                return duration
            } else {
                return 20 * 60
            }
        }
        set { UserDefaults.standard.set(newValue, forKey: "period.duration") }
    }

}
