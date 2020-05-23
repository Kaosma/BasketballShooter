//
//  boostsTableViewCell.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-22.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit

class BoostTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var purchasedLabel: UILabel!
    @IBOutlet weak var itemBuyButton: UIButton!
    @IBOutlet weak var alphaView: UIView!
    
    weak var vc : ViewController?
    
    // MARK: Actions
    @IBAction func itemBuyButtonPressed(_ sender: UIButton) {
        let tableView = superview as? UITableView
        var index = tableView?.indexPath(for: self)?[1]
        if tableView?.indexPath(for: self)?.section == 1 {
            index! += 4
        }
        vc?.didPressBoostItemButton(cell: self)
        /*
        if let tableView = superview as? UITableView {
            if var index = tableView.indexPath(for: self) {
                if index.section == 1 {
                    index[1] += 4
                }
                vc?.didPressBoostItemButton(cell: self)
            }
        }*/
        //let dict = ["row": index]
        // nc.post(name: Notification.Name("ButtonPressed"), object: itemBuyButton, userInfo: dict as [AnyHashable : Any] )
    }
    
    // MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
