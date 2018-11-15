//
//  PeriodTests.swift
//  Activity Sampling Tests
//
//  Created by Falko Schumann on 15.11.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import XCTest
@testable import Activity_Sampling

class PeriodTests: XCTestCase {

    func testStart() {
        let delegate = TestingPeriodDelegate()
        let period = Period()
        period.delegate = delegate
        
        let startTime = Date()
        period.check(startTime)
        
        XCTAssertNotNil(delegate.period, "period")
        XCTAssertEqual(TimeInterval(20 * 60), delegate.duration, "duration")
    }
    
    func testProgress() {
        let delegate = TestingPeriodDelegate()
        let period = Period()
        period.delegate = delegate
        let startTime = Date()
        period.check(startTime)
        
        let currentTime = startTime.addingTimeInterval(TimeInterval(7 * 60))
        period.check(currentTime)
        
        XCTAssertNotNil(delegate.period, "period")
        XCTAssertEqual(TimeInterval(7 * 60), delegate.elapsedTime, "elapsedTime")
        XCTAssertEqual(TimeInterval(13 * 60), delegate.remainingTime, "remainingTime")
    }
    
    func testEnd() {
        let delegate = TestingPeriodDelegate()
        let period = Period()
        period.delegate = delegate
        let startTime = Date()
        period.check(startTime)
        
        let currentTime = startTime.addingTimeInterval(TimeInterval(20 * 60))
        period.check(currentTime)
        
        XCTAssertNotNil(delegate.period, "period")
        XCTAssertEqual(currentTime, delegate.timestamp, "timestamp")
    }

}

fileprivate class TestingPeriodDelegate : PeriodDelegate {
    
    var period: Period!
    var duration: TimeInterval!
    var elapsedTime: TimeInterval!
    var remainingTime: TimeInterval!
    var timestamp: Date!
    
    func periodStarted(_ period: Period, duration: TimeInterval) {
        self.period = period
        self.duration = duration
    }
    
    func periodProgressed(_ period: Period, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        self.period = period
        self.elapsedTime = elapsedTime
        self.remainingTime = remainingTime
    }
    
    func periodEnded(_ period: Period, timestamp: Date) {
        self.period = period
        self.timestamp = timestamp
    }
    
}
