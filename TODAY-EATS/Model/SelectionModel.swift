//
//  FoodModel.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import Foundation

class SelectionModel: ObservableObject, Identifiable {
    var id: String = UUID().uuidString
    
    @Published var cuisine: Set<String> = []
    @Published var spicy: String = ""
    @Published var oily: String = ""
    @Published var place: Set<String> = []
    @Published var weather: Set<String> = []
    @Published var location: String = ""
    
    // 여기에 필요한 초기화 메서드나 함수를 추가할 수 있습니다.
}
