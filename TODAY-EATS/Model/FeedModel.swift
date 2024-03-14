//
//  FeedModel.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/13/24.
//

import Foundation


struct FeedModel : Identifiable, Codable {
    var id: String
    
    
    var userID: String
    var userName: String
    var feedTitle: String
    var feedMemo : String
    var time: String
    var resName: String
    var location: String
    var rating: Int
    var waiting: Int
    var administrativeArea: String
    var locality: String
    var subLocality: String
    

}

