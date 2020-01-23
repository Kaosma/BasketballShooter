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
    @IBOutlet weak var itemImageView: UIImageView!
    
    // MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
