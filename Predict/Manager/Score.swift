//
//  Score.swift
//  Predict
//
//  Created by Japneet Singh on 18/02/20.
//  Copyright © 2020 Japneet Singhl. All rights reserved.
//

import Foundation

class Score {
    static let instance = Score()
    var currentScore : Float = 00
    var level : Levels = Levels.Easy
    
    func calculateScore(sliderNumber : Float, randomGeneratedNumber : Int, timeRemaining : Int, totalTime : Int) -> Int{
        
        switch level {
        case .Easy:
            let score = levelEasy(sliderNumber, randomGeneratedNumber)
            currentScore = score == 0.0 ? 0.0 : score + Float(timeRemaining)
            return self.roundOffInto100(score: currentScore, totalTime: totalTime)
        case .Medium:
            let score = levelMedium(sliderNumber, randomGeneratedNumber)
            currentScore = score == 0.0 ? 0.0 : score + Float(timeRemaining)
            return self.roundOffInto100(score: currentScore, totalTime: totalTime)
        case .Hard:
            let score = levelHard(sliderNumber, randomGeneratedNumber)
            currentScore = score == 0.0 ? 0.0 : score + Float(timeRemaining)
            return self.roundOffInto100(score: currentScore, totalTime: totalTime)
        }
    }
    
    private func levelEasy(_ sliderNumber : Float, _ randomGeneratedNumber : Int) -> Float {
        
        let difference = abs(Float(randomGeneratedNumber) - sliderNumber)
        
        if difference <= 15 && difference > 0 {
            return 100.0
        } else if difference <= 25 && difference > 15 {
            return 50.0
        } else if difference <= 30 && difference > 25 {
            return 20.0
        } else {
            return 0.0
        }
        
    }
    
    private func levelMedium(_ sliderNumber : Float, _ randomGeneratedNumber : Int) -> Float {
        let difference = Float(randomGeneratedNumber) - sliderNumber
        
        if difference <= 25 && difference > 0 {
            return 100.0
        } else if difference <= 35 && difference > 25 {
            return 50.0
        } else if difference <= 40 && difference > 35 {
            return 20.0
        } else {
            return 0.0
        }
    }
    
    private func levelHard(_ sliderNumber : Float, _ randomGeneratedNumber : Int) -> Float {
        
        let difference = Float(randomGeneratedNumber) - sliderNumber
        
        if difference <= 35 && difference > 0{
            return 100.0
        } else if difference <= 50 && difference > 35 {
            return 50.0
        } else if difference <= 60 && difference > 50 {
            return 20.0
        } else {
            return 0.0
        }
        
    }
    
    func roundOffInto100(score : Float, totalTime : Int) -> Int{
        let maximumScorePossible = 100 + totalTime
        let finalScore = (100 * score) / Float(maximumScorePossible)
        return Int(finalScore)
    }
    
}
