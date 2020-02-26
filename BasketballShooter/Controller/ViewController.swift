//
//  ViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-10.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Variables
    var scoreCounter : Int = 0
    var totalScoreCounter: Int = 0
    var inRowCounter : Int = 0
    var missCounter : Int = 0
    var skinToneLevel : Int = 0
    var ringBounces : Int = 0
    var ballValue : Int = 1
    var xFactorCoordinate : Int = 1
    var lastTap : Double = 0
    var percentage : Double = 50
    var speedFactor : Double = 1.0
    var alowTap : Bool = true
    var madeShot : Bool = false
    var lastMade : Bool = false
    var turnOnSound : Bool = false
    var jerseyVectorUp : Bool = false
    var currentBall : UIImageView?
    var currentBoostTableViewCell : BoostTableViewCell? = nil
    var currentBoostItem : BoostItem? = nil
    var itemList = [BoostItem]()
    var packageList = [PackageItem]()
    var boostCellList = [BoostTableViewCell]()
    var navigationViewList = [UIView]()
    var navigationButtonList = [UIButton]()
    var ppsList = [Int]()
    var pickerNumbers = [String]()
    var ballArray = [UIImageView]()
    var shooterImages = [UIImage]()
    
    // MARK: Constants
    let startingPercentage : Double = 50
    let percentageKey = "percentage"
    let scoreKey = "score"
    let totalScoreKey = "totalScore"
    let totalMissesKey = "totalMisses"
    let ballValueKey = "ballValue"
    let skinToneKey = "skinTone"
    let boostCellId =  "BoostCellId"
    let packageCellId = "PackageCellId"
    let sections : [String] = ["Thunder Drinks", "Fire Foods"]
    let skinTones : [String] = ["#ffdbac","#e0ac69","#c68642","#8d5524","#3d0c02","#260701"]
    let sectionImages : [UIImage] = [UIImage(named: "thunderDrink")!, UIImage(named: "fireFood")!]
    let ballImages : [UIImage] = [UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon")!, UIImage(named: "basketBallIcon2")!, UIImage(named: "basketBallIcon3")!, UIImage(named: "basketBallIcon4")!, UIImage(named: "basketBallIcon5")!, UIImage(named: "basketBallIcon6")!, UIImage(named: "basketBallIcon7")!, UIImage(named: "basketBallIcon8")!, UIImage(named: "basketBallIcon9")!, UIImage(named: "basketBallIcon10")!,UIImage(named: "basketBallIcon")!,UIImage(named: "basketBallIcon2")!, UIImage(named: "basketBallIcon3")!, UIImage(named: "basketBallIcon4")!, UIImage(named: "basketBallIcon5")!, UIImage(named: "basketBallIcon6")!, UIImage(named: "basketBallIcon7")!, UIImage(named: "basketBallIcon8")!, UIImage(named: "basketBallIcon9")!, UIImage(named: "basketBallIcon10")!]
    let db = Firestore.firestore()
    
    // MARK: IB Outlets
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var ballValueLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var jerseyNumberLabel: UILabel!
    @IBOutlet weak var tableViewPercentageLabel: UILabel!
    @IBOutlet weak var packageTableViewPrecentageLabel: UILabel!
    @IBOutlet weak var boostButton: UIButton!
    @IBOutlet weak var packageButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var skinToneButton: UIButton!
    @IBOutlet weak var redJerseyButton: UIButton!
    @IBOutlet weak var blueJerseyButton: UIButton!
    @IBOutlet weak var greenJerseyButton: UIButton!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var ball2: UIImageView!
    @IBOutlet weak var ball3: UIImageView!
    @IBOutlet weak var ball4: UIImageView!
    @IBOutlet weak var ball5: UIImageView!
    @IBOutlet weak var shooterImage: UIImageView!
    @IBOutlet weak var jerseyImageView: UIImageView!
    @IBOutlet weak var hoopImageView: UIImageView!
    @IBOutlet weak var boostView: UIView!
    @IBOutlet weak var packageView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var boostTitelView: UIView!
    @IBOutlet weak var packageTitelView: UIView!
    @IBOutlet weak var settingsTitelView: UIView!
    @IBOutlet weak var boostTableViewOutlet: UITableView!
    @IBOutlet weak var packageTableViewOutlet: UITableView!
    @IBOutlet weak var numberPickerViewOutlet: UIPickerView!
    
    // MARK: IB Actions
    // Button to enable/disable the sound
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        if turnOnSound {
            soundButton.setBackgroundImage(UIImage(named: "soundButton"), for: .normal)
            turnOnSound = false
        } else {
            soundButton.setBackgroundImage(UIImage(named: "soundButtonSlash"), for: .normal)
            turnOnSound = true
        }
    }
    // Boostbutton pressed to open the boostView
    @IBAction func boostButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: boostView)
    }
    // Packagebutton pressed to open the packageView
    @IBAction func packageButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: packageView)
    }
    // Settingsbutton pressed to open the settingsView
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        navigationAnimation(button: sender, view: settingsView)
    }
    // Skintonebutton pressed to change skintone
    @IBAction func skinToneButtonPressed(_ sender: UIButton) {
        saveSkinToneSelected(skinTone: skinToneLevel)
        updateShooterAnimationImages()
        skinToneLevel += 1
        skinToneLevel %= 6
    }
    // Redjerseybutton pressed to equip the red jersey
    @IBAction func redJerseyButtonPressed(_ sender: UIButton) {
        if sender.alpha == 1.0 {
            sender.alpha = 0.5
            jerseyImageView.image = UIImage(named: "jerseyRed")
            blueJerseyButton.alpha = 1.0
            greenJerseyButton.alpha = 1.0
        }
    }
    // Bluejerseybutton pressed to equip the blue jersey
    @IBAction func blueJerseyButtonPressed(_ sender: UIButton) {
        if sender.alpha == 1.0 {
            sender.alpha = 0.5
            jerseyImageView.image = UIImage(named: "jerseyBlue")
            redJerseyButton.alpha = 1.0
            greenJerseyButton.alpha = 1.0
        }
    }
    // Greenjerseybutton pressed to equip the green jersey
    @IBAction func greenJerseyButtonPressed(_ sender: UIButton) {
        if sender.alpha == 1.0 {
            sender.alpha = 0.5
            jerseyImageView.image = UIImage(named: "jerseyGreen")
            blueJerseyButton.alpha = 1.0
            redJerseyButton.alpha = 1.0
        }
    }
    // Switch to show percentage
    @IBAction func showPercentageSwitch(_ sender: UISwitch) {
        if sender.isOn {
            percentageLabel.isHidden = false
        } else {
            percentageLabel.isHidden = true
        }
    }
    // Switch to show points/second
    @IBAction func showPPSSwitch(_ sender: UISwitch) {
        if sender.isOn {
            velocityLabel.isHidden = false
        } else {
            velocityLabel.isHidden = true
        }
    }
    // Switch to show ball value
    @IBAction func showBallValueSwitch(_ sender: UISwitch) {
        if sender.isOn {
            ballValueLabel.isHidden = false
        } else {
            ballValueLabel.isHidden = true
        }
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
        if alowTap {
            let shotMade = shotTaken(percentage: percentage)
            if shotMade {
                makeAnimation()
                scoreCounter += ballValue
                saveScoreSelected(score: scoreCounter)
                totalScoreCounter += 1
                saveTotalScoreSelected(score: totalScoreCounter)
                print("%: ",percentage)
                print("Make")
                pointsShowAnimation()
                ppsList.append(ballValue)
            } else {
                let randomMiss = Int(arc4random_uniform(3))
                switch randomMiss {
                    case 0:
                        print("Leftmiss Bounce")
                        xFactorCoordinate = -1
                        firstMissAnimation()
                    case 1:
                        print("Leftmiss Long")
                        xFactorCoordinate = -1
                        secondMissAnimation(duration: 0.8, delay: 0.5)
                    case 2:
                        print("Rightmiss Bounce")
                        xFactorCoordinate = 1
                        firstMissAnimation()
                    case 3:
                        print("Rightmiss Long")
                        xFactorCoordinate = 1
                        secondMissAnimation(duration: 0.8, delay: 0.5)
                    default:
                        firstMissAnimation()
                }
                print("%: ",percentage)
                print("Miss")
                missCounter += 1
                saveTotalMissesSelected(misses: missCounter)
            }
            shootingAnimation()
            ballRotationAnimation()
        }
    }
    
    
    // Handles buying and buying animation
    public func didPressBoostItemButton(cell: BoostTableViewCell) {
        let indexPath = boostTableViewOutlet.indexPath(for: cell)
        
        var offsection : Int = 0
        if indexPath?.section == 1 {
            offsection = 4
        }
        
        guard var index = indexPath?.row else {return}
        
        index += offsection
        
        if (Int(scoreLabel.text!)! >= itemList[index].cost && itemList[index].level < 5) {
            currentBoostTableViewCell = cell
            currentBoostItem = itemList[index]
            itemList[index].level += 1
            if itemList[index].level > 0 {
                cell.alphaView.isHidden = false
                boostBuyAnimation(object: cell.alphaView)
            }
            scoreCounter = Int(scoreLabel.text!)! - itemList[index].cost
            
            switch itemList[index].category {
                case "Ballvalue":
                    ballValue += Int(itemList[index].boost)
                    saveBallValueSelected(ballValue: ballValue)
                case "Percentage":
                    percentage += itemList[index].boost
                    percentage = Double(round(percentage*100)/100)
                    savePercentageSelected(percentage: percentage)
                case "Speed":
                    speedFactor += itemList[index].boost
                default:
                    break
            }
            updateScoreLabel()
            print("Purchase made " + itemList[index].name + " " + String(itemList[index].level))
        }
    }
    
    // MARK: Other Functions
    // Randomizes number between 0-10000 and is checked by the percentage
    func shotTaken(percentage: Double) -> Bool {
        let randomNumber = Int(arc4random_uniform(10000)) + 1
        if (randomNumber < Int(percentage * 100)) {
            return true
        } else {
            return false
        }
    }
    
    // Enables or disables all interaction with Boostcells
    func userEnableCells(enable : Bool) {
        for boostCell in boostCellList {
            boostCell.itemBuyButton.isUserInteractionEnabled = enable
        }
    }
    // Loads the packages from the database and appends them to the packagelist
    func loadPackages(){
        db.collection("packages").limit(to: 30).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was an Issue retrieving data from Firestore. \(e)")
            } else {
                if let snapShotDocuments = querySnapshot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let type = data["type"] as? String, let name = data["name"] as? String, let id = data["id"] as? String, let cost = data["cost"] as? Int, let boost = data["boost"] as? Double {
                            let newObject = PackageItem(type: type, name: name, id: id, cost: cost, boost: boost)
                            self.packageList.append(newObject)
                            
                            DispatchQueue.main.async {
                                self.packageTableViewOutlet.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    // Hides the statusbar in the app
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: Main Program
    override func loadView() {
        super.loadView()
        percentage = savePercentage()
        ballValue = saveBallValue()
        missCounter = saveTotalMisses()
        scoreCounter = saveScore()
        totalScoreCounter = saveTotalScore()
        skinToneLevel = saveSkinTone()
        currentBall = ball
        ballArray.append(ball2)
        ballArray.append(ball3)
        ballArray.append(ball4)
        ballArray.append(ball5)
        navigationViewList.append(boostView)
        navigationViewList.append(settingsView)
        navigationViewList.append(packageView)
        navigationButtonList.append(boostButton)
        navigationButtonList.append(settingsButton)
        navigationButtonList.append(packageButton)
        itemList.append(BoostItem(type: "Drink", category: "Percentage", name: "Can", cost: 1, boost: 0.01))
        itemList.append(BoostItem(type: "Drink", category: "Percentage", name: "Cup", cost: 1, boost: 0.02))
        itemList.append(BoostItem(type: "Drink", category: "Percentage", name: "Bottle", cost: 1, boost: 0.05))
        itemList.append(BoostItem(type: "Drink", category: "Speed", name: "Barrell", cost: 1, boost: 0.4))
        itemList.append(BoostItem(type: "Food", category: "Ballvalue", name: "Nachos", cost: 2, boost: 1))
        itemList.append(BoostItem(type: "Food", category: "Ballvalue", name: "Protein Bar", cost: 2,boost: 2))
        itemList.append(BoostItem(type: "Food", category: "Ballvalue", name: "Hot Dog", cost: 2, boost: 10))
        itemList.append(BoostItem(type: "Food", category: "Autoshoot", name: "Taco", cost: 2, boost: 20))
        pickerNumbers.append("00")
        for i in 0...99 {
            pickerNumbers.append(String(i))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPackages()
        boostView.layer.cornerRadius = 10
        boostTableViewOutlet.layer.cornerRadius = 10
        boostTitelView.layer.cornerRadius = 10
        boostTableViewOutlet.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        packageView.layer.cornerRadius = 10
        packageTableViewOutlet.layer.cornerRadius = 10
        packageTitelView.layer.cornerRadius = 10
        packageTableViewOutlet.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        settingsView.layer.cornerRadius = 10
        settingsTitelView.layer.cornerRadius = 10
        settingsTitelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        //let team = PackageItem(type: "Team", name: "Washington Lizards", cost: 50, boost: 0)
        //db.collection("packages").addDocument(data: team.toDict())
        updateScoreLabel()
        updatePercentageLabel()
        updateBallValueLabel()
        updateShooterAnimationImages()
        boostView.isHidden = true
        boostView.isUserInteractionEnabled = false
        packageView.isHidden = true
        packageView.isUserInteractionEnabled = false
        settingsView.isHidden = true
        settingsView.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updatePPS)), userInfo: nil, repeats: true)
        
        let boostNib = UINib(nibName: "BoostTableViewCell", bundle: nil)
        boostTableViewOutlet.register(boostNib, forCellReuseIdentifier: boostCellId)
        boostTableViewOutlet.dataSource = self
        boostTableViewOutlet.delegate = self
        
        let packageNib = UINib(nibName: "PackageTableViewCell", bundle: nil)
        packageTableViewOutlet.register(packageNib, forCellReuseIdentifier: packageCellId)
        packageTableViewOutlet.dataSource = self
        packageTableViewOutlet.delegate = self
        
        numberPickerViewOutlet.dataSource = self
        numberPickerViewOutlet.delegate = self
        
    //    NotificationCenter.default.addObserver(self, selector: #selector(didPressBoostItemButton(notification:)), name: NSNotification.Name.init(rawValue: "ButtonPressed"), object: nil)
    }
}
