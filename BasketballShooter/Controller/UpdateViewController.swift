//
//  UpdateViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-02-19.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Update functions
    // Updates the score label
    func updateScoreLabel() {
        scoreLabel.text = String(scoreCounter)
    }
    // Updates the percentage label
    func updatePercentageLabel() {
        percentageLabel.text = String(percentage) + "%"
        tableViewPercentageLabel.text = percentageLabel.text
        packageTableViewPrecentageLabel.text = percentageLabel.text
    }
    // Updates the ball value label
    func updateBallValueLabel() {
        ballValueLabel.text = "Ball value: " + String(ballValue)
        pointsLabel.text = "+\(ballValue)"
    }
    // Updates button image in BoostItem cells
    func updateButtonImage(item: BoostItem) {
        let cell = currentBoostTableViewCell
        let button = cell?.itemBuyButton
        let level = String(item.level)
        let name = item.name.replacingOccurrences(of: " ", with: "").lowercased()
        let imageName = name+"Level"+level
        button?.setImage(UIImage(named: imageName), for: .normal)
    }
    // Updates point per second
    @objc func updatePPS() {
        var pps : Int = 0
        for points in ppsList {
            pps += points
        }
        ppsList.removeAll()
        
        velocityLabel.text = "PPS: \(pps)"
    }
}
