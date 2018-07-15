//
//  CLSPomoButton.swift
//  CLSPomo
//
//  Created by Seungwon on 2018. 7. 13..
//  Copyright © 2018년 Seungwon. All rights reserved.
//

import UIKit

class CLSPomoButton: UIButton {
    private var _isRunning = false
    var isRunning: Bool {
        set {
            _isRunning = newValue
            setTitle(isRunning: newValue)
        }
        get {
            return _isRunning
        }
    }
    
    func setTitle(isRunning: Bool) {
        isRunning ? setTitle("정지", for: .normal) : setTitle("시작", for: .normal)
    }
}
