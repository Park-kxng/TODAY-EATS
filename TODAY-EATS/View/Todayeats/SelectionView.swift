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
    var Title : String = ""
    var subTitle : String = ""
    // 컬럼 레이아웃 정의
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]
    var buttonTitles : [String] = []
    @State private var selectedCuisines: Set<String> = []
    @State private var nextButtonClicked: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 5)
            HStack {
                Spacer()
                    .frame(width: 10)
                Button(action: {
                    // presentationMode.wrappedValue.dismiss() // 이전 화면으로 돌아가는 동작
                }) {
                    HStack{
                        Spacer()
                            .frame(width: 5.0)

                        Image(systemName: "chevron.left") // 시스템 아이콘 사용
                            .foregroundColor(Color.teMidGray) // 아이콘 색상 설정
                        Text("이전 단계로")
                            .font(.teFont12M())
                            .foregroundColor(Color.teMidGray)
                        Spacer()
                            .frame(width: 5.0)
                }
                   
                }
                .frame( height: 30) // 버튼의 프레임 설정
                .cornerRadius(5)
                
                Spacer()
            }
           

          
            Spacer()
                .frame(height: 40)
            Text("먹고 싶은 음식의 종류는?")
                .font(.teFont26B())
                .kerning(-0.2)
            Spacer()
                .frame(height: 8.0)
            Text("복수 선택이 가능해요!")
                .font(.teFont16M())
                .foregroundColor(Color.teTitleGray)
                
            Spacer()
                .frame(height: 45.0)
            
            createButtonRow(range: 1...4)
            createButtonRow(range: 5...8)
      
            Spacer()
            
            NextButton(isSelected: nextButtonClicked) {
                print(nextButtonClicked)
            }
           
            Spacer().frame(height: 20.0)
            
        }
    }
    
    func createButtonRow(range : ClosedRange<Int>) -> some View {
            HStack {
                ForEach(range, id: \.self) { index in
                    let title  = buttonTitles[index-1]
                    SmallButton(title: title, isSelected: selectedCuisines.contains(title)) {
                        // 버튼이 클릭되었을 때의 동작
                        if selectedCuisines.contains(title) {
                            selectedCuisines.remove(title)
                        } else {
                            selectedCuisines.insert(title)
                        }
                        
                        nextButtonClicked = selectedCuisines.isEmpty ? false : true

                    }
                    if index != 4 || index != 8 {
                        Spacer().frame(width: 8)
                    }
                }
            }
        }
}
#Preview {
    CuisineSelectionView()
    
}
