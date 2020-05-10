//
//  Features.swift
//  Predict
//
//  Created by Japneet Singh on 17/02/20.
//  Copyright © 2020 Japneet Singh. All rights reserved.
//

import Foundation
import AVFoundation

enum Levels {
    case Easy
    case Medium
    case Hard
}

class Features {
    private var timer = Timer()
    private var counter = 10
    
    func vibrateDevice() {
        let vibrate : SystemSoundID = 4095
        AudioServicesPlayAlertSound(vibrate)
    }
    
    func shakeDeviceSound() {
        let shakeSound: SystemSoundID = 1109
        AudioServicesPlayAlertSound(shakeSound)
    }
    
    func timeOverSound() {
        let timeOverSound: SystemSoundID = 1051
        AudioServicesPlayAlertSound(timeOverSound)
    }
    
    private func generateRandomNumbers(from lowerLimit : Int,to upperLimit: Int) -> Int {
        
        let no = upperLimit > lowerLimit ? Int.random(in: lowerLimit...upperLimit) : Int.random(in: upperLimit...lowerLimit)
        return no
    }
    
    func levelSelection(level : Levels = Levels.Easy) -> Int{
        switch level {
        case Levels.Easy:
            return self.generateRandomNumbers(from: 0, to: 100)
        case Levels.Medium:
            return self.generateRandomNumbers(from: 0, to: 500)
        case .Hard:
            return self.generateRandomNumbers(from: 0, to: 1000)
        }
    }
    
    func startTimer(selector : Selector, target : Any) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: target, selector: selector, userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
}
