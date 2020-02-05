//
//  ViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-10.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Variables
    var percentage : Double = 50
    var madeShot : Bool = false
    var scoreCounter : Int = 0
    var totalScoreCounter: Int = 0
    var missCounter : Int = 0
    var navigationButtonPressed : Bool = false
    var itemList = [BoostItem]()
    var boostCellList = [BoostTableViewCell]()
    var currentBoostTableViewCell : BoostTableViewCell? = nil
    var currentBoostItem : BoostItem? = nil
    
    // MARK: Constants
    let startingPercentage : Double = 50
    let percentageKey = "percentage"
    let scoreKey = "score"
    let totalScoreKey = "totalScore"
    let totalMissesKey = "totalMisses"
    let itemCellId =  "ItemCellId"
    
    // MARK: Outlet Variables
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var boostButton: UIButton!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var boostView: UIView!
    @IBOutlet weak var boostTableViewOutlet: UITableView!
    @IBOutlet weak var tableViewPercentageLabel: UILabel!
    
    // MARK: Actions
    // Boostbutton pressed
    @IBAction func boostButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: boostView)
    }
    // Reset button to reset the percentage to starting value (50%) | Alert message
    @IBAction func resetButtonTest(_ sender: UIButton) {
        let alert = UIAlertController(title: "ResetButton", message: "Are you sure you want to reset everything?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .default) {action in
            self.percentage = self.startingPercentage
            self.savePercentageSelected(percentage: self.percentage)
            self.updatePercentageLabel(percentage: self.percentage)
            self.scoreCounter = 0
            self.missCounter = 0
            self.totalScoreCounter = 0
            self.saveScoreSelected(score: self.scoreCounter)
            self.updateScoreLabel()
        }
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        present(alert, animated: true)
    }
    // Tap for every shot
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        print(shotTaken(percentage: percentage))
        print(totalScoreCounter , "/", missCounter+totalScoreCounter)
    }
    // Handles buying and buying animation
    @objc func didPressBoostItemButton(notification:Notification) {
        let data = notification.userInfo as? [String: Int]
        let index = data!["row"]!
        if (Int(scoreLabel.text!)! >= itemList[index].cost && itemList[index].level < 5) {
            currentBoostTableViewCell = boostCellList[index]
            currentBoostItem = itemList[index]
            let cell = currentBoostTableViewCell
            itemList[index].level += 1
            if itemList[index].level > 0 {
                cell?.alphaView.isHidden = false
                boostBuyAnimation(object: cell!.alphaView)
            }
            scoreCounter = Int(scoreLabel.text!)! - itemList[index].cost
            percentage += itemList[index].boost
            percentage = Double(round(percentage*100)/100)
            savePercentageSelected(percentage: percentage)
            updateScoreLabel()
            updatePercentageLabel(percentage: percentage)
            print("Purchase made " + itemList[index].name + " " + String(itemList[index].level))
        }
    }
    
    func boostBuyAnimation(object: UIView) {
        UIView.animate(withDuration: 3.0, animations: {
            object.frame.size.height = 140
        }, completion: hideAlphaView(finished:))
    }
    
    func hideAlphaView(finished:Bool) {
        currentBoostTableViewCell?.alphaView.isHidden = true
        updateButtonImage(item: currentBoostItem!)
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
        cell.costLabel.text = "Cost: " + String(itemList[indexPath.row].cost)
        cell.levelLabel.text = "Lv. " + String(itemList[indexPath.row].level)
        cell.purchasedLabel.text = "+" + String(itemList[indexPath.row].boost) + "%"
        
        boostCellList.append(cell)
        currentBoostTableViewCell = cell
        updateButtonImage(item: itemList[indexPath.row])
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
            saveScoreSelected(score: scoreCounter)
            totalScoreCounter += 1
            saveTotalScoreSelected(score: totalScoreCounter)
            updateScoreLabel()
            print("%: ",percentage)
            print("Make")
        } else {
            print("%: ",percentage)
            print("Miss")
            missCounter += 1
            saveTotalMissesSelected(misses: missCounter)
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
        tableViewPercentageLabel.text = percentageLabel.text
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
    func savePercentageSelected(percentage: Double) {
        let defaults = UserDefaults.standard
        defaults.set(percentage, forKey: percentageKey)
        defaults.synchronize()
    }
    // Saves the score updates with user default storage
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
    // Saves the total score updates with user default storage
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
    func saveTotalMisses() -> Int {
        let newMiss = UserDefaults.standard.object(forKey: totalMissesKey) as? Int
        
        if let miss = newMiss {
            return miss
        } else {
            return 0
        }
    }
    // Saving the updated total score for the user
    func saveTotalMissesSelected(misses: Int) {
        let defaults = UserDefaults.standard
        defaults.set(misses, forKey: totalMissesKey)
        defaults.synchronize()
    }
    // Updates button image in BoostItem cells
    func updateButtonImage(item: BoostItem) {
        let cell = currentBoostTableViewCell
        let button = cell?.itemBuyButton
        let level = String(item.level)
        let name = item.name.replacingOccurrences(of: " ", with: "").lowercased()
        let imageName = name+"Level"+level
        print(imageName)
        button?.setImage(UIImage(named: imageName), for: .normal)
    }
    
    /*func userDisableCells(cell: BoostTableViewCell) {
        let index = boostTableViewOutlet.index(ofAccessibilityElement: cell)
        for boostCell in boostCellList {
            if boostCellList.index(of: boostCell) != index {
                
            }
        }
    }*/
    
    // MARK: Main Program
    override func viewDidLoad() {
        super.viewDidLoad()
        boostView.layer.cornerRadius = 10
        boostTableViewOutlet.layer.cornerRadius = 10
        itemList.append(BoostItem(category: "Drink", name: "Can", cost: 1, boost: 0.01))
        itemList.append(BoostItem(category: "Drink", name: "Cup", cost: 1, boost: 0.02))
        itemList.append(BoostItem(category: "Drink", name: "Bottle", cost: 1, boost: 0.05))
        itemList.append(BoostItem(category: "Drink", name: "Barrell", cost: 1, boost: 0.05))
        itemList.append(BoostItem(category: "Food", name: "Nachos", cost: 2, boost: 1))
        itemList.append(BoostItem(category: "Food", name: "Protein Bar", cost: 2,boost: 10))
        itemList.append(BoostItem(category: "Food", name: "Hot Dog", cost: 2, boost: 20))
        itemList.append(BoostItem(category: "Food", name: "Taco", cost: 2, boost: 25))
        /*
        itemList.append(BoostItem(category: "Sponsor", name: "Puma", cost: 25))
        itemList.append(BoostItem(category: "Sponsor", name: "Adidas", cost: 250))
        itemList.append(BoostItem(category: "Sponsor", name: "Under Armor", cost: 2500))
        itemList.append(BoostItem(category: "Sponsor", name: "Nike", cost: 25000))
        itemList.append(BoostItem(category: "Team", name: "Atlanta Clocks", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Boston Athletics", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Brooklyn Jets", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Charlotte Orbits", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Chicago Pulse", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Cleveland Raindeers", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Dallas ", cost: 50))//HEJHEJ
        itemList.append(BoostItem(category: "Team", name: "Denver Luggage", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Detroit Christians", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Golden State Sorcerers", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Houston Sockets", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Indiana ", cost: 50))//HEJHEJ
        itemList.append(BoostItem(category: "Team", name: "Los Angeles Slippers", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Los Angeles Bakers", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Memphis", cost: 50))//HEJHEJ
        itemList.append(BoostItem(category: "Team", name: "Miami Feet", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Milwaukee Ducks", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Minnesota ", cost: 50))//HEJHEJ
        itemList.append(BoostItem(category: "Team", name: "New Orleans ", cost: 50))//HEJHEJ
        itemList.append(BoostItem(category: "Team", name: "New York Bricks", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Oklahoma City Wonder", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Orlando Automatic", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Philadelphia Cement Mixers", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Phoenix Buns", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Portland Sail Raisers", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Sacramento Rings", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "San Antonio Chauffeurs", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Toronto ", cost: 50))//HEJHEJ
        itemList.append(BoostItem(category: "Team", name: "Utah Grass", cost: 50))
        itemList.append(BoostItem(category: "Team", name: "Washington Lizards", cost: 50))*/
        percentage = savePercentage()
        missCounter = saveTotalMisses()
        scoreCounter = saveScore()
        totalScoreCounter = saveTotalScore()
        updateScoreLabel()
        updatePercentageLabel(percentage: percentage)
        boostView.isHidden = true
        boostView.isUserInteractionEnabled = false
        
        let nib = UINib(nibName: "BoostTableViewCell", bundle: nil)
        
        boostTableViewOutlet.register(nib, forCellReuseIdentifier: itemCellId)

        boostTableViewOutlet.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPressBoostItemButton(notification:)), name: NSNotification.Name.init(rawValue: "ButtonPressed"), object: nil)
        
        //alert dialogue
    }
}
