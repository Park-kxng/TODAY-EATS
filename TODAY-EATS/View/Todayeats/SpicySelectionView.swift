//
//  SpicySelectionView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/10/24.
//
import SwiftUI

struct SpicySelectionView: View {
 

    var navigationManager: NavigationManager

        @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
        @State private var isNavigationActive = false
        @State private var selectedItem: String? = nil
        @State private var navigationValue: NavigationDestination?

    let title : String = "둘 중 하나만 선택해주세요!"
    let subTitle = "맵기"

    let buttonTitles : [String] = ["매운 거", "안 매운 거"]
    var buttonLines : [ClosedRange<Int>] = [1...2]
        @State private var selectedCuisines: Set<String> = []
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
                    }
                    Spacer()
                    
                    HStack{
                        Spacer().frame(width: 15)
                        
                        NavigationLink {
                            OilySelectionView(navigationManager : navigationManager)
                                .navigationTitle("이전 단계로")

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

                        Spacer().frame(width: 15)

                    }
                    Spacer().frame(height: 20.0)
                    
                
               
            }.onAppear {
                // Example logic to enable button - replace with your actual logic
                nextButtonEnabled = !(selectedItem == nil)
            }
            
        }
       
        func createButtonRow(range : ClosedRange<Int>) -> some View {
                HStack {
                    ForEach(range, id: \.self) { index in
                        let title  = buttonTitles[index-1]
                        let selected = (selectedItem == title)
                        SmallButton( viewName:"spicySelection", title: title, isSelected: selected) {
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
    SpicySelectionView(navigationManager: NavigationManager())
}
