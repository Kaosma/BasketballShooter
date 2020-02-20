//
//  TableViewController.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-02-19.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    // MARK: TableView Functions
    
    // Returns how many cells for each section in the tableviews
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
            case boostTableViewOutlet:
                if section == 0 {
                    return 4 // antal drinks
                } else{
                    return 4 // antal foods
                }
            case packageTableViewOutlet:
                return packageList.count
            default:
                return 0
        }
    }
    // Returns the number of sections the boostTableView will have
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
            case boostTableViewOutlet:
                return sections.count
            default:
                return 1
        }
    }
    // Creates headercell for boostTableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         print("11111111")
        switch tableView {
            case boostTableViewOutlet:
                print("22222")
                let boostHeadercell = tableView.dequeueReusableCell(withIdentifier: "boostHeaderCell") as! HeaderCell
                boostHeadercell.headerImage.image = sectionImages[section]
                boostHeadercell.headerLabel.text = sections[section]
                return boostHeadercell
            case packageTableViewOutlet:
                 print("3333")
                let packageHeadercell = tableView.dequeueReusableCell(withIdentifier: "packageHeaderCell") as! HeaderCell
                packageHeadercell.headerImage.image = UIImage(named: "nbaLogo")
                packageHeadercell.headerLabel.text = "Team Sponsors"
                return packageHeadercell
            default:
                 print("44444")
                return UITableViewCell()
            }
    }
    
    // Creating the cells for the boostTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            case boostTableViewOutlet:
                let cell = tableView.dequeueReusableCell(withIdentifier: boostCellId, for: indexPath) as! BoostTableViewCell
                
                var offSection = 0
                if indexPath.section == 1 {
                   offSection = 4
                }
                
                let item = itemList[indexPath.row + offSection]
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
            case packageTableViewOutlet:
                let cell = tableView.dequeueReusableCell(withIdentifier: packageCellId) as! PackageTableViewCell
                cell.itemLabel.text = packageList[indexPath.row].name
                return cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
    }
}
