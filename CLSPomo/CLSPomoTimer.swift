//
//  CLSPomoTimer.swift
//  CLSPomo
//
//  Created by Seungwon on 2018. 7. 1..
//  Copyright © 2018년 Seungwon. All rights reserved.
//

import UIKit

class CLSPomoTimer: NSObject {
    var isRunning: Bool = false

    func startPomo() {
        isRunning = true
    }
    
    func pausePomo() {
        isRunning = false
    }
    
    func resumePomo() {
        isRunning = true
    }
}
