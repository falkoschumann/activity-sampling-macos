//
//  ActivityLog.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 04.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol ActivityLogDelegate {
    
    func log(_ activity: Activity)
    
}

protocol ActivityLog {
    
    var delegate: ActivityLogDelegate? { get set }
    
    func periodDidStart(duration: TimeInterval)
    
    func periodDidProgress(elapsedTime: TimeInterval, remainingTime: TimeInterval)
    
    func periodDidEnd(timestamp: Date)
    
    func activityDidLog(activity: Activity)
    
}
