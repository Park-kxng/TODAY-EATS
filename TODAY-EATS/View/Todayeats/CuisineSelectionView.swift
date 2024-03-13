//
//  CuisineSelectionView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/10/24.
//


import SwiftUI

struct CuisineSelectionView: View {
    var navigationManager: NavigationManager

    @EnvironmentObject var selectionModel: SelectionModel
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var selectedItem: String? = nil
    @State private var navigationValue: NavigationDestination?

    let title : String = "먹고 싶은 음식의 종류는?"
    let subTitle = "복수 선택 가능해요!"

    let buttonTitles : [String] = ["한식", "중식", "일식", "양식", "아시아 음식", "분식", "카페", "기타"]
    let buttonLines : [ClosedRange<Int>] = [1...4, 5...8]
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
                            SpicySelectionView(navigationManager : navigationManager)
                                .navigationTitle("이전 단계로")
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

                        Spacer().frame(width: 15)

                    }
                    Spacer().frame(height: 20.0)
                    
                    
                    
                }
                .navigationDestination(for: String.self) { str in
                    switch str {
                    case "next": CuisineSelectionView(navigationManager: navigationManager)
                    default: EmptyView()
                    }
                
            }
                .onAppear {
                    // Example logic to enable button - replace with your actual logic
                    selectionModel.cuisine = selectedCuisines
                    print(selectionModel.cuisine)
                    nextButtonEnabled = !selectedCuisines.isEmpty
                }.onChange(of: selectedCuisines, { oldValue, newValue in
                    selectionModel.cuisine = newValue
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
    
    private func makeNavigationBarTransparent() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // Makes background transparent
        appearance.shadowColor = .clear // Removes the shadow
        appearance.backgroundColor = .clear // Sets background color to clear
        UINavigationBar.appearance().tintColor = UIColor.lightGray // Adjust the back button color as needed
        // For the title and large title text attributes, set them to clear or empty to make them less noticeable
        appearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.clear]

        UINavigationBar.appearance().tintColor = UIColor.red

        // Apply the customized appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .lightGray

    }


    }

#Preview {
    CuisineSelectionView(navigationManager: NavigationManager())
}
