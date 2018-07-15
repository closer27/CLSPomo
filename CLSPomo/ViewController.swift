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
    var pomoTimer: CLSPomoTimer?
    let disposeBag = DisposeBag()
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var actionButton: CLSPomoButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pomoTimer = CLSPomoTimer(secondPerWork: 5, secondPerBreak: 3, secondPerLongRest: 6)
        pomoTimer?.remainingTime.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (timeInterval) in
                print(timeInterval)
                self?.timeLabel.text = self?.convertTimeForRemaining(timeInterval)
            }, onError: { (error) in
                print(error)
            }).disposed(by: disposeBag)
        
        pomoTimer?.isRunning.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isRunning in
                self?.actionButton.isRunning = isRunning
            }).disposed(by: disposeBag)
        
        actionButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.pomoTimer?.startPomo()
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func convertTimeForRemaining(_ time: TimeInterval) -> String {
        let hours = Int(floor(time / 60))
        let minutes = Int(time) % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

