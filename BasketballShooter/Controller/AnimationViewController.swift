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
    // Animating the shooter's movement
    func shootingAnimation() {
        shooterImage.animationImages = shooterImages
        shooterImage.animationDuration = 1.0/speedFactor
        shooterImage.animationRepeatCount = 1
        UIView.animate(withDuration: 0.07/speedFactor, delay: 0.07/speedFactor, animations: {
            self.jerseyImageView.transform = CGAffineTransform(translationX: 0, y: 13/3)
            self.jerseyNumberLabel.transform = CGAffineTransform(translationX: 0, y: 13/3)
        }, completion: thirdJerseyLevel(finished:))
        shooterImage.startAnimating()
    }
    // Animating the jersey in the shooter's movement
    func secondJerseyLevel(finished: Bool) {
        UIView.animate(withDuration: 0.07/speedFactor, animations: {
            self.jerseyImageView.transform = CGAffineTransform(translationX: 0, y: 13/3)
            self.jerseyNumberLabel.transform = CGAffineTransform(translationX: 0, y: 13/3)
        }, completion: returnJerseyAnimation(finished:))
    }
    func thirdJerseyLevel(finished: Bool) {
        if jerseyVectorUp {
            UIView.animate(withDuration: 0.07/speedFactor, delay: 0.1/speedFactor, animations: {
                self.jerseyImageView.transform = CGAffineTransform(translationX: 0, y: 26/3)
                self.jerseyNumberLabel.transform = CGAffineTransform(translationX: 0, y: 26/3)
            }, completion: secondJerseyLevel(finished:))
        } else {
            UIView.animate(withDuration: 0.07/speedFactor, animations: {
                self.jerseyImageView.transform = CGAffineTransform(translationX: 0, y: 26/3)
                self.jerseyNumberLabel.transform = CGAffineTransform(translationX: 0, y: 26/3)
            }, completion: fourthJerseyLevel(finished:))
        }
    }
    func fourthJerseyLevel(finished: Bool) {
        jerseyVectorUp = true
        UIView.animate(withDuration: 0.07/speedFactor, animations: {
            self.jerseyImageView.transform = CGAffineTransform(translationX: 0, y: 13)
            self.jerseyNumberLabel.transform = CGAffineTransform(translationX: 0, y: 13)
        }, completion: thirdJerseyLevel(finished:))
    }
    // Getting the jersey back to it's original spot .identity after shooting animation
    func returnJerseyAnimation(finished: Bool) {
        jerseyVectorUp = false
        UIView.animate(withDuration: 0.07/speedFactor, animations: {
            self.jerseyImageView.transform = .identity
            self.jerseyNumberLabel.transform = .identity
        })
    }
    // Ballrotation animation
    func ballRotationAnimation() {
        currentBall!.animationImages = ballImages
        currentBall!.animationDuration = 1.8/speedFactor
        currentBall!.startAnimating()
    }
    // Animation for made shot
    func makeAnimation() {
        alowTap = false
        UIView.animate(withDuration: 0.8/speedFactor, delay: 0.5/speedFactor, animations: {
            self.currentBall!.transform = CGAffineTransform(translationX: 0, y: -((self.currentBall?.frame.minY)!-self.hoopImageView.frame.minY)/1.3)
        }, completion: ballBounce(finished:))
        UIView.animate(withDuration: 0.5/speedFactor, delay: 1.7/speedFactor, animations: {
            self.currentBall!.alpha = 0.0
        }, completion: switchBall(finished:))
    }
    // Ball transparency fade animation
    func switchBall(finished: Bool) {
        self.currentBall!.stopAnimating()
        self.ballArray.append(self.currentBall!)
        self.currentBall?.isHidden = true
        self.currentBall?.alpha = 1.0
        self.currentBall = self.ballArray[0]
        self.ballArray.removeFirst(1)
        self.currentBall?.isHidden = false
        alowTap = true
    }
//    func makeBallVisible(finished: Bool) {
//        UIView.animate(withDuration: 0.05, animations: {
//            self.currentBall!.alpha = 1.0
//        })
//    }
    // Getting the ball back to it's original spot .identity
    func ballBounce (finished: Bool) {
//        UIView.animate(withDuration: 0.05, delay:0.1 , animations: {
//            self.currentBall!.alpha = 0.0
//        }, completion: makeBallVisible(finished:))
        UIView.animate(withDuration: 0.5/speedFactor, animations: {
            self.currentBall!.transform = .identity
        })
    }
    // Animation for missed shot
    func leftMissAnimation() {
        alowTap = false
    }
    // Animation for missed shot
    func firstMissAnimation() {
        alowTap = false
        UIView.animate(withDuration: 0.8/speedFactor, delay: 0.5/speedFactor, animations: {
            self.currentBall!.transform = CGAffineTransform(translationX: CGFloat(self.xFactorCoordinate)*(self.currentBall?.frame.size.width)!, y: -((self.currentBall?.frame.minY)! - self.hoopImageView.frame.minY)/1.3)
        }, completion: rimBounceAnimation(finished:))
    }
    // Animation to bounce ball on the rim
    func rimBounceAnimation(finished: Bool) {
        UIView.animate(withDuration: 0.4/speedFactor, animations: {
            self.currentBall!.transform = CGAffineTransform(translationX: CGFloat(self.xFactorCoordinate)*( self.currentBall?.frame.size.width)!, y: -self.hoopImageView.frame.maxY)
        }, completion: rimBounceOff(finished:))
    }
    // Missanimation after a rimbounce or airball
    func rimBounceOff(finished: Bool) {
        secondMissAnimation(duration: 0.45/speedFactor, delay: 0.001/speedFactor)
    }
    func secondMissAnimation(duration: Double, delay: Double) {
        UIView.animate(withDuration: duration, delay: delay, animations: {
            self.currentBall!.transform = CGAffineTransform(translationX: CGFloat(2*self.xFactorCoordinate)*( self.currentBall?.frame.size.width)!, y: -self.hoopImageView.frame.maxY-(self.currentBall?.frame.size.height)!)
        }, completion: ballDropMiss(finished:))
        UIView.animate(withDuration: 0.5/speedFactor, delay: 0.6/speedFactor, animations: {
            self.currentBall!.alpha = 0.0
        }, completion: switchBall(finished:))
    }
    // Balldrop after missanimation
    func ballDropMiss(finished: Bool) {
        UIView.animate(withDuration: 0.4/speedFactor, animations: {
            self.currentBall!.transform = CGAffineTransform(translationX: CGFloat(2*self.xFactorCoordinate)*( self.currentBall?.frame.size.width)!, y: -(self.currentBall?.frame.height)!)
        }, completion: ballBounce(finished:))
    }
    // Animation for buying a boostItem
    func boostBuyAnimation(object: UIView) {
        UIView.animate(withDuration: 3.0, animations: {
            object.frame.size.height = 140
            self.userEnableCells(enable: false)
        }, completion: hideAlphaView(finished:))
    }
    
    // Hides the alphaView after the buying animation
    func hideAlphaView(finished:Bool ) {
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
        UIView.animate(withDuration: 1.0/speedFactor, delay: 1.3/speedFactor, animations: {
            self.pointsLabel.alpha = 1.0
        }, completion: hidePointsLabel(finished:))
    }
    // Ball transparency fade animation
    func hidePointsLabel(finished: Bool) {
        self.updateScoreLabel()
        UIView.animate(withDuration: 0.5/speedFactor, animations: {
            self.pointsLabel.alpha = 0.0
        } )
    }
}
