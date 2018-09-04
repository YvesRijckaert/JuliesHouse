//
//  CityLocation.swift
//  JuliesHouse
//
//  Created by Yves Rijckaert on 10/05/2018.
//  Copyright © 2018 Yves Rijckaert. All rights reserved.
//

import Foundation
import MapKit

class CityLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
