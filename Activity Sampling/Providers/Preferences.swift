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
            }
        }
    }
    
    var activityLogFile: URL {
        get {
            if let urlString = UserDefaults.standard.string(forKey: "log.file") {
                return URL(fileURLWithPath: urlString)
            } else {
                return Preferences.defaultActivityLogFile()
            }
        }
        set {
            UserDefaults.standard.set(newValue.path, forKey: "log.file")
        }
    }
    
    private func isDurationValid(_ duration: TimeInterval) -> Bool {
        return duration > 0 && duration <= 24 * 60 * 60
    }
    
    private static func defaultActivityLogFile() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsUrl = urls.first
        return documentsUrl!.appendingPathComponent("activity-log.csv")
    }
    
}
