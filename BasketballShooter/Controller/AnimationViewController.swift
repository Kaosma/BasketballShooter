//
//  AnimationViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-02-19.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Animation Functions
    // Navigation animation for the navigationbuttons
    func navigationAnimation(button : UIButton, view : UIView){
        if button.alpha == 0.5 {
            for anyView in navigationViewList {
                anyView.isHidden = true
                anyView.isUserInteractionEnabled = false
                button.alpha = 1.0
            }
        } else {
            var index = 0
            for anyView in navigationViewList {
                if anyView != view {
                    anyView.isHidden = true
                    anyView.isUserInteractionEnabled = false
                    navigationButtonList[index].alpha = 1.0
                } else {
                    anyView.isHidden = false
                    anyView.isUserInteractionEnabled = true
                    button.alpha = 0.5
                }
                index += 1
            }
        }
    }
    // Ballrotation animation
    func ballRotationAnimation() {
//        self.currentBall!.animationImages = ballImages
//        self.currentBall!.animationDuration = 1.2
//        self.currentBall!.startAnimating()
    }
    // Animation for made shot
    func makeAnimation() {
        alowTap = false
        UIView.animate(withDuration: 0.6, animations: {
            self.currentBall!.transform = CGAffineTransform(translationX: 0, y: -180)
        }, completion: ballBounce(finished:))
        UIView.animate(withDuration: 0.7, delay: 0.8, animations: {
            self.currentBall!.alpha = 0.0
        }, completion: switchBall(finished:))
    }
    // Ball transparency fade animation
    func switchBall(finished: Bool) {
        self.ballArray.append(self.currentBall!)
        self.currentBall?.isHidden = true
        self.currentBall?.alpha = 1.0
        self.currentBall = self.ballArray[0]
        self.ballArray.removeFirst(1)
        self.currentBall?.isHidden = false
        alowTap = true
    }
    func ballBounce (finished: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.currentBall!.transform = .identity
        })
    }
    // Animation for missed shot
    func missAnimation() {
        
    }
    // Animation for buying a boostItem
    func boostBuyAnimation(object: UIView) {
        UIView.animate(withDuration: 3.0, animations: {
            object.frame.size.height = 140
            self.userEnableCells(enable: false)
        }, completion: hideAlphaView(finished:))
    }
    // Hides the alphaView after the buying animation
    func hideAlphaView(finished:Bool) {
        updatePercentageLabel()
        updateBallValueLabel()
        currentBoostTableViewCell?.alphaView.isHidden = true
        updateButtonImage(item: currentBoostItem!)
        currentBoostTableViewCell?.levelLabel.text = "Lv. " + String(currentBoostItem!.level)
        userEnableCells(enable: true)
    }
    // Animation showing how many points made
    func pointsShowAnimation(){
        var randomX = CGFloat(arc4random_uniform(285)+45)
        var randomY = CGFloat(arc4random_uniform(232)+50)
        while (Int(randomX) > 85 && Int(randomX) < 250) {
            randomX = CGFloat(arc4random_uniform(285)+45)
        }
        while (Int(randomY) > 70 && Int(randomY) < 230) {
            randomY = CGFloat(arc4random_uniform(232)+50)
        }
        self.pointsLabel.frame.origin = CGPoint(x: randomX, y: randomY)
        UIView.animate(withDuration: 1.0, animations: {
            self.pointsLabel.alpha = 1.0
        }, completion: hidePointsLabel(finished:))
    }
    // Ball transparency fade animation
    func hidePointsLabel(finished: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.pointsLabel.alpha = 0.0
        } )
    }
}
