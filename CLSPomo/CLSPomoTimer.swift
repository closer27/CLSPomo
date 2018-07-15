//
//  CLSPomoTimer.swift
//  CLSPomo
//
//  Created by Seungwon on 2018. 7. 1..
//  Copyright © 2018년 Seungwon. All rights reserved.
//

import UIKit
import RxSwift

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
    var timer: DispatchSourceTimer?
    var isRunning: Variable<Bool>
    
    var currentPomo: Int    // 1 work + 1 break = 1 pomo
    var mode: TimeMode

    var secondPerWork: TimeInterval
    var secondPerBreak: TimeInterval
    var secondPerLongRest: TimeInterval
    var elapsedTime: TimeInterval
    var elapsedTimeSubject: PublishSubject<TimeInterval>!
    var totalTimeToReach: TimeInterval {
        get {
            switch mode {
            case .working(let timeInterval), .breaking(let timeInterval), .longRest(let timeInterval):
                return timeInterval
            }
        }
    }
    var remainingTime: Variable<TimeInterval>
    
    let disposeBag = DisposeBag()

    init(secondPerWork: TimeInterval, secondPerBreak: TimeInterval, secondPerLongRest: TimeInterval) {
        self.secondPerWork = secondPerWork
        self.secondPerBreak = secondPerBreak
        self.secondPerLongRest = secondPerLongRest
        
        isRunning = Variable(false)
        mode = TimeMode.working(timeInterval: secondPerWork)
        currentPomo = 0
        elapsedTime = 0
        remainingTime = Variable(secondPerWork)
    }

    func startPomo() {
        isRunning.value = true
        
        // init time mode to working
        initTimeMode()

        // subscribe elapsed time subject
        elapsedTimeSubject = PublishSubject()
        let subscription = elapsedTimeSubject.subscribe(onNext: { [unowned self] (timeInterval) in
            print(self.totalTimeToReach)
            print(self.elapsedTime)
            self.remainingTime.value = self.totalTimeToReach - self.elapsedTime
        })
        subscription.disposed(by: disposeBag)
        
        // set timer
        let queue = DispatchQueue(label: "com.closer27.CLSPomo.timer", attributes: .concurrent)
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        timer?.schedule(deadline: .now() + .seconds(1), repeating: .seconds(1), leeway: .milliseconds(100))
        timer?.setEventHandler { [weak self] in
            self?.checkTimer()
        }
        timer?.resume()
    }
    
    func stopPomo() {
        isRunning.value = false
        timer?.cancel()
        timer = nil
        initTimeMode()
        clearCurrentTime()
    }
    
    func pausePomo() {
        isRunning.value = false
    }
    
    func resumePomo() {
        isRunning.value = true
    }
    
    private func checkTimer() {
        increaseSecond()
        checkMode()
    }
    
    func checkMode() {
        switch (self.mode) {
        case .working(let timeInterval):
            print("working mode", timeInterval)
            if elapsedTime >= timeInterval {
                print("complete working session")
                switchMode()
                clearCurrentTime()
            }
        case .breaking(let timeInterval):
            print("breaking mode", timeInterval)
            if elapsedTime >= timeInterval {
                print("complete breaking session, increase 1 pomo")
                increasePomo()
                switchMode()
                clearCurrentTime()
            }
        case .longRest(let timeInterval):
            print("longRest mode", timeInterval)
            if elapsedTime >= timeInterval {
                print("complete breaking session, increase 1 pomo")
                switchMode()
                clearCurrentTime()
            }
        }
    }
    
    private func initTimeMode() {
        mode = .working(timeInterval: secondPerWork)
    }
    
    private func switchMode() {
        switch mode {
        case .working(_):
            mode = .breaking(timeInterval: secondPerBreak)
        case .breaking(_):
            if currentPomo != 0 && currentPomo % 4 == 0 {
                mode = .longRest(timeInterval: secondPerLongRest)
            } else {
                mode = .working(timeInterval: secondPerWork)
            }
        case .longRest(_):
            mode = .working(timeInterval: secondPerWork)
        }
    }
    
    private func increaseSecond() {
        elapsedTime += 1
        elapsedTimeSubject.onNext(elapsedTime)
    }
    
    private func clearCurrentTime() {
        elapsedTime = 0
        elapsedTimeSubject.onNext(elapsedTime)
    }
    
    private func increasePomo() {
        currentPomo += 1
    }
}
