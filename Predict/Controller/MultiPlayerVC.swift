//
//  MultiPlayerVC.swift
//  Predict
//
//  Created by Japneet Singh on 19/02/20.
//  Copyright © 2020 Japneet Singhl. All rights reserved.
//

import UIKit

class MultiPlayerVC: UIViewController {

    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerOneScoreStack: UIStackView!
    @IBOutlet weak var playerOneSlider: UISlider!
    @IBOutlet weak var playerOneCheckButton: UIButton!
    @IBOutlet weak var playerOneRandomNumber: UILabel!
    @IBOutlet weak var playerOneTimer: UILabel!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerOneTimerImage: UIImageView!
    
    @IBOutlet weak var playerOneSliderValueLabel: UILabel!
    @IBOutlet weak var playerTwoSliderValueLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var playerOneNumberLimitStack: UIStackView!
    
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var playerTwoSlider: UISlider!
    @IBOutlet weak var playerTwoCheckButton: UIButton!
    @IBOutlet weak var playerTwoRandomNumber: UILabel!
    @IBOutlet weak var playerTwoTimer: UILabel!
    
    let featuresPlayerOne = Features()
    let featuresPlayerTwo = Features()
    let score = Score.instance
    
    let level = Levels.Hard
    
    var counterPlayerOne = 15
    var counterPlayerTwo = 15
    
    //If its value is two that means both players have taped check button
    var completionCounter : Int = 0
    
    var motionGestureEnabled = true
    
    //Scores
    var playerOneScore : Int = 0
    var playerTwoScore : Int = 0
    
    var playerOneRandomGeneratedNumber : Int = 0
    var playerTwoRandomGeneratedNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotatePlayerOneUI()
        
        playerOneSliderValueLabel.isHidden = true
        playerTwoSliderValueLabel.isHidden = true
    }
    
    func rotatePlayerOneUI() {
        playerOneCheckButton.rotate(angle: 180)
        playerOneSlider.rotate(angle: 180)
        playerOneRandomNumber.rotate(angle: 180)
        playerOneTimer.rotate(angle: 180)
        playerOneLabel.rotate(angle: 180)
        playerOneNumberLimitStack.rotate(angle: 180)
        playerOneScoreStack.rotate(angle: 180)
        playerOneTimerImage.rotate(angle: 180)
        playerOneSliderValueLabel.rotate(angle: 180)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            if motionGestureEnabled {
                motionGestureEnabled = false
                
                playerOneSliderValueLabel.isHidden = true
                playerTwoSliderValueLabel.isHidden = true
                
                playerOneLabel.text = "1"
                playerTwoLabel.text = "2"
                
                playerOneSlider.isEnabled = true
                playerOneSlider.setValue(500, animated: true)
                playerTwoSlider.isEnabled = true
                playerTwoSlider.setValue(500, animated: true)
                
                featuresPlayerOne.vibrateDevice()
                
                playerOneRandomGeneratedNumber = featuresPlayerOne.levelSelection(level: level)
                playerTwoRandomGeneratedNumber = featuresPlayerTwo.levelSelection(level: level)
                
                playerOneRandomNumber.text = String(playerOneRandomGeneratedNumber)
                playerTwoRandomNumber.text = String(playerTwoRandomGeneratedNumber)
                featuresPlayerOne.shakeDeviceSound()
                
                counterPlayerOne = 15
                counterPlayerTwo = 15
                completionCounter = 0
                
                //Starts Count Down
                featuresPlayerOne.startTimer(selector: #selector(updateCounterPlayerOne),target: self)
                featuresPlayerTwo.startTimer(selector: #selector(updateCounterPlayerTwo),target: self)
                
                //Enables the Check Button
                playerOneCheckButton.isEnabled = true
                playerTwoCheckButton.isEnabled = true
            }
            
        }
    }
    @IBAction func playerOneCheckButtonPressed(_ sender: Any) {
        scoreCheckFunctionPlayerOne()
    }
    
    @IBAction func playerTwoCheckButtonPressed(_ sender: Any) {
        scoreCheckFunctionPlayerTwo()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
        featuresPlayerOne.stopTimer()
        featuresPlayerTwo.stopTimer()
        
    }
    
    @objc func updateCounterPlayerOne() {
        if counterPlayerOne >= 0 {
            if counterPlayerOne == 0 {
                scoreCheckFunctionPlayerOne()
            }
            let count = String(counterPlayerOne)
            playerOneTimer.text = count.count > 1 ? count : "0\(count)"
            counterPlayerOne -= 1
        }
    }
    
    @objc func updateCounterPlayerTwo() {
        if counterPlayerTwo >= 0 {
            if counterPlayerTwo == 0 {
                scoreCheckFunctionPlayerTwo()
            }
            let count = String(counterPlayerTwo)
            playerTwoTimer.text = count.count > 1 ? count : "0\(count)"
            counterPlayerTwo -= 1
        }
    }
    
    func scoreCheckFunctionPlayerOne() {
        featuresPlayerOne.stopTimer()
        featuresPlayerOne.timeOverSound()
        playerOneSlider.isEnabled = false
        playerOneScore = score.calculateScore(sliderNumber: playerOneSlider.value, randomGeneratedNumber: playerOneRandomGeneratedNumber, timeRemaining: counterPlayerOne, totalTime: counterPlayerOne)
        completionCounter = completionCounter + 1
        
        playerOneScoreLabel.text = playerOneScore.description
        playerOneCheckButton.isEnabled = false
        
        if completionCounter == 2 {
            motionGestureEnabled = true
            checkWhoWon()
        }
        
    }
    
    func scoreCheckFunctionPlayerTwo() {
        featuresPlayerTwo.stopTimer()
        featuresPlayerTwo.timeOverSound()
        playerTwoSlider.isEnabled = false
        playerTwoScore = score.calculateScore(sliderNumber: playerTwoSlider.value, randomGeneratedNumber: playerTwoRandomGeneratedNumber, timeRemaining: counterPlayerTwo, totalTime: counterPlayerTwo)
        
        completionCounter = completionCounter + 1
        
        playerTwoScoreLabel.text = playerTwoScore.description
        playerTwoCheckButton.isEnabled = false
        
        if completionCounter == 2 {
            motionGestureEnabled = true
            checkWhoWon()
        }
        
    }
    
    func checkWhoWon() {
        playerOneSliderValueLabel.isHidden = false
        playerOneSliderValueLabel.text = "Your Prediction : \(Int(playerOneSlider.value))"
        playerTwoSliderValueLabel.isHidden = false
        playerTwoSliderValueLabel.text = "Your Prediction : \(Int(playerTwoSlider.value))"
        
        if playerOneScore > playerTwoScore {
            playerOneLabel.text = "Won"
            playerTwoLabel.text = "Lost"
        } else if playerTwoScore > playerOneScore {
            playerOneLabel.text = "Lost"
            playerTwoLabel.text = "Won"
        } else if playerOneScore == playerTwoScore {
            if playerOneScore != 0 {
                playerOneLabel.text = "Draw"
                playerTwoLabel.text = "Draw"
            }
        }
    }
    
}

