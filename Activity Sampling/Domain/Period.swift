//
//  Period.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 29.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol PeriodDelegate {
    func started(duration: TimeInterval)
    func progressed(elapsedTime: TimeInterval, remainingTime: TimeInterval)
    func ended(timestamp: Date)
}

class Period {
    
    var delegate: PeriodDelegate?
    
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
        delegate?.started(duration: duration)
    }
    
    private func progress(_ elapsedTime: TimeInterval, _ remainingTime: TimeInterval) {
        delegate?.progressed(elapsedTime: elapsedTime, remainingTime: remainingTime)
    }
    
    private func end(_ timestamp: Date) {
        self.start = nil
        delegate?.ended(timestamp: timestamp)
    }
    
}
