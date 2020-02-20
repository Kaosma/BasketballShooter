//
//  StorageViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-02-19.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation
import UIKit
extension ViewController {
    // MARK: Storage Functions
    // Saving the percentage updates with user default storage
    func savePercentage() -> Double {
        let newPercentage = UserDefaults.standard.object(forKey: percentageKey) as? Double
        
        if let percentage = newPercentage {
            return percentage
        } else {
            return startingPercentage
        }
    }
    // Saving the updated percentage for the user
    func savePercentageSelected(percentage: Double) {
        let defaults = UserDefaults.standard
        defaults.set(percentage, forKey: percentageKey)
        defaults.synchronize()
    }
    // Saving the ball value with user default storage
    func saveBallValue() -> Int {
        let newBallValue = UserDefaults.standard.object(forKey: ballValueKey) as? Int
        
        if let ballValue = newBallValue {
            return ballValue
        } else {
            return 1
        }
    }
    // Saving the updated ball value for the user
    func saveBallValueSelected(ballValue: Int) {
        let defaults = UserDefaults.standard
        defaults.set(ballValue, forKey: ballValueKey)
        defaults.synchronize()
    }
    // Saving the score updates with user default storage
    func saveScore() -> Int {
        let newScore = UserDefaults.standard.object(forKey: scoreKey) as? Int
        
        if let score = newScore {
            return score
        } else {
            return 0
        }
    }
    // Saving the updated score for the user
    func saveScoreSelected(score: Int) {
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: scoreKey)
        defaults.synchronize()
    }
    // Saving the total score updates with user default storage
    func saveTotalScore() -> Int {
        let newScore = UserDefaults.standard.object(forKey: totalScoreKey) as? Int
        
        if let score = newScore {
            return score
        } else {
            return 0
        }
    }
    // Saving the updated total score for the user
    func saveTotalScoreSelected(score: Int) {
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: totalScoreKey)
        defaults.synchronize()
    }
    // Saving the total misses with user default storage
    func saveTotalMisses() -> Int {
        let newMiss = UserDefaults.standard.object(forKey: totalMissesKey) as? Int
        
        if let miss = newMiss {
            return miss
        } else {
            return 0
        }
    }
    // Saving the updated total misses for the user
    func saveTotalMissesSelected(misses: Int) {
        let defaults = UserDefaults.standard
        defaults.set(misses, forKey: totalMissesKey)
        defaults.synchronize()
    }
}
