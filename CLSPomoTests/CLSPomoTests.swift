//
//  CLSPomoTests.swift
//  CLSPomoTests
//
//  Created by Seungwon on 2018. 7. 1..
//  Copyright © 2018년 Seungwon. All rights reserved.
//

import XCTest
@testable import CLSPomo

class CLSPomoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimerIsRunning() {
        let pomoTimer: CLSPomoTimer = CLSPomoTimer()
        pomoTimer.startPomo()
        XCTAssertTrue(pomoTimer.isRunning)
    }
    
    func testTimerIsNotRunning() {
        let pomoTimer: CLSPomoTimer = CLSPomoTimer()
        XCTAssertFalse(pomoTimer.isRunning)
    }
    
    func testTimerIsNotRunningWhenPause() {
        let pomoTimer: CLSPomoTimer = CLSPomoTimer()
        pomoTimer.startPomo()
        pomoTimer.pausePomo()
        XCTAssertFalse(pomoTimer.isRunning)
    }
    
    func testTimerIsRunningWhenResume() {
        let pomoTimer: CLSPomoTimer = CLSPomoTimer()
        pomoTimer.startPomo()
        pomoTimer.pausePomo()
        pomoTimer.resumePomo()
        XCTAssertTrue(pomoTimer.isRunning)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
