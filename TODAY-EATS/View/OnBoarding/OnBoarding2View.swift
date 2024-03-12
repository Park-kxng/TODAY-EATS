//
//  OnBoarding2View.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI

struct OnBoarding2View: View {
    @ObservedObject var onBoardingManager: OnboardingManager
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var selectedItem: String? = nil

    let title : String = "당신의 입맛은?"
    let subTitle = "하나만 선택해주세요! 음식 추천 시 고려됩니다"

    let buttonTitles : [String] = ["🍭 어린이 입맛", "🍲 어르신 입맛","😊 다 잘 먹어요!"]
    var buttonLines : [ClosedRange<Int>] = [1...2,3...3]
    @State private var selectedCuisines: Set<String> = []
    @State private var nextButtonEnabled: Bool = false
    
    let fontColor = Color.teMidGray
    let fontColorClicked = Color.white
    let backgroundColor = Color.teLightGray
    let backgroundClicked = Color.teBlack
        var body: some View {
            NavigationView{
                VStack{
                    Spacer()
                        .frame(height: 60)
                    Text(title)
                        .font(.teFont26B())
                        .kerning(-0.2)
                    Spacer()
                        .frame(height: 8.0)
                    Text(subTitle)
                        .font(.teFont16M())
                        .foregroundColor(Color.teTitleGray)
                    
                    Spacer()
                        .frame(height: 45.0)
                    
                    
                    ForEach(0..<buttonLines.count, id: \.self) { index in
                        createButtonRow(range: buttonLines[index])
                        Spacer().frame(height: 12)
                    }
                    Spacer()
                    
                    HStack{
                        Spacer().frame(width: 15)
                        
                        NavigationLink {
                            OnBoarding3View(onBoardingManager: onBoardingManager)
                        } label: {
                            Spacer()
                            Text("다음 단계로")
                                .font(.teFont18M())
                                .foregroundColor(nextButtonEnabled ? fontColorClicked : fontColor)
                            Spacer()
                        }.frame(height: 56.0)
                            .background(nextButtonEnabled ? backgroundClicked : backgroundColor)
                            .cornerRadius(12)
                            .disabled(!nextButtonEnabled)
                            .renameAction {
                                onBoardingManager.goToNextStep()
                            }
                        
                        Spacer().frame(width: 15)
                        
                    }
                    Spacer().frame(height: 15)
                    
                    
                    
                }
                .onAppear {
                    // Example logic to enable button - replace with your actual logic
                    nextButtonEnabled = !(selectedItem == nil)
                }
            }
            
        }
       
        func createButtonRow(range : ClosedRange<Int>) -> some View {
                HStack {
                    ForEach(range, id: \.self) { index in
                        let title  = buttonTitles[index-1]
                        let selected = (selectedItem == title)
                        SmallButton( viewName:"result", title: title, isSelected: selected) {
                            // 버튼이 클릭되었을 때의 동작
                           if selectedItem == title {
                               // 이미 선택된 항목을 다시 클릭한 경우, 선택을 해제합니다.
                               selectedItem = nil
                           } else {
                               // 다른 항목을 선택한 경우, 선택된 항목을 업데이트합니다.
                               selectedItem = title
                           }
                            nextButtonEnabled = (selectedItem == nil) ? false : true
                        }
                    }
                }
            }
    }
#Preview {
    OnBoarding2View(onBoardingManager: OnboardingManager())
}

