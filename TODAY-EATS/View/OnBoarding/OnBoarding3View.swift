//
//  OnBoarding3View.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI


//#Preview {
//    OnBoarding3View()
//}

struct OnBoarding3View: View {
    @ObservedObject var onBoardingManager: OnboardingManager

        @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
        @State private var isNavigationActive = false
        @State private var selectedItem: String? = nil
        @State private var navigationValue: NavigationDestination?

    let title : String = "AI가 당신의 입맛대로\n메뉴를 추천해줍니다"
    let subTitle = "메뉴 고민은 이제 그만!"


    @State private var nextButtonEnabled: Bool = false
    
    let fontColor = Color.teMidGray
    let fontColorClicked = Color.white
    let backgroundColor = Color.teLightGray
    let backgroundClicked = Color.teBlack
    var body: some View {
        
        VStack{
            Spacer()
                .frame(height: 60)
            Text(title)
                .font(.teFont26B())
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.teBlack)

                .kerning(-0.2)
            Spacer()
                .frame(height: 8.0)
            Text(subTitle)
                .font(.teFont16M())
                .foregroundColor(Color.teTitleGray)
            
            Spacer().frame(height: 20)
             
            
            HStack{
                Spacer().frame(width: 20)
                Image("img_onboarding_1")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 300, maxHeight: 460)
                Spacer().frame(width: 20)
            }
            
            Spacer().frame(maxHeight: 40)
            
            HStack{
                Spacer().frame(width: 15)
                
                NavigationLink {
                    OnBoarding4View(onboardingManager: onBoardingManager)
                        .background(Color.white.edgesIgnoringSafeArea(.all)) // 화면 전체에 빨간색 배경 적용

                } label: {
                    Spacer()
                    Text("다음 단계로")
                        .font(.teFont18M())
                        .foregroundColor(fontColorClicked)
                    Spacer()
                }.frame(height: 56.0)
                    .background( backgroundClicked )
                    .cornerRadius(12)
                    .renameAction {
                        onBoardingManager.goToNextStep()
                    }

                Spacer().frame(width: 15)

            }
            
            Spacer().frame(height: 15)

        }.navigationBarBackButtonHidden(true)
            .background(Color.white.edgesIgnoringSafeArea(.all)) // 화면 전체에 빨간색 배경 적용

        
    }
}
       

#Preview {
    OnBoarding3View(onBoardingManager: OnboardingManager())
}


  
