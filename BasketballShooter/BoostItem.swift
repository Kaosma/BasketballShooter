//
//  BoostItem.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-22.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation

struct BoostItem {
    var category : String
    var name : String
    var cost : Int
    
    
    init(category: String, name: String, cost : Int) {
        self.category = category
        self.name = name
        self.cost = cost
    }
}
