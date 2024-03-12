//
//  LoginView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/8/24.
//

import Foundation
import SwiftUI
import SwiftData

struct LoginView : View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            
            VStack(alignment: .center) {
                // 로고 이미지
                Image("img_spoonNfork")
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth:  geometry.size.width )
                // 로고 이미지
                Image("TODAY EATS")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 192, height: 46)

                // 서브 텍스트
                Text("오늘 뭐 먹지? 고민될 땐")
                    .font(.teFont18M())
                    .foregroundColor(Color.teMidGray)
                    .kerning(-0.2)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(minHeight: 30, maxHeight: 120)
                // 카카오 로그인 버튼
                Button(action: {
                    // 카카오 로그인 액션
                }) {
                    Image("btn_login_apple")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: (geometry.size.width - CGFloat(30)), maxWidth: (geometry.size.width - CGFloat(20)))
                    
                }
                Spacer().frame(height: 15)

                // 애플 로그인 버튼
                Button(action: {
                    // 애플 로그인 액션
                }) {
                    Image("btn_login_naver")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: (geometry.size.width - CGFloat(30)), maxWidth: (geometry.size.width - CGFloat(20)))
                }
                Spacer().frame(minHeight: 30)
            }
            .background(colorScheme == .dark ? Color.teBlack : Color.white)

        }
    }
}

struct LoginView_Previews : PreviewProvider {
    static var previews: some View{
        LoginView()
    }
}

