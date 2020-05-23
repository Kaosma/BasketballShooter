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
    func updateBoostItemValues() {
        for index in 0...itemList.count-1 {
            let item = itemList[index]
            let level = BoostItemLevelList[index]
            let boostPower = pow(1.5, level)
            item.cost = Int(Double(item.startCost) * Double(truncating: NSDecimalNumber(decimal: boostPower)))
            let indexDiff = index % 4
            if item.level < 5 {
                switch item.category {
                    case "Percentage":
                        item.boost = percentageValues[5*index+item.level]
                    case "Ballvalue":
                        item.boost = ballValues[5*indexDiff+item.level]
                    default:
                        break
                }
            }
        }
    }
    // Updates the boost values exponentially
    func updateBoostItemLabelValues() {
        updateBoostItemValues()
        let cell = currentBoostTableViewCell
        let item = currentBoostItem
        switch item?.category {
            case "Percentage":
                item?.boost = round(item!.boost*100)/100
                cell?.purchasedLabel.text = "+" + String(item!.boost) + "%"
            case "Ballvalue":
                cell?.purchasedLabel.text = "+" + String(item!.boost) + "🏀"
            case "Speed":
                cell?.purchasedLabel.text = "+" + String(item!.boost) + "s"
            default:
                cell?.purchasedLabel.text = ""
        }
        cell?.costLabel.text = "Cost: \(item!.cost)"
        if item?.level == 5 {
            cell?.purchasedLabel.alpha = 0.5
        }
        /*if let item = currentBoostItem {
            switch item.category {
                case "Percentage":
                    item.boost = round(item!.boost*100)/100
                    cell?.purchasedLabel.text = "+" + String(item.boost) + "%"
                case "Ballvalue":
                    cell?.purchasedLabel.text = "+" + String(item.boost) + "🏀"
                case "Speed":
                    cell?.purchasedLabel.text = "+" + String(item.boost) + "s"
                default:
                    cell?.purchasedLabel.text = ""
            }
            cell?.costLabel.text = "Cost: \(item.cost)"
            if item.level == 5 {
                cell?.purchasedLabel.alpha = 0.5
            }
        }*/
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
