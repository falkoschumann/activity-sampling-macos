//
//  Period.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 29.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol PeriodDelegate: AnyObject {
    func periodStarted(duration: TimeInterval)
    func periodProgressed(remainingTime: TimeInterval)
    func periodEnded(timestamp: Date)
}

class Period {
    
    weak var delegate: PeriodDelegate?
    
    var duration: TimeInterval = 20 * 60 {
        didSet {
            start = nil
        }
    }
    
    var isInProgress: Bool {
        get { return start != nil }
    }
    
    private var start: Date!
    
    func check(currentTime: Date) {
        classify(currentTime, onStarted: start, onProgressed: progress, onEnded: end)
    }
    
    private func classify(_ currentTime: Date,
                          onStarted: (Date) -> Void,
                          onProgressed: (TimeInterval) -> Void,
                          onEnded: (Date) -> Void) {
        guard isInProgress else {
            onStarted(currentTime)
            return
        }
        
        let elapsedTime = currentTime.timeIntervalSince(start)
        let remainingTime = duration - elapsedTime
        if remainingTime > 0 {
            onProgressed(remainingTime)
        } else {
            onEnded(currentTime)
        }
    }
    
    private func start(_ timestamp: Date) {
        self.start = timestamp
        delegate?.periodStarted(duration: duration)
    }
    
    private func progress(_ remainingTime: TimeInterval) {
        delegate?.periodProgressed(remainingTime: remainingTime)
    }
    
    private func end(_ timestamp: Date) {
        self.start = nil
        delegate?.periodEnded(timestamp: timestamp)
    }
    
}
