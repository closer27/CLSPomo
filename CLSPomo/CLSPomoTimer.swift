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
    case longRest(timeInterval: TimeInterval)
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
        if case .longRest(let lhsTimeInterval) = lhs,
            case .longRest(let rhsTimeInterval) = rhs {
            return lhsTimeInterval == rhsTimeInterval
        }
        return false
    }
}

class CLSPomoTimer: NSObject {
    var currentTime: TimeInterval = 0
    var timer: DispatchSourceTimer?
    var isRunning: Bool = false
    
    var currentPomo: Int = 0    // 1 work + 1 break = 1 pomo
    var mode: TimeMode = TimeMode.working(timeInterval: 1500)

    var secondPerWork: TimeInterval = 1500  // 25 * 60
    var secondPerBreak: TimeInterval = 300  // 5 * 60
    var secondPerLongRest: TimeInterval = 1800  // 30 * 60
    
    override init() {
        super.init()
    }

    func startPomo() {
        isRunning = true
        
        // init time mode to working
        mode = TimeMode.working(timeInterval: secondPerWork)
        
        // set timer
        let queue = DispatchQueue(label: "com.closer27.CLSPomo.timer", attributes: .concurrent)
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(100))
        timer?.setEventHandler { [weak self] in
            self?.checkTimer()
        }
        timer?.resume()
    }
    
    func stopPomo() {
        isRunning = false
        timer?.cancel()
        timer = nil
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
            print("breaking mode", timeInterval)
            if self.currentTime >= timeInterval {
                print("complete breaking session, increase 1 pomo")
                increasePomo()
                switchMode()
                clearCurrentTime()
            }
        break
        case .longRest(let timeInterval):
            print("longRest mode", timeInterval)
            if self.currentTime >= timeInterval {
                print("complete breaking session, increase 1 pomo")
                increasePomo()
                mode = .working(timeInterval: secondPerWork)
                clearCurrentTime()
            }
        }
    }
    
    private func switchMode() {
        if currentPomo % 4 == 0 {
            mode = .longRest(timeInterval: secondPerLongRest)
        } else {
            mode = .working(timeInterval: secondPerWork)
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
