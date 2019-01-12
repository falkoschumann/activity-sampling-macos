//
//  Clock.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 29.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol ClockDelegate: AnyObject {
    func clockTicked(currentTime: Date)
}

class Clock {
    
    weak var delegate: ClockDelegate?
    
    private var timer: Timer!
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.delegate?.clockTicked(currentTime: Date())
        }
    }
    
    deinit {
        timer.invalidate()
    }
    
}
