//
//  ViewController.swift
//  CLSPomo
//
//  Created by Seungwon on 2018. 7. 1..
//  Copyright © 2018년 Seungwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let pomoTimer = CLSPomoTimer()
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        pomoTimer.secondPerWork = 5
        pomoTimer.secondPerBreak = 3
        pomoTimer.secondPerLongRest = 6

        pomoTimer.remainingTime.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (timeInterval) in
                print(timeInterval)
                self.timeLabel.text = self.convertTimeForRemaining(timeInterval)
            }, onError: { (error) in
                print(error)
            }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pomoButtonPressed(_ sender: UIButton) {
        pomoTimer.startPomo()
    }
    
    private func convertTimeForRemaining(_ time: TimeInterval) -> String {
        let hours = Int(floor(time / 60))
        let minutes = Int(time) % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

