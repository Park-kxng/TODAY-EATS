//
//  RestaurantModel.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/17/24.
//

import Foundation

struct RestaurantModel : Identifiable, Codable {
    var id: String

    
    var title: String
    var category: String
    var telephone: String
    var roadAddress: String
    var mapx: Int
    var mapy: Int
}
