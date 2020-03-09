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
    let startCost : Int
    var cost : Int
    var level : Int
    var boost : Double
    
    init(type: String, category: String, name: String, startCost: Int, level: Int = 0, boost: Double) {
        self.type = type
        self.category = category
        self.name = name
        self.startCost = startCost
        self.cost = startCost
        self.level = level
        self.boost = boost
    }
    /*
    // Constructor with firestore input and creating object
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        type = snapshotValue["type"] as! String
        category = snapshotValue["category"] as! String
        name = snapshotValue["name"] as! String
        cost = snapshotValue["cost"] as! Int
        level = snapshotValue["level"] as! Int
        boost = snapshotValue["boost"] as! Double
    }
    
    func toDict() -> [String : Any] {
        return ["type" : type,
                "category" : category,
                "name" : name,
                "cost" : cost,
                "level" : cost,
                "boost" : boost]
    }*/
}
