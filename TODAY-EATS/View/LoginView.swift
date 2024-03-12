//
//  LoginView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/8/24.
//

import Foundation
import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CryptoKit
import AuthenticationServices

struct LoginView : View {
    @StateObject var onBoardingManager = OnboardingManager()
    @State private var navigateToOnboarding = false

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    

    var body: some View {
        NavigationStack {
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

                HStack{
                    Spacer().frame(width: 15)
                    VStack{
                        // 애플 로그인
                        Button(action: {
                            print("애플 로그인 버튼 클릭")
                            authService.startSignInWithAppleFlow()
                            if authService.signInSuccess {
                                print(authService.signInSuccess)
                                navigateToOnboarding = true
                            }
                            
                        }) {
                            Image("btn_login_apple")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                        }
                        .navigationDestination(
                            isPresented: $navigateToOnboarding) {
                                             OnBoarding1View(onBoardingManager: onBoardingManager )
                                    .navigationBarBackButtonHidden()

                                         }
                        //
                        Spacer().frame(height: 15)
                        
                        // 네이버 로그인 버튼
                        Button(action: {
                        }) {
                            Image("btn_login_naver")
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    Spacer().frame(width: 15)

                }
               
                
                }
            

                Spacer().frame(minHeight: 30)
            }
            .background(colorScheme == .dark ? Color.teBlack : Color.white)
            //v
            
        }
        .onChange(of: authService.signInSuccess) { oldState, newState in
            navigateToOnboarding = newState
        }
      
    
    }
       
}


