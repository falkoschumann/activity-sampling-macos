//
//  Head.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 06.01.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation

class Head {
    
    static let shared = Head()
    
    var periodDelegate: PeriodDelegate? {
        get { return body.periodDelegate }
        set { body.periodDelegate = newValue }
    }
    
    var periodDuration: TimeInterval {
        get { return body.periodDuration }
        set { body.periodDuration = newValue }
    }
    
    private let body: Body
    private let clock = Clock()
    
    init() {
        body = Body(activityLog: CSVActivityLog(), preferences: UserDefaultsPreferences())
        clock.delegate = self
    }
    
    func write(activity: Activity) {
        body.write(activity: activity)
    }
    
}

extension Head: ClockDelegate {
    
    func clockTicked(currentTime: Date) {
        body.check(currentTime: currentTime)
    }
    
}
