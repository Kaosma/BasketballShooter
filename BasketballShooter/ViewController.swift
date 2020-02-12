//
//  ViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-10.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Variables
    var percentage : Double = 50
    var madeShot : Bool = false
    var scoreCounter : Int = 0
    var totalScoreCounter: Int = 0
    var missCounter : Int = 0
    var itemList = [BoostItem]()
    var packageList = [PackageItem]()
    var boostCellList = [BoostTableViewCell]()
    var currentBoostTableViewCell : BoostTableViewCell? = nil
    var currentBoostItem : BoostItem? = nil
    var ballValue : Int = 1
    var navigationViewList = [UIView]()
    var navigationButtonList = [UIButton]()
    
    // MARK: Constants
    let startingPercentage : Double = 50
    let percentageKey = "percentage"
    let scoreKey = "score"
    let totalScoreKey = "totalScore"
    let totalMissesKey = "totalMisses"
    let ballValueKey = "ballValue"
    let itemCellId =  "ItemCellId"
    let db = Firestore.firestore()
    
    // MARK: IB Outlet Variables
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var ballValueLabel: UILabel!
    @IBOutlet weak var boostButton: UIButton!
    @IBOutlet weak var packageButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var boostView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var boostTableViewOutlet: UITableView!
    @IBOutlet weak var tableViewPercentageLabel: UILabel!
    
    // MARK: IB Actions
    // Boostbutton pressed
    @IBAction func boostButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: boostView)
    }
    // Settingsbutton pressed
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: settingsView)
    }
    // Reset button to reset the percentage to starting value (50%) | Alert message
    @IBAction func resetButtonTest(_ sender: UIButton) {
        let alert = UIAlertController(title: "ResetButton", message: "Are you sure you want to reset everything?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .default) {action in
            self.percentage = self.startingPercentage
            self.scoreCounter = 0
            self.missCounter = 0
            self.totalScoreCounter = 0
            self.ballValue = 1
            self.savePercentageSelected(percentage: self.percentage)
            self.saveBallValueSelected(ballValue: self.ballValue)
            self.saveScoreSelected(score: self.scoreCounter)
            self.updatePercentageLabel()
            self.updateBallValueLabel()
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
            
            switch itemList[index].category {
            case "Food":
                ballValue += Int(itemList[index].boost)
                saveBallValueSelected(ballValue: ballValue)
            case "Drink":
                percentage += itemList[index].boost
                percentage = Double(round(percentage*100)/100)
                savePercentageSelected(percentage: percentage)
            default:
                break
            }
            updateScoreLabel()
            print("Purchase made " + itemList[index].name + " " + String(itemList[index].level))
        }
    }
    
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
    
    // MARK: Other Functions
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
        
        switch itemList[indexPath.row].category {
        case "Drink":
            cell.purchasedLabel.text = "+" + String(itemList[indexPath.row].boost) + "%"
        case "Food":
            cell.purchasedLabel.text = "+" + String(itemList[indexPath.row].boost) + "🏀"
        default:
            cell.purchasedLabel.text = ""
        }

        boostCellList.append(cell)
        currentBoostTableViewCell = cell
        updateButtonImage(item: itemList[indexPath.row])
        return cell
    }
    // Randomizes number between 0-10000 and is checked by the percentage
    func shotTaken(percentage: Double) {
        let randomNumber = Int(arc4random_uniform(10000)) + 1
        if (randomNumber < Int(percentage * 100)) {
            makeAnimation()
            scoreCounter += ballValue
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
    // Updates the score label
    func updateScoreLabel() {
        scoreLabel.text = String(scoreCounter)
    }
    // Updates the percentage label
    func updatePercentageLabel() {
        percentageLabel.text = String(percentage) + "%"
        tableViewPercentageLabel.text = percentageLabel.text
    }
    // Updates the ball value label
    func updateBallValueLabel() {
        ballValueLabel.text = "Ball value: " + String(ballValue)
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
    // Enables or disables all interaction with Boostcells
    func userEnableCells(enable : Bool) {
        for boostCell in boostCellList {
            boostCell.itemBuyButton.isUserInteractionEnabled = enable
        }
    }
    // Loads the packages from the database and appends them to the packagelist
    func loadPackages(){
        db.collection("packages").getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was an Issue retrieving data from Firestore. \(e)")
            } else {
                if let snapShotDocuments = querySnapshot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let type = data["type"] as? String, let name = data["name"] as? String, let cost = data["cost"] as? Int, let boost = data["boost"] as? Double {
                            let newObject = PackageItem(type: type, name: name, cost: cost, boost: boost)
                            self.packageList.append(newObject)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Main Program
    
    override func loadView() {
        super.loadView()
        navigationViewList.append(boostView)
        navigationViewList.append(settingsView)
        navigationButtonList.append(boostButton)
        navigationButtonList.append(settingsButton)
        loadPackages()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.layer.cornerRadius = 10
        boostView.layer.cornerRadius = 10
        boostTableViewOutlet.layer.cornerRadius = 10
        itemList.append(BoostItem(category: "Drink", name: "Can", cost: 1, boost: 0.01))
        itemList.append(BoostItem(category: "Drink", name: "Cup", cost: 1, boost: 0.02))
        itemList.append(BoostItem(category: "Drink", name: "Bottle", cost: 1, boost: 0.05))
        itemList.append(BoostItem(category: "Drink", name: "Barrell", cost: 1, boost: 0.05))
        itemList.append(BoostItem(category: "Food", name: "Nachos", cost: 2, boost: 1))
        itemList.append(BoostItem(category: "Food", name: "Protein Bar", cost: 2,boost: 2))
        itemList.append(BoostItem(category: "Food", name: "Hot Dog", cost: 2, boost: 10))
        itemList.append(BoostItem(category: "Food", name: "Taco", cost: 2, boost: 20))

        //let team = PackageItem(type: "Team", name: "Washington Lizards", cost: 50, boost: 0)
        //db.collection("packages").addDocument(data: team.toDict())
        /*
        itemList.append(BoostItem(category: "Sponsor", name: "Puma", cost: 25))
        itemList.append(BoostItem(category: "Sponsor", name: "Adidas", cost: 250))
        itemList.append(BoostItem(category: "Sponsor", name: "Under Armor", cost: 2500))
        itemList.append(BoostItem(category: "Sponsor", name: "Nike", cost: 25000))*/
        percentage = savePercentage()
        ballValue = saveBallValue()
        missCounter = saveTotalMisses()
        scoreCounter = saveScore()
        totalScoreCounter = saveTotalScore()
        updateScoreLabel()
        updatePercentageLabel()
        updateBallValueLabel()
        boostView.isHidden = true
        boostView.isUserInteractionEnabled = false
        settingsView.isHidden = true
        settingsView.isUserInteractionEnabled = false
        
        for object in packageList{
            print(object.name)
        }
        
        let nib = UINib(nibName: "BoostTableViewCell", bundle: nil)
        
        boostTableViewOutlet.register(nib, forCellReuseIdentifier: itemCellId)

        boostTableViewOutlet.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPressBoostItemButton(notification:)), name: NSNotification.Name.init(rawValue: "ButtonPressed"), object: nil)
    }
}
