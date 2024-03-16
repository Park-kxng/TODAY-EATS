//
//  CutomMarker.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/17/24.
//

import Foundation
import MapKit

class CustomMarker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil) {
        self.coordinate = coordinate
        self.title = title
    }
}
