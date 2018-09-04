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
    
    private var lastActivityTitle: String?
    
    func periodDidEnd(timestamp: Date) {
        if lastActivityTitle == nil {
            delegate?.logFirstActivity(timestamp: timestamp)
        } else {
            let activity = Activity(timestamp: timestamp, title: lastActivityTitle!)
            delegate?.shouldLogSameActivity(activity)
        }
    }
    
    func log(_ activity: Activity) {
        lastActivityTitle = activity.title
        delegate?.activityDidLog(self, activity: activity)
    }
    
}
