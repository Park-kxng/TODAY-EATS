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
    var body: some View {
        VStack {
            // 로고 이미지
            Image("img_spoonNfork")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 393, height: 387)
                .padding()
            
            // 로고 이미지
            Image("TODAY EATS")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 192, height: 46)
                .padding(.top, 24.0)
            
            // 서브 텍스트
            Text("오늘 뭐 먹지? 고민될 땐")
                .font(.custom("Helvetica", size: 18))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 7.0)
            
            // 카카오 로그인 버튼
            Button(action: {
                // 카카오 로그인 액션
            }) {
                Image("btn_login_apple")
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 332, height: 50)
            }
            .padding(.top, 72.0)
            
            // 애플 로그인 버튼
            Button(action: {
                // 애플 로그인 액션
            }) {
                Image("btn_login_naver")
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 332, height: 50)
            }
            .padding(.top, 16.0)
        }
        .padding()
    }
}

struct LoginView_Previews : PreviewProvider {
    static var previews: some View{
        LoginView()
    }
}

