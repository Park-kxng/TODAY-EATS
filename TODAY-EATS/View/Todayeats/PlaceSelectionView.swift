//
//  PlaceSelectionView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI


struct PlaceSelectionView: View {
    @EnvironmentObject var selectionModel: SelectionModel

    var navigationManager: NavigationManager

        @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
        @State private var isNavigationActive = false
        @State private var selectedItem: String? = nil
        @State private var navigationValue: NavigationDestination?

    let title : String = "원하는 장소 분위기는?"
    let subTitle = "복수 선택 가능해요!"

    let buttonTitles : [String] = ["✨ 분위기 좋은", "🤫 조용한", "🪑 편한 좌석", "💬 대화", "🍙 혼밥", "🍺 혼술", "🏝️ 이국적인"]
    let buttonLines : [ClosedRange<Int>] = [1...3, 4...7]
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
                            WeatherSelectionView(navigationManager : navigationManager)
                                .environmentObject(selectionModel)

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
                            .navigationTitle("이전 단계로")

                        Spacer().frame(width: 15)

                    }
                  
                    Spacer().frame(height: 20.0)
                    
                
               
            }.onAppear {
                print(selectionModel.oily)
                selectionModel.place = selectedCuisines
                nextButtonEnabled = !selectedCuisines.isEmpty
            }
            .onChange(of: selectedCuisines , { oldValue, newValue in
                selectionModel.place = newValue
                nextButtonEnabled = !newValue.isEmpty

            })
            
        }
       
        func createButtonRow(range : ClosedRange<Int>) -> some View {
                HStack {
                    ForEach(range, id: \.self) { index in
                        let title  = buttonTitles[index-1]
                        
                        SmallButton( viewName:"", title: title, isSelected: selectedCuisines.contains(title)) {
                            
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
 

#Preview {
    PlaceSelectionView(navigationManager: NavigationManager())
}
