//
//  CSVActivityLog.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 06.01.19.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

class CSVActivityLog: ActivityLog {
    
    let fileURL: URL = {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = urls.first
        return documentsURL!.appendingPathComponent("activity-log.csv")
    }()
    
    func write(activity: Activity) {
        do {
            if isNewLogFile(fileURL) {
                try writeHeader(to: fileURL)
            }
            let entry = createEntry(activity)
            try writeEntry(entry, to: fileURL)
        } catch {
            print("Error writing log: \(error)")
        }
    }
    
    private func isNewLogFile(_ url: URL) -> Bool {
        let fileManager = FileManager.default
        return !fileManager.fileExists(atPath: url.path)
    }
    
    private func writeHeader(to: URL) throws {
        try "timestamp,period,activity\r\n".write(to: to, atomically: true, encoding: .utf8)
    }
    
    private func createEntry(_ activity: Activity) -> Data {
        var row: [String] = []
        let timestampFormatter = DateFormatter()
        timestampFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        row.append(timestampFormatter.string(from: activity.timestamp))
        row.append(String(Int(activity.duration / 60)))
        row.append("\"".appending(activity.title).appending("\""))
        let seperator = ","
        return row.joined(separator: seperator).appending("\r\n").data(using: .utf8)!
    }
    
    private func writeEntry(_ entry: Data, to: URL) throws {
        let handle = try FileHandle(forWritingTo: to)
        handle.seekToEndOfFile()
        handle.write(entry)
        handle.closeFile()
    }
    
}
