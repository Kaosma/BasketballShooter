//
//  BoostItem.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-01-22.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation
import Firebase

class BoostItem {
    let type : String
    let category : String
    let name : String
    var cost : Int
    var level : Int
    var boost : Double
    
    init(type: String, category: String, name: String, cost: Int, level: Int = 0, boost: Double) {
        self.type = type
        self.category = category
        self.name = name
        self.cost = cost
        self.level = level
        self.boost = boost
    }
    /*
    // Constructor with firestore input and creating object
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        category = snapshotValue["category"] as! String
        name = snapshotValue["name"] as! String
        cost = snapshotValue["cost"] as! Int
        boost = snapshotValue["boost"] as! Double
    }
    
    func toDict() -> [String : Any] {
        return ["category" : category,
            "name" : name,
            "cost" : cost,
            "boost" : boost]
    }*/
}
