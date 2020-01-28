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
    let name : String
    var cost : Int
    var level : Int
    
    init(category: String, name: String, cost: Int, level: Int = 1) {
        self.category = category
        self.name = name
        self.cost = cost
        self.level = level
    }
}
