//
//  Clock.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 29.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol ClockDelegate {
    
    func clockDidTick(_ clock: Clock, currentTime: Date)
    
}

class Clock {
    
    var delegate: ClockDelegate?
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.delegate?.clockDidTick(self, currentTime: Date())
        }
    }
    
}
