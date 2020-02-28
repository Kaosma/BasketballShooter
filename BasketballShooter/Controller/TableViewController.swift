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
    // Returns the number of sections the boostTableView and packageTableView will have
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
            case boostTableViewOutlet:
                return sections.count
            default:
                return 1
        }
    }
    // Creates headercell for boostTableView and packageTableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
            case boostTableViewOutlet:
                let boostHeadercell = tableView.dequeueReusableCell(withIdentifier: "boostHeaderCell") as! HeaderCell
                boostHeadercell.headerImage.image = sectionImages[section]
                boostHeadercell.headerLabel.text = sections[section]
                return boostHeadercell
            case packageTableViewOutlet:
                let packageHeadercell = tableView.dequeueReusableCell(withIdentifier: "packageHeaderCell") as! HeaderCell
                packageHeadercell.headerImage.image = UIImage(named: "nbaLogo")
                packageHeadercell.headerLabel.text = "Team Sponsors"
                return packageHeadercell
            default:
                return UITableViewCell()
            }
    }
    
    // Creating the cells for the boostTableView and packageTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
            case boostTableViewOutlet:
                let cell = tableView.dequeueReusableCell(withIdentifier: boostCellId, for: indexPath) as! BoostTableViewCell
                cell.vc = self
                
                var offSection = 0
                if indexPath.section == 1 {
                    offSection = itemList.count/2
                }
                
                let item = itemList[indexPath.row + offSection]
                item.level = BoostItemLevelList[indexPath.row]
                cell.itemLabel.text = item.name
                cell.costLabel.text = "Cost: " + String(item.cost)
                cell.levelLabel.text = "Lv. " + String(item.level)
                let name = item.name.replacingOccurrences(of: " ", with: "").lowercased()+"Level"+String(item.level)
                cell.itemBuyButton.setImage(UIImage(named: name), for: .normal)
                
                switch item.category {
                    case "Percentage":
                        cell.purchasedLabel.text = "+" + String(item.boost) + "%"
                    case "Ballvalue":
                        cell.purchasedLabel.text = "+" + String(item.boost) + "🏀"
                    case "Speed":
                        cell.purchasedLabel.text = "+" + String(item.boost) + "s"
                    default:
                        cell.purchasedLabel.text = ""
                }
                
                if item.level == 5 {
                    cell.purchasedLabel.alpha = 0.5
                }

                if !boostCellList.contains(cell) {
                    boostCellList.append(cell)
                }
                return cell
            case packageTableViewOutlet:
                let cell = tableView.dequeueReusableCell(withIdentifier: packageCellId) as! PackageTableViewCell
                let package = packageList[indexPath.row]
                cell.itemLabel.text = package.name
                cell.costLabel.text = "Cost: \(package.cost)"
                let name = package.name.replacingOccurrences(of: " ", with: "")
                cell.itemBuyButton.setImage(UIImage(named: name), for: .normal)
                return cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
    }
}
