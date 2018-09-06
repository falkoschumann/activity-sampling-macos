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
    
    @objc dynamic var activityLogFile: URL {
        get {
            if let urlString = UserDefaults.standard.string(forKey: "log.file") {
                return URL(fileURLWithPath: urlString)
            } else {
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsUrl = urls.first
                return documentsUrl!.appendingPathComponent("activity-log.csv")
            }
        }
        set { UserDefaults.standard.set(newValue.path, forKey: "log.file") }
    }

}
