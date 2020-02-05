//
//  BoostItem.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-22.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation

class BoostItem {
    var category : String
    let name : String
    var cost : Int
    var level : Int
    let boost : Double
    
    init(category: String, name: String, cost: Int, level: Int = 0, boost: Double) {
        self.category = category
        self.name = name
        self.cost = cost
        self.level = level
        self.boost = boost
    }
}
