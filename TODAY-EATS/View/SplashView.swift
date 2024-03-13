//
//  SplashView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import Foundation
import SwiftUI

struct SplashView: View {
    
    
    var body: some View {
        ZStack {
                    Color.black
                        .edgesIgnoringSafeArea(.all) // 배경을 검은색으로 설정하고 safe area까지 적용

                    Image("splash") // 로고 이미지
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                }
    }
        
}

#Preview {
    SplashView()
}
