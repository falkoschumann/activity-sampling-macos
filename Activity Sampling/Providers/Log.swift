//
//  Log.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 03.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

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
            let activity = Activity(timestamp: timestamp, duration: lastActivity!.duration, title: lastActivity!.title)
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
            var row: [String] = []
            let timestampFormatter = ISO8601DateFormatter()
            timestampFormatter.timeZone = TimeZone.current
            row.append(timestampFormatter.string(from: activity.timestamp))
            row.append(String(Int(activity.duration / 60)))
            row.append("\"".appending(activity.title).appending("\""))
            let seperator = ","
            let data = row.joined(separator: seperator).appending("\r\n").data(using: .utf8)
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
                print("Error writing log: \(error)")
                
                let alert = NSAlert()
                alert.messageText = error.localizedDescription
                alert.alertStyle = .warning
                alert.runModal()
            }
        }
    }
    
}
