//
//  TodayEatsView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import SwiftUI


#Preview {
    TodayEatsView()
}


struct TodayEatsView: View {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject var selectionModel = SelectionModel()

    init(){
        makeNavigationBarTransparent()
    }

    let title: String = "오늘 뭐 먹을지 고민되나요?"
    let subTitle: String = "AI를 기반으로 맞춤형 메뉴를 추천해드려요"

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            
            VStack {
                Spacer().frame(height: 40)
                HStack{
                    Spacer().frame(width: 20)
                    Image("img_charc")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                    Spacer().frame(width: 20)
                }
                
                Spacer().frame(height: 40)
                Text(title)
                    .font(.teFont26B())
                    .kerning(-0.2)
                    .foregroundColor(Color.teBlack)
                Spacer().frame(height: 20)
                Text(subTitle)
                    .font(.teFont16M())
                    .foregroundColor(Color.teTitleGray)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack{
                    Spacer().frame(width: 15)
                    HStack{
                        Spacer()
                        NavigationLink("다음 단계로", value: "next")
                            .font(.teFont18M())
                            .foregroundColor(.white)
                            .navigationTitle("이전 단계로")
                        Spacer()
                    }.frame(height: 56.0)
                        .background(Color.teBlack)
                        .cornerRadius(12)
                    
                    
                    
                    Spacer().frame(width: 15)
                    
                }
                
                Spacer().frame(height: 15)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.all)) // 화면 전체에 빨간색 배경 적용
            .navigationDestination(for: String.self) { str in
                switch str {
                case "next": CuisineSelectionView(navigationManager: navigationManager).environmentObject(selectionModel)
                default: EmptyView()
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



