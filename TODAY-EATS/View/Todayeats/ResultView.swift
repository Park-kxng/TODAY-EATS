//
//  ResultView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI

#Preview(body: {
    ResultView(navigationManager: NavigationManager())
})



struct ResultView: View {
    var navigationManager: NavigationManager

    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var selectedItem: String? = nil
    @State private var navigationValue: NavigationDestination?

    let title : String = "오늘도 맛있는 한 끼 되세요!"
    let subTitle = "투데이츠 추천 메뉴 중 하나를 선택하면 \n추천맛집을 검색할 수 있어요"

    let buttonTitles : [String] = ["마라탕", "스파게티", "떡볶이"]
    let buttonLines : [ClosedRange<Int>] = [1...4, 5...8]
        @State private var selectedCuisines: Set<String> = []
        @State private var nextButtonEnabled: Bool = false
    
    let fontColor = Color.teMidGray
    let fontColorClicked = Color.white
    let backgroundColor = Color.teLightGray
    let backgroundClicked = Color.teBlack
    let backgroundClickedRed = Color.teRed

        var body: some View {
                
                VStack{
                    Spacer()
                        .frame(height: 60)
                    
                    
                    Image("img_charc")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 150, maxHeight: 200)
                    
                    Spacer().frame(height: 30)
                    
                    Text(title)
                        .font(.teFont26B())
                        .kerning(-0.2)
                    Spacer()
                        .frame(height: 8.0)
                    Text(subTitle)
                        .font(.teFont16M())
                        .foregroundColor(Color.teTitleGray)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    
                    ForEach(0..<buttonTitles.count, id: \.self) { index in
                        createButton(index: index)
                    }
                    
                    Spacer()
                        

                    HStack{
                        Spacer().frame(width: 15)
                        // "처음으로" 버튼의 수정된 동작
                        Button(action: {navigationManager.popToRootView()}) {
                            HStack {
                                Spacer()
                                Text("처음으로")
                                    .font(.teFont18M())
                                    .foregroundColor(fontColorClicked)
                                Spacer()
                            }
                            .frame(height: 56.0)
                            .background(backgroundClicked)
                            .cornerRadius(12)
                        }

                        
                        Spacer().frame(width: 15)
                        // "맛집 찾아보기" 버튼의 수정된 동작
                        NavigationLink(destination: WeatherSelectionView(navigationManager: navigationManager)) {
                            Spacer()
                            Text("맛집 찾아보기")
                                .font(.teFont18M())
                                .foregroundColor(nextButtonEnabled ? fontColorClicked : fontColor)
                            Spacer()
                        }
                        .frame(height: 56.0)
                        .background(nextButtonEnabled ? backgroundClickedRed : backgroundColor)
                        .cornerRadius(12)
                        .disabled(!nextButtonEnabled) // `!`를 추가하여 nextButtonEnabled가 true일 때 버튼이 활성화되도록 수정

                        Spacer().frame(width: 15)

                        }
                        

                    
                    Spacer().frame(height: 20.0)
                    
                
               
            }.onAppear {
                // Example logic to enable button - replace with your actual logic
                nextButtonEnabled = !(selectedItem == nil)
            }
            
        }
       
    func createButton (index : Int) -> some View {
        HStack {
            let title  = buttonTitles[index]                        
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
                nextButtonEnabled = !(selectedItem == nil)
            }
        
            }
        }
    }
