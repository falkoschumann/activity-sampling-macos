//
//  Period.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 29.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol PeriodDelegate : class {
    func started(_ period: Period, duration: TimeInterval)
    func progressed(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval)
    func ended(_ period: Period, timestamp: Date)
}

class Period {
    
    weak var delegate: PeriodDelegate?
    
    var duration: TimeInterval = 20 * 60 {
        didSet {
            start = nil
        }
    }
    
    private var start: Date!
    
    func check(_ currentTime: Date) {
        classify(currentTime, onStarted: start, onProgressed: progress, onEnded: end)
    }
    
    private func classify(_ currentTime: Date,
                          onStarted: (Date) -> Void,
                          onProgressed: (TimeInterval, TimeInterval) -> Void,
                          onEnded: (Date) -> Void) {
        guard start != nil else {
            onStarted(currentTime)
            return
        }
        
        let elapsedTime = currentTime.timeIntervalSince(start)
        let remainingTime = duration - elapsedTime
        if remainingTime > 0 {
            onProgressed(elapsedTime, remainingTime)
        } else {
            onEnded(currentTime)
        }
    }
    
    private func start(_ timestamp: Date) {
        self.start = timestamp
        delegate?.started(self, duration: duration)
    }
    
    private func progress(_ elapsedTime: TimeInterval, _ remainingTime: TimeInterval) {
        delegate?.progressed(self, elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    private func end(_ timestamp: Date) {
        self.start = nil
        delegate?.ended(self, timestamp: timestamp)
    }
    
}
