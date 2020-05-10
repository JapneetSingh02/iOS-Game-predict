//
//  ViewController.swift
//  Predict
//
//  Created by Japneet Singh on 17/02/20.
//  Copyright © 2020 Japneet Singh. All rights reserved.
//

// Multi Player Funtionality can be added

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    @IBOutlet weak var upperLimitLabel: UILabel!
    @IBOutlet weak var lowerLimitLabel: UILabel!
    
    @IBOutlet weak var randomNumberLabel: UILabel!
    @IBOutlet weak var shakeToStartLabel: UILabel!
    
    @IBOutlet weak var numberSlider: UISlider!
    
    @IBOutlet weak var levelChangerSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var tryButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var logo: UIImageView!
    
    var level : Levels!
    var counter = 10
    var randomNumberGenerated : Int = 0
    var motionGestureEnabled = true
    var timer = Timer()
    let features = Features()
    let score = Score.instance
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level = score.level
        scoreLabel.text = Int(score.currentScore).description + "0"
        numberSlider.isEnabled = false
        timerLabel.isHidden = true
        sliderValueLabel.isHidden = true
        checkButton.isEnabled = false
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    @IBAction func tryButtonToGenerateNumber(_ sender: UIButton) {
        motionGestureEnabled = false
        tryButton.isEnabled = false
        generateRandomNumber()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if motionGestureEnabled {
                motionGestureEnabled = false
                tryButton.isEnabled = false
                generateRandomNumber()
            }
        }
    }
    
    func generateRandomNumber() {
        if sliderValueLabel.text != "" {
            sliderValueLabel.text = ""
        }
        shakeToStartLabel.isHidden = true
        randomNumberLabel.isHidden = false
        features.vibrateDevice()
        randomNumberGenerated = features.levelSelection(level: level)
        randomNumberLabel.text = String(randomNumberGenerated)
        features.shakeDeviceSound()
        numberSlider.isEnabled = true
        numberSlider.setValue(level == Levels.Easy ? 50 : level == Levels.Medium ? 250 : 500, animated: true)
        counter = 10
        features.startTimer(selector: #selector(updateCounter),target: self)
        timerLabel.isHidden = false
        timerLabel.text = "10"
        checkButton.isEnabled = true
        levelChangerSegmentControl.isEnabled = false
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        scoreCheckFunction()
    }
    
    @IBAction func levelChanged(_ sender: Any) {
        switch levelChangerSegmentControl.selectedSegmentIndex {
        case 0:
            level = Levels.Easy
            setLimits(lowerLimit: 0, upperLimit: 100)
        case 1:
            level = Levels.Medium
            setLimits(lowerLimit: 0, upperLimit: 500)
        case 2:
            level = Levels.Hard
            setLimits(lowerLimit: 0, upperLimit: 1000)
        default:
            level = Levels.Easy
            setLimits(lowerLimit: 0, upperLimit: 100)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        scoreLabel.text = "00"
        levelChangerSegmentControl.setEnabled(true, forSegmentAt: 0)
        level = Levels.Easy
        setLimits(lowerLimit: 0, upperLimit: 100)
        levelChangerSegmentControl.isEnabled = true
        shakeToStartLabel.isHidden = false
        randomNumberLabel.isHidden = true
        timerLabel.isHidden = true
        sliderValueLabel.isHidden = true
        numberSlider.isEnabled = false
        if !motionGestureEnabled {
            motionGestureEnabled = true
        }
        tryButton.isEnabled = true
        timer.invalidate()
        features.stopTimer()
    }
    
    func setLimits(lowerLimit : Int, upperLimit : Int) {
        numberSlider.minimumValue = Float(lowerLimit)
        numberSlider.maximumValue = Float(upperLimit)
        numberSlider.setValue(Float(upperLimit + lowerLimit) / 2.0, animated: true)
        upperLimitLabel.text = String(upperLimit)
        lowerLimitLabel.text = String(lowerLimit)
    }
    
    func scoreCheckFunction() {
        sliderValueLabel.isHidden = false
        sliderValueLabel.text =
        "Your Prediction: \(Int(numberSlider.value).description)"
        features.stopTimer()
        features.timeOverSound()
        numberSlider.isEnabled = false
        scoreLabel.text = score.calculateScore(sliderNumber: numberSlider.value, randomGeneratedNumber: randomNumberGenerated, timeRemaining: counter, totalTime: counter).description
        checkButton.isEnabled = false
        motionGestureEnabled = true
        tryButton.isEnabled = true
        timerLabel.isHidden = true
    }
    
    @objc func updateCounter() {
        if counter >= 0 {
            if counter == 0 {
                scoreCheckFunction()
            }
            let count = String(counter)
            timerLabel.text = count.count > 1 ? count : "0\(count)"
            counter -= 1
        }
    }
}

