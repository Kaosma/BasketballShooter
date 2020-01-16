//
//  ViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-10.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Variables
    let startingPercentage: Double = 50
    var percentage: Double = 50
    var madeShot: Bool = false
    var scoreCounter: Int = 0
    var missCounter: Int = 0
    let percentageKey = "percentage"
    
    // Outlet variables
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Randomizes number between 0-10000 and is checked by the percentage
    func shotTaken(percentage: Double) -> String {
        let randomNumber = Int(arc4random_uniform(10000)) + 1
        if (randomNumber < Int(percentage * 100)) {
            scoreCounter += 1
            updateScoreLabel()
            return "Make"
        } else {
            missCounter += 1
            return "Miss"
        }
    }
    
    // Updates the score label
    func updateScoreLabel() {
        scoreLabel.text = String(scoreCounter)
    }
    
    // Updates the percentage label
    func updatePercentageLabel(percentage: Double) {
        percentageLabel.text = String(percentage) + "%"
    }
    
    // Saves the percentage updates with user default storage
    func savePercentage() -> Double {
        let newPercentage = UserDefaults.standard.object(forKey: percentageKey) as? Double
        
        if let percentage = newPercentage {
            return percentage
        } else {
            return startingPercentage
        }
    }
    
    func saveSelected(percentage: Double) {
        let defaults = UserDefaults.standard
        defaults.set(percentage, forKey: percentageKey)
        defaults.synchronize()
    }
    
    // Reset button to reset the percentage to starting value (50%)
    @IBAction func resetButtonTest(_ sender: UIButton) {
        percentage = startingPercentage
        saveSelected(percentage: percentage)
        updatePercentageLabel(percentage: percentage)
    }
    
    // Shooting button
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        print(shotTaken(percentage: percentage))
        print(scoreCounter , "/", missCounter+scoreCounter)
    }
    
    // Main
    override func viewDidLoad() {
        super.viewDidLoad()
        percentage = savePercentage()
        updateScoreLabel()
        updatePercentageLabel(percentage: percentage)
        //alert dialogue
    }

}

/*

*/
