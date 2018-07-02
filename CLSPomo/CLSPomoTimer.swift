//
//  CLSPomoTimer.swift
//  CLSPomo
//
//  Created by Seungwon on 2018. 7. 1..
//  Copyright © 2018년 Seungwon. All rights reserved.
//

import UIKit

enum TimeMode {
    case working(timeInterval: TimeInterval)
    case breaking(timeInterval: TimeInterval)
}

extension TimeMode: Equatable {
    static func == (lhs: TimeMode, rhs: TimeMode) -> Bool {
        if case .working(let lhsTimeInterval) = lhs,
            case .working(let rhsTimeInterval) = rhs {
            return lhsTimeInterval == rhsTimeInterval
        }
        if case .breaking(let lhsTimeInterval) = lhs,
            case .breaking(let rhsTimeInterval) = rhs {
            return lhsTimeInterval == rhsTimeInterval
        }
        return false
    }
}

class CLSPomoTimer: NSObject {
    var currentTime: TimeInterval = 0
    var timer: Timer!
    var isRunning: Bool = false
    
    var currentPomo: Int = 0    // 1 work + 1 break = 1 pomo
    var mode: TimeMode = TimeMode.working(timeInterval: 1500)

    private var _secondPerWork: TimeInterval = 1500  // 25 * 60
    var secondPerWork: TimeInterval {
        set {
            _secondPerWork = newValue
            mode = TimeMode.working(timeInterval: newValue)
        }
        get {
            return _secondPerWork
        }
    }
    private var _secondPerBreak: TimeInterval = 300  // 5 * 60
    var secondPerBreak: TimeInterval {
        set {
            _secondPerWork = newValue
            mode = TimeMode.breaking(timeInterval: newValue)
        }
        get {
            return _secondPerBreak
        }
    }
    
    override init() {
        super.init()
        
        self.timer = Timer(timeInterval: 1, repeats: true, block: { (timer) in
            self.checkTimer()
        })
        RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
    }

    func startPomo() {
        isRunning = true
        timer?.fire()
    }
    
    func stopPomo() {
        isRunning = false
        timer.invalidate()
        self.clearCurrentTime()
    }
    
    func pausePomo() {
        isRunning = false
    }
    
    func resumePomo() {
        isRunning = true
    }
    
    private func checkTimer() {
        increaseSecond()
        checkMode()
    }
    
    func checkMode() {
        switch (self.mode) {
            case let .working(timeInterval):
                print("working mode", timeInterval)
                if currentTime >= timeInterval {
                    print("complete working session")
                    mode = .breaking(timeInterval: secondPerBreak)
                    clearCurrentTime()
                }
            break
            case let .breaking(timeInterval):
                print("breaking mode")
                if self.currentTime >= timeInterval {
                    print("complete breaking session, increase 1 pomo")
                    increasePomo()
                    mode = .working(timeInterval: secondPerWork)
                    clearCurrentTime()
                }
            break
        }
    }
    
    private func increaseSecond() {
        self.currentTime += 1
        print(currentTime)
    }
    
    private func clearCurrentTime() {
        self.currentTime = 0
    }
    
    private func increasePomo() {
        self.currentPomo += 1
    }
}
