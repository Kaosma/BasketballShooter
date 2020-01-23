//
//  ViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-10.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource{
    
    
    // MARK: Variables
    var percentage : Double = 50
    var madeShot : Bool = false
    var scoreCounter : Int = 0
    var missCounter : Int = 0
    var navigationButtonPressed : Bool = false
    var itemList = [BoostItem]()
    
    // MARK: Constants
    let startingPercentage : Double = 50
    let percentageKey = "percentage"
    let itemCellId =  "ItemCellId"
    
    // MARK: Outlet Variables
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var boostButton: UIButton!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var boostView: UIView!
    @IBOutlet weak var boostTableViewOutlet: UITableView!
    
    // MARK: Actions
    // Boostbutton pressed
    @IBAction func boostButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: boostView)
    }
    // Reset button to reset the percentage to starting value (50%)
    @IBAction func resetButtonTest(_ sender: UIButton) {
        percentage = startingPercentage
        saveSelected(percentage: percentage)
        updatePercentageLabel(percentage: percentage)
    }
    // Tap for every shot
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        print(shotTaken(percentage: percentage))
        print(scoreCounter , "/", missCounter+scoreCounter)
    }
    
    // MARK: Functions
    // Returns how many cells for the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemList.count
        }
    // Creating the cells for the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! BoostTableViewCell
        
        cell.itemLabel.text = itemList[indexPath.row].name
        cell.costLabel.text = String(itemList[indexPath.row].cost)
        
        return cell
    }
    // Navigation animation for the navigationbuttons
    func navigationAnimation(button : UIButton, view : UIView){
        if button.alpha == 1.0 {
            navigationButtonPressed = true
            view.isHidden = false
            view.isUserInteractionEnabled = true
            button.alpha = 0.5
        } else {
            navigationButtonPressed = false
            view.isHidden = true
            view.isUserInteractionEnabled = false
            button.alpha = 1.0
        }
    }
    // Randomizes number between 0-10000 and is checked by the percentage
    func shotTaken(percentage: Double) {
        let randomNumber = Int(arc4random_uniform(10000)) + 1
        if (randomNumber < Int(percentage * 100)) {
            makeAnimation()
            scoreCounter += 1
            updateScoreLabel()
            print("%: ",percentage)
            print("Make")
        } else {
            print("%: ",percentage)
            print("Miss")
            missCounter += 1
        }
    }
    // Animation for missed shot
    func missAnimation() {
        
    }
    // Animation for made shot
    func makeAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            
            var frame = self.ball.frame
            frame.origin.y += 4.5*frame.size.height
            self.ball.frame = frame
            
        })
        
        UIView.animate(withDuration: 1.2, animations: {self.ball.alpha = 0.0}, completion: makeBallVisible(finished:))
    }
    // Ball transparency fade animation
    func makeBallVisible(finished: Bool) {
        UIView.animate(withDuration: 1.2, animations: {self.ball.alpha = 1.0})
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
    // Saving the updated percentage for the user
    func saveSelected(percentage: Double) {
        let defaults = UserDefaults.standard
        defaults.set(percentage, forKey: percentageKey)
        defaults.synchronize()
    }
    
    // MARK: Main Program
    override func viewDidLoad() {
        super.viewDidLoad()
        itemList.append(BoostItem(category: "Drink", name: "Gatorade", cost: 10))
        itemList.append(BoostItem(category: "Shoe", name: "Nike", cost: 50))
        percentage = savePercentage()
        updateScoreLabel()
        updatePercentageLabel(percentage: percentage)
        boostView.isHidden = true
        boostView.isUserInteractionEnabled = false
        
        let nib = UINib(nibName: "BoostTableViewCell", bundle: nil)
        
        boostTableViewOutlet.register(nib, forCellReuseIdentifier: itemCellId)

        boostTableViewOutlet.dataSource = self
        
        //alert dialogue
    }
}

/*

*/
