//
//  CommunityView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}



struct CommunityView: View {
    @StateObject var viewModel = CommunityViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItem: FeedModel?
    @StateObject private var locationViewModel = LocationViewModel()
    init() {
        configureNavigationBarAppearance()

    }
    // 별 모양을 생성하고 사용자 입력을 처리하는 함수
    private func StarButton(index: Int, rating : Int) -> some View {
        Button(action: {
            // 사용자가 탭한 별의 인덱스를 기반으로 rating 값을 업데이트
        }) {
            // 별 모양을 표시, 채워진 별 또는 빈 별을 조건부로 표시
            Image(index <= rating ? "star_fill" : "star_fill")
                .renderingMode(.template)
                .foregroundColor(index <= rating ? .teYellow : .teBlack.opacity(0.3))
        }
    }
    var body: some View {
        NavigationView {
            VStack(){
                VStack {
                }
                .frame(height: 20)
                .background(Color.white) // VStack의 배경색을 흰색으로 설정
                Spacer().frame(height: 0.0)
                ZStack{
                    Color.white // 배경색을 흰색으로 설정
                                   .edgesIgnoringSafeArea(.all) // 배경색이 전체 화면을 채우도록 설정

//                        if viewModel.feeds.isEmpty {

                            Text("아직 올라온 동네 맛집 소식이 없어요!")
                                .font(.teFont18M())
                                .foregroundStyle(Color.teTitleGray)


                           
//                        }else{
//                ScrollView {
//                            VStack(spacing: 0) {
//                             
//                                ForEach(viewModel.feeds) { item in
//                                    Button(action: {
//                                        self.selectedItem = item
//                                    }) {
//                                        FeedItemRow(item: item)
//                                    }
//                                    .buttonStyle(PlainButtonStyle()) // Removes the button's default styling
//                                    
//                                }
//                            }

  
                        
//                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack{
//                                Button(action: {}) {
//                                    Image(systemName: "magnifyingglass")
//                                        .resizable()
//                                        .renderingMode(.template)
//                                        .aspectRatio(contentMode: .fill)
//                                        .foregroundColor(Color.teMidGray)
//                                }
//                                Spacer()
//                                    .frame(width: 10)
                                NavigationLink(destination: CreatePostView()
                                    .navigationTitle("투데이츠 입력")
                                    .navigationBarTitleDisplayMode(.inline)
                                ) {
                                        HStack {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .renderingMode(.template)
                                                .aspectRatio(contentMode: .fill)
                                                .foregroundColor(Color.teMidGray)
                                        }
                                }
                           
                            }
                            .frame(height: 30)
                           
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack{
                                Button(action: {}) {
                                    Text(locationViewModel.address)
                                        .font(.teFont18B())
                                        .foregroundColor(Color.teBlack)
                                    Spacer()
                                        .frame(width: 10)
                                    Image(systemName: "chevron.down")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color.teBlack)
                                        .frame(width: 12, height: 6)
                                       
                                }
                                
                            }
                           
                               
                            }
                        }
                }.clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 30))

               
                }
                .sheet(item: $selectedItem) { item in
                    DetailView(feedItem: item)
                }
                .background(Color.teCommunityBG)
        }
        .onAppear {
            viewModel.fetchPostsArea()// ViewModel에서 현 지역 feed 데이터를 불러오는 함수 호출
        }

            
    }
    
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
               
       // ToolBar 배경 색상 설정
       appearance.backgroundColor = UIColor.white // UIColor로 원하는 색상 지정
     
       // 아래 코드를 통해 커스텀한 모양을 네비게이션 바에 적용
       UINavigationBar.appearance().standardAppearance = appearance
       UINavigationBar.appearance().compactAppearance = appearance
       UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }



