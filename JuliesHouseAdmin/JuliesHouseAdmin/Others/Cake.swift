//
//  Pizza.swift
//  JuliesHouseAdmin
//
//  Created by Yves Rijckaert on 06/05/2018.
//  Copyright © 2018 Yves Rijckaert. All rights reserved.
//

import UIKit
struct Cake {
    let id: String
    let name: String
    let description: String
    let amount: NSNumber
    let image: UIImage
    init(data: [String: Any]) {
        self.id = data["id"] as! String
        self.name = data["name"] as! String
        self.amount = data["amount"] as! NSNumber
        self.description = data["description"] as! String
        self.image = data["image"] as! UIImage
    }
}

