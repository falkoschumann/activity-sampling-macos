//
//  Log.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 03.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol LogDelegate {
    
    func logFirstActivity(timestamp: Date)
    
    func shouldLogSameActivity(_ lastActivity: Activity)
    
    func activityDidLog(_ log: Log, activity: Activity)
    
}

class Log {
    
    var delegate: LogDelegate?
    
    var fileURL: URL?
    
    private var lastActivity: Activity?
    
    func periodDidEnd(timestamp: Date) {
        if lastActivity == nil {
            delegate?.logFirstActivity(timestamp: timestamp)
        } else {
            let activity = Activity(timestamp: timestamp, period: lastActivity!.period, title: lastActivity!.title)
            delegate?.shouldLogSameActivity(activity)
        }
    }
    
    func log(_ activity: Activity) {
        writeToCSV(activity)
        lastActivity = activity
        delegate?.activityDidLog(self, activity: activity)
    }
    
    private func writeToCSV(_ activity: Activity) {
        if let url = fileURL {
            print(url.path)
            let data = "\(ISO8601DateFormatter().string(from: activity.timestamp)),\(activity.period / 60),\"\(activity.title)\"\r\n".data(using: .utf8)
            do {
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: url.path) {
                    try "timestamp,period,activity\r\n".write(to: url, atomically: true, encoding: .utf8)
                }
                
                let handle = try FileHandle(forWritingTo: url)
                handle.seekToEndOfFile()
                handle.write(data!)
                handle.closeFile()
            } catch {
                print("Fehler: \(error)")
            }
        }
    }
    
}
