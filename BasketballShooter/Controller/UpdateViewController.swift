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
    // Updates the shooter skinTone
    func updateShooterAnimationImages() {
        updateButtonColor(button: skinToneButton)
        shooterImage.image = UIImage(named: "shooting\(skinToneLevel+1)1")!
        let shootOne : UIImage = UIImage(named: "shooting\(skinToneLevel+1)1")!
        let shootTwo : UIImage = UIImage(named: "shooting\(skinToneLevel+1)2")!
        let shootThree : UIImage = UIImage(named: "shooting\(skinToneLevel+1)3")!
        let shootFour : UIImage = UIImage(named: "shooting\(skinToneLevel+1)4")!
        let shootFive : UIImage = UIImage(named: "shooting\(skinToneLevel+1)5")!
        let shootSix : UIImage = UIImage(named: "shooting\(skinToneLevel+1)6")!
        shooterImages = [shootOne, shootTwo, shootThree, shootFour, shootThree, shootTwo, shootOne, shootFive, shootSix, shootSix, shootFive]
    }
    // Updates the skinToneButton color
    func updateButtonColor(button: UIButton) {
        let color = UIColor(hex: skinTones[skinToneLevel])
        button.backgroundColor = color
    }
    // Updates the boost values exponentially
    func updateBoostPercentageValue() {
        for i in 0...2 {
            let boostPower = pow(1.4, BoostItemLevelList[i])
            itemList[i].boost = itemList[i].boost * Double(truncating: NSDecimalNumber(decimal: boostPower))
            itemList[i].boost = round(itemList[i].boost*100)/100
        }
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
