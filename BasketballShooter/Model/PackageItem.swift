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
    
    // MARK: Variables
    var type : String
    var cost : Int
    
    // MARK: Constants
    let name : String
    let id : String
    let boost : Double
    
    // MARK: initializers
    init(type: String, name: String, id: String, cost: Int, level: Int = 0, boost: Double) {
        self.type = type
        self.name = name
        self.id = id
        self.cost = cost
        self.boost = boost
        
    }
    // Constructor with firestore input and creating object
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        type = snapshotValue["type"] as! String
        name = snapshotValue["name"] as! String
        id = snapshotValue["id"] as! String
        cost = snapshotValue["cost"] as! Int
        boost = snapshotValue["boost"] as! Double
    }
    
    // MARK: Functions
    func toDict() -> [String : Any] {
        return ["type" : type,
                "id" : id,
                "name" : name,
                "cost" : cost,
                "boost" : boost]
    }
}
