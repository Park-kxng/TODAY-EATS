//
//  OnBoarding4View.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/12/24.
//

import SwiftUI


#Preview {
    OnBoarding4View()
}

struct OnBoarding4View: View {

    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var selectedItem: String? = nil
    @State private var navigationValue: NavigationDestination?

    let title : String = "광고없는 미식가의 후기로 맛집을 찾아보세요!"
    let subTitle = "음식에 진심인 투데이츠!"


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
                .kerning(-0.2)
            Spacer()
                .frame(height: 8.0)
            Text(subTitle)
                .font(.teFont16M())
                .foregroundColor(Color.teTitleGray)
            
            Spacer().frame(height: 20)
             
            
            HStack{
                Spacer().frame(width: 20)
                Image("img_onboarding_2")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 460)
                Spacer().frame(width: 20)
            }
            
            Spacer().frame(maxHeight: 20)
            
            HStack{
                Spacer().frame(width: 15)
                
                NavigationLink {
                    ContentView()
                } label: {
                    Spacer()
                    Text("투데이츠 시작하기")
                        .font(.teFont18M())
                        .foregroundColor(fontColorClicked)
                    Spacer()
                }.frame(height: 56.0)
                    .background( backgroundClicked )
                    .cornerRadius(12)

                Spacer().frame(width: 15)

            }
            
            Spacer().frame(height: 20.0)

        }
        
        
        
    }
}
       


  
