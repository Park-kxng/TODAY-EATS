//
//  RestaurantView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import SwiftUI

struct RestaurantView: View {
    @EnvironmentObject var selectionModel: SelectionModel
    @StateObject private var viewModel = RestaurantViewModel()
    var navigationManager: NavigationManager
    
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var navigationValue: NavigationDestination?
    @State private var selectedItem: String?

    let title : String = "투데이츠 추천 맛집"
    let subTitle = "- ♡ 표시를 누르면 맛집을 저장해보세요!\n (마이페이지 > 저장한 맛집) \n 투데이츠 추천 메뉴 중 하나를 선택하면 \n 추천맛집을 검색할 수 있어요"

    @State var buttonTitles : [String] = ["마라탕", "스파게티", "떡볶이"]
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
                
                    // 제목
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
                    
                    MapView()

                    
                    ScrollView{
                            HStack{
                                Spacer().frame(width: 30)
                                
                                VStack(spacing: 15) {
                                    ForEach(viewModel.restaurants) { item in
                                        Button(action: {
                                            selectedItem = item.title
                                            
                                        }, label: {
                                            RestaurantButton(item: item, isSelected: selectedItem == item.title)                                        })
                                        
                                    }
                                }
                                
                                Spacer().frame(width: 30)
                        }
                        .onAppear{
                            viewModel.fetchGoodRestaurant(selection: selectionModel)
                        }
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
                        
                    }
                        

                    
                    Spacer().frame(height: 20.0)
                    
                
               
                }
            .navigationTitle("이전 단계로")
            
        }
       
//    func createButton (index : Int) -> some View {
//        HStack {
//            let title  = buttonTitles[index]
//            let selected = (selectedItem == title)
//
//            
//            SmallButton( viewName:"result", title: title, isSelected: selected) {
//                selectionModel.selectedMenu = selectedItem ?? ""
//                // 버튼이 클릭되었을 때의 동작
//               if selectedItem == title {
//                   // 이미 선택된 항목을 다시 클릭한 경우, 선택을 해제합니다.
//                   selectedItem = nil
//               } else {
//                   // 다른 항목을 선택한 경우, 선택된 항목을 업데이트합니다.
//                   selectedItem = title
//               }
//                nextButtonEnabled = !(selectedItem == nil)
//            }
//        
//            }
//        }
    
        
    
    
}
