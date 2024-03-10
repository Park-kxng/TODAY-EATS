//
//  Desgin.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/9/24.
//

import Foundation
import SwiftUI

extension Font {
    static func teFont26B() -> Font {
        return Font.custom("AppleSDGothicNeo-Bold", size: 26)
    }
    
    static func teFont14R() -> Font {
        return Font.custom("AppleSDGothicNeo-medium", size: 14)
    }
    static func teFont12M() -> Font {
        return Font.custom("AppleSDGothicNeo-medium", size: 12)
    }
    static func teFont16M() -> Font {
        return Font.custom("AppleSDGothicNeo-medium", size: 16)
    }
    
    static func teFont16SM() -> Font {
        return Font.custom("AppleSDGothicNeo-SemiBold", size: 16)
    }
    static func teFont18M() -> Font {
        return Font.custom("AppleSDGothicNeo-medium", size: 18)
    }
    // 나머지 폰트에 대해서도 유사하게 정의합니다.
}

extension Color {
    static let teBlack = Color(red: 48/255, green: 48/255, blue: 48/255)
    static let teMypageGray = Color(red: 138/255, green: 138/255, blue: 138/255)
    static let teTitleGray = Color(red: 185/255, green: 185/255, blue: 185/255)
    static let teLightGray = Color(red: 246/255, green: 246/255, blue: 246/255)
    static let teMidGray = Color(red: 175/255, green: 175/255, blue: 175/255)

    static let mpMainColorA30 = Color(red: 19/255, green: 203/255, blue: 191/255, opacity: 0.3)
    
    // 나머지 색상에 대해서도 유사하게 정의합니다.
}
