//
//  Desgin.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/9/24.
//

import Foundation
import SwiftUI

extension Font {
    static func mpFont26B() -> Font {
        return Font.custom("AppleSDGothicNeo-Bold", size: 26)
    }
    static func teFont12M() -> Font {
        return Font.custom("AppleSDGothicNeo-medium", size: 12)
    }
    
    // 나머지 폰트에 대해서도 유사하게 정의합니다.
}

extension Color {
    static let teBlack = Color(red: 48/255, green: 48/255, blue: 48/255)
    static let mpMainColorA30 = Color(red: 19/255, green: 203/255, blue: 191/255, opacity: 0.3)
    
    // 나머지 색상에 대해서도 유사하게 정의합니다.
}
