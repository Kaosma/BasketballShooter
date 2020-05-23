//
//  PackageTableViewCell.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-02-18.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit

class PackageTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var packageBackground: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var itemBuyButton: UIButton!
    
    // MARK: Functions
    @IBAction func itemBuyButtonPressed(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
