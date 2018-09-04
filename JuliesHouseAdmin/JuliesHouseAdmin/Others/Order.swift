//
//  Order.swift
//  JuliesHouseAdmin
//
//  Created by Yves Rijckaert on 06/05/2018.
//  Copyright © 2018 Yves Rijckaert. All rights reserved.
//

import Foundation
struct Order {
    let id: String
    let cake: Cake
    var status: OrderStatus
}
enum OrderStatus: String {
    case afwachting = "In afwachting"
    case aanvaard = "Aanvaard"
    case onderweg = "Onderweg"
    case aangekomen = "Aangekomen"
}
