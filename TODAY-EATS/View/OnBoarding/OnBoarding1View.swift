//
//  OnBoarding1View.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI

struct OnBoarding1View: View {
    @ObservedObject var onBoardingManager: OnboardingManager

    @StateObject private var navigationManager = NavigationManager()

    @State private var isNavigationActive = false

    let title: String = "반가워요, 박근영님"
    let subTitle: String = "뭐 먹을지 고민되면 언제든 찾아주세요!"

    var body: some View {
            VStack {
                Spacer().frame(height: 60)
                HStack{
                    Spacer().frame(width: 20)
                    Image("img_charc")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 150)
                    Spacer().frame(width: 20)
                }
                
                Spacer().frame(height: 40)
                Text(title)
                    .font(.teFont26B())
                    .kerning(-0.2)
                    .foregroundColor(Color.teBlack)
                Spacer().frame(height: 20)
                Text(subTitle)
                    .font(.teFont16M())
                    .foregroundColor(Color.teTitleGray)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack{
                    Spacer().frame(width: 15)
                    HStack{
                        Spacer()
                        NavigationLink {
                            OnBoarding2View(onBoardingManager: onBoardingManager)
                                .navigationBarBackButtonHidden()

                        } label: {
                            Spacer()
                            Text("다음 단계로")
                                .font(.teFont18M())
                                .foregroundColor(.white)
                            Spacer()
                        }.frame(height: 56.0)
                            .background( Color.teBlack )
                            .cornerRadius(12)

                           
                        Spacer()
                    }.frame(height: 56.0)
                        .background(Color.teBlack)
                        .cornerRadius(12)
    
                

                    
                    Spacer().frame(width: 15)
                    
                }
                
                Spacer().frame(height: 15)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.all)) // 화면 전체에 빨간색 배경 적용

    }
}


#Preview {
    OnBoarding1View(onBoardingManager: OnboardingManager())
}

