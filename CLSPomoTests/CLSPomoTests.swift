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
    var pomoTimer = CLSPomoTimer()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /* Tests For state of timer */
    func testTimerIsRunning() {
        pomoTimer.startPomo()
        XCTAssertTrue(pomoTimer.isRunning)
    }
    
    func testTimerIsNotRunning() {
        XCTAssertFalse(pomoTimer.isRunning)
    }
    
    func testTimerIsNotRunningWhenPause() {
        pomoTimer.startPomo()
        pomoTimer.pausePomo()
        XCTAssertFalse(pomoTimer.isRunning)
    }
    
    func testTimerIsRunningWhenResume() {
        pomoTimer.startPomo()
        pomoTimer.pausePomo()
        pomoTimer.resumePomo()
        XCTAssertTrue(pomoTimer.isRunning)
    }
    
    /* Test for current time of timer */
    func testTimeCurrentIsZero() {
        XCTAssertTrue(pomoTimer.currentTime == 0)
    }
    
    func testTimeCurrentIsNotZero() {
        pomoTimer.startPomo()
        sleep(1)
        XCTAssertFalse(pomoTimer.currentTime == 0)
    }
    
    func testTimeCurrentIsZeroWhenStop() {
        pomoTimer.startPomo()
        sleep(1)
        pomoTimer.stopPomo()
        XCTAssertTrue(pomoTimer.currentTime == 0)
    }
    
    func testCompleteWork() {
        pomoTimer.secondPerWork = 5
        pomoTimer.startPomo()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 5))
        pomoTimer.pausePomo()
        XCTAssertFalse(pomoTimer.mode == .working(timeInterval: pomoTimer.secondPerWork))
        XCTAssertTrue(pomoTimer.mode == .breaking(timeInterval: pomoTimer.secondPerBreak))
    }
    
    func testCompleteBreak() {
        pomoTimer.secondPerWork = 5
        pomoTimer.secondPerBreak = 2
        pomoTimer.startPomo()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: pomoTimer.secondPerWork + pomoTimer.secondPerBreak))
        pomoTimer.pausePomo()
        XCTAssertFalse(pomoTimer.mode == .breaking(timeInterval: pomoTimer.secondPerBreak))
        XCTAssertTrue(pomoTimer.mode == .working(timeInterval: pomoTimer.secondPerWork))
        XCTAssertTrue(pomoTimer.currentPomo == 1)
    }
    
    func testLongRestMode() {
        pomoTimer.secondPerWork = 2
        pomoTimer.secondPerBreak = 1
        pomoTimer.secondPerLongRest = 3
        pomoTimer.startPomo()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: (pomoTimer.secondPerWork + pomoTimer.secondPerBreak) * 4))
        pomoTimer.pausePomo()
        XCTAssertTrue(pomoTimer.mode == .longRest(timeInterval: pomoTimer.secondPerLongRest))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
