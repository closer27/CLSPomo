//
//  CLSPomoTimer.swift
//  CLSPomo
//
//  Created by Seungwon on 2018. 7. 1..
//  Copyright © 2018년 Seungwon. All rights reserved.
//

import UIKit

class CLSPomoTimer: NSObject {
    var currentTime: TimeInterval = 0
    var timer: Timer!
    var isRunning: Bool = false
    
    override init() {
        super.init()
        timer = Timer(timeInterval: 1, repeats: true, block: { [unowned self] (timer) in
            self.currentTime += 1
        })
    }

    func startPomo() {
        isRunning = true
        timer?.fire()
    }
    
    func stopPomo() {
        isRunning = false
        timer.invalidate()
        currentTime = 0
    }
    
    func pausePomo() {
        isRunning = false
    }
    
    func resumePomo() {
        isRunning = true
    }
}
