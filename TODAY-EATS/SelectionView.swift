//
//  Selection.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/10/24.
//

import Foundation
import SwiftUI


struct SelectionView: View {
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var selectedItem: String? = nil
    @Binding var navigationValue: NavigationDestination?

    var title : String = ""
    var subTitle : String = ""
    var viewName : String = ""
    // 컬럼 레이아웃 정의
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]
    var buttonTitles : [String] = []
    var buttonLines : [ClosedRange<Int>] = []
    @State private var selectedCuisines: Set<String> = []
    @State private var nextButtonEnabled: Bool = false
    
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
                
                NextButton(isSelected: nextButtonEnabled) {
                    isNavigationActive = true
                    print("다음단계로 클릭")
                    navigationValue = .spicySelection // This state change triggers navigation

                    
                }.disabled(!nextButtonEnabled)
                    
                Spacer().frame(height: 20.0)
                
            }
        
    }
   
    func createButtonRow(range : ClosedRange<Int>) -> some View {
            HStack {
                ForEach(range, id: \.self) { index in
                    let title  = buttonTitles[index-1]
                    if viewName == "spicySelection" {
                        let selected = (selectedItem == title)
                        SmallButton( viewName:viewName, title: title, isSelected: selected) {
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
                    }else{
                        SmallButton( viewName:viewName, title: title, isSelected: selectedCuisines.contains(title)) {

                                    // 버튼이 클릭되었을 때의 동작
                                    if selectedCuisines.contains(title) {
                                        selectedCuisines.remove(title)
                                    } else {
                                        selectedCuisines.insert(title)
                                    }
                            nextButtonEnabled = selectedCuisines.isEmpty ? false : true
                        }
                        if index != 4 || index != 8 {
                            Spacer().frame(width: 8)
                        }
                    }
       
                    
                }
            }
        }
}

