//
//  ViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-10.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Variables
    var percentage : Double = 50
    var madeShot : Bool = false
    var scoreCounter : Int = 0
    var totalScoreCounter: Int = 0
    var inRowCounter : Int = 0
    var missCounter : Int = 0
    var itemList = [BoostItem]()
    var packageList = [PackageItem]()
    var boostCellList = [BoostTableViewCell]()
    var currentBoostTableViewCell : BoostTableViewCell? = nil
    var currentBoostItem : BoostItem? = nil
    var ballValue : Int = 1
    var navigationViewList = [UIView]()
    var navigationButtonList = [UIButton]()
    var lastTap : Double = 0
    var lastMade : Bool = false
    var ppsList = [Int]()
   
    // MARK: Constants
    let startingPercentage : Double = 50
    let percentageKey = "percentage"
    let scoreKey = "score"
    let totalScoreKey = "totalScore"
    let totalMissesKey = "totalMisses"
    let ballValueKey = "ballValue"
    let itemCellId =  "ItemCellId"
    let sections : [String] = ["Thunder Drink", "Fire Food"]
    let sectionImages : [UIImage] = [UIImage.init(named: "thunderDrink")!, UIImage.init(named: "fireFood")!]
    let db = Firestore.firestore()
    
    // MARK: IB Outlet Variables
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var ballValueLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var boostButton: UIButton!
    @IBOutlet weak var packageButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var boostView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var hoopImageView: UIImageView!
    @IBOutlet weak var boostTableViewOutlet: UITableView!
    @IBOutlet weak var tableViewPercentageLabel: UILabel!
    @IBOutlet weak var settingsTitelView: UIView!
    
    // MARK: IB Actions
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        
    }
    // Boostbutton pressed
    @IBAction func boostButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: boostView)
    }
    // Settingsbutton pressed
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: settingsView)
    }
    // Reset button to reset the percentage to starting value (50%) | Alert message
    @IBAction func resetButtonPressed(_ sender: UIButton) {
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
        
        let shotMade = shotTaken(percentage: percentage)
        if shotMade {
            makeAnimation()
            scoreCounter += ballValue
            saveScoreSelected(score: scoreCounter)
            totalScoreCounter += 1
            saveTotalScoreSelected(score: totalScoreCounter)
            updateScoreLabel()
            print("%: ",percentage)
            print("Make")
            pointsShowAnimation()
            ppsList.append(ballValue)
        } else {
            print("%: ",percentage)
            print("Miss")
            missCounter += 1
            saveTotalMissesSelected(misses: missCounter)
        }
        ballRotationAnimation()
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
    // Ballrotation animation
    func ballRotationAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            self.ball.transform = CGAffineTransform(rotationAngle: (CGFloat(Double.pi*0.5)))
            self.ball.transform = CGAffineTransform(rotationAngle: (CGFloat(Double.pi)))
            self.ball.transform = CGAffineTransform(rotationAngle: (CGFloat(Double.pi*1.5)))
            self.ball.transform = CGAffineTransform(rotationAngle: (CGFloat(Double.pi*2)))
        })
    }
    // Animation for made shot
    func makeAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            var frame = self.ball.frame
            frame.origin.y += 4.5*frame.size.height
            self.ball.frame = frame
        })
        UIView.animate(withDuration: 0.7, delay: 0.8, animations: {
            self.ball.alpha = 0.0
        }, completion: makeBallVisible(finished:))
    }
    // Ball transparency fade animation
    func makeBallVisible(finished: Bool) {
        self.ball.alpha = 1.0
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
        if section == 0 {
            return 4 // antal drinks
        } else{
            return 4 // antal foods
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headercell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        headercell.headerImage.image = sectionImages[section]
        headercell.headerLabel.text = sections[section]
        return headercell
    }
    
    // Creating the cells for the tableview
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! BoostTableViewCell
        
        var offSection = 0
        if indexPath.section == 1 {
           offSection = 4
        }
        
        let  item = itemList[indexPath.row + offSection]
        cell.itemLabel.text = item.name
        cell.costLabel.text = "Cost: " + String(item.cost)
        cell.levelLabel.text = "Lv. " + String(item.level)
        
        switch item.category {
            case "Drink":
                cell.purchasedLabel.text = "+" + String(item.boost) + "%"
            case "Food":
                cell.purchasedLabel.text = "+" + String(item.boost) + "🏀"
            default:
                cell.purchasedLabel.text = ""
        }

        boostCellList.append(cell)
        currentBoostTableViewCell = cell
        updateButtonImage(item: item)
        return cell
    }
    // Randomizes number between 0-10000 and is checked by the percentage
    func shotTaken(percentage: Double) -> Bool {
        let randomNumber = Int(arc4random_uniform(10000)) + 1
        if (randomNumber < Int(percentage * 100)) {
            return true
        } else {
            return false
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
                        if let type = data["type"] as? String, let name = data["name"] as? String, let id = data["id"] as? String, let cost = data["cost"] as? Int, let boost = data["boost"] as? Double {
                            let newObject = PackageItem(type: type, name: name, id: id, cost: cost, boost: boost)
                            self.packageList.append(newObject)
                        }
                    }
                }
            }
        }
    }
    
    /*
    func calcPPS() {
        let time = getClickTime()
        let timeSinceLastHit = (time - timeOfLastMade )

        let pps = Double(ballValue) / timeSinceLastHit

        timeOfLastMade = time

        // print(pps)
        velocityLabel.text = "PPS: " + String(Double(round(10*pps)/10))
         
         
    }
     
    func getClickTime() -> Double {
        let timestamp = NSDate().timeIntervalSince1970
        return timestamp
    }
    */
    @objc func updatePPS() {
        var pps : Int = 0
        for points in ppsList {
            pps += points
        }
        ppsList.removeAll()
        
        velocityLabel.text = "PPS: \(pps)"
    }
    
    // MARK: Main Program
    override func loadView() {
        super.loadView()
        loadPackages()
        percentage = savePercentage()
        ballValue = saveBallValue()
        missCounter = saveTotalMisses()
        scoreCounter = saveScore()
        totalScoreCounter = saveTotalScore()
        navigationViewList.append(boostView)
        navigationViewList.append(settingsView)
        navigationButtonList.append(boostButton)
        navigationButtonList.append(settingsButton)
        itemList.append(BoostItem(category: "Drink", name: "Can", cost: 1, boost: 0.01))
        itemList.append(BoostItem(category: "Drink", name: "Cup", cost: 1, boost: 0.02))
        itemList.append(BoostItem(category: "Drink", name: "Bottle", cost: 1, boost: 0.05))
        itemList.append(BoostItem(category: "Drink", name: "Barrell", cost: 1, boost: 0.05))
        itemList.append(BoostItem(category: "Food", name: "Nachos", cost: 2, boost: 1))
        itemList.append(BoostItem(category: "Food", name: "Protein Bar", cost: 2,boost: 2))
        itemList.append(BoostItem(category: "Food", name: "Hot Dog", cost: 2, boost: 10))
        itemList.append(BoostItem(category: "Food", name: "Taco", cost: 2, boost: 20))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.layer.cornerRadius = 10
        settingsTitelView.layer.cornerRadius = 10
        settingsTitelView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        boostView.layer.cornerRadius = 10
        boostTableViewOutlet.layer.cornerRadius = 10

        //let team = PackageItem(type: "Team", name: "Washington Lizards", cost: 50, boost: 0)
        //db.collection("packages").addDocument(data: team.toDict())
        /*
        itemList.append(BoostItem(category: "Sponsor", name: "Puma", cost: 25))
        itemList.append(BoostItem(category: "Sponsor", name: "Adidas", cost: 250))
        itemList.append(BoostItem(category: "Sponsor", name: "Under Armor", cost: 2500))
        itemList.append(BoostItem(category: "Sponsor", name: "Nike", cost: 25000))*/
        updateScoreLabel()
        updatePercentageLabel()
        updateBallValueLabel()
        boostView.isHidden = true
        boostView.isUserInteractionEnabled = false
        settingsView.isHidden = true
        settingsView.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updatePPS)), userInfo: nil, repeats: true)
        
        let nib = UINib(nibName: "BoostTableViewCell", bundle: nil)
        boostTableViewOutlet.register(nib, forCellReuseIdentifier: itemCellId)
        boostTableViewOutlet.dataSource = self
        boostTableViewOutlet.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPressBoostItemButton(notification:)), name: NSNotification.Name.init(rawValue: "ButtonPressed"), object: nil)
    }
}
