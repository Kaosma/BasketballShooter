//
//  PackageItem.swift
//  BasketballShooter
//
//  Created by Erik Ugarte on 2020-02-07.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation
import Firebase

class PackageItem {
    var type : String
    let name : String
    var cost : Int
    let boost : Double
    
    init(type: String, name: String, cost: Int, level: Int = 0, boost: Double) {
        self.type = type
        self.name = name
        self.cost = cost
        self.boost = boost
    }
    
    // Constructor with firestore input and creating object
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        type = snapshotValue["type"] as! String
        name = snapshotValue["name"] as! String
        cost = snapshotValue["cost"] as! Int
        boost = snapshotValue["boost"] as! Double
    }
    
    func toDict() -> [String : Any] {
        return ["type" : type,
            "name" : name,
            "cost" : cost,
            "boost" : boost]
    }
}
