//
//  Period.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 29.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol PeriodDelegate {
    
    func periodDidStart(_ period: Period, duration: TimeInterval)
    
    func periodDidProgress(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval)
    
    func periodDidEnd(_ period: Period, timestamp: Date)
    
}

class Period {
    
    var delegate: PeriodDelegate?
    
    var duration: TimeInterval = 20 * 60
    
    private var start: Date!
    
    func check(_ currentTime: Date) {
        guard start != nil else {
            start = currentTime
            delegate?.periodDidStart(self, duration: duration)
            return
        }
        
        let elapsedTime = currentTime.timeIntervalSince(start)
        let remainingTime = duration - elapsedTime
        if remainingTime > 0 {
            delegate?.periodDidProgress(self, elapsedTime: elapsedTime, remainingTime: remainingTime)
        } else {
            delegate?.periodDidEnd(self, timestamp: currentTime)
            self.start = currentTime
            delegate?.periodDidStart(self, duration: duration)
        }
    }
    
}
