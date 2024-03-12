//
//  CommunityView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI
import MapKit
import CoreLocation

#Preview(body: {
    CommunityView()
})
// 피드 아이템을 나타내는 데이터 모델
struct FeedItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let rating: String
    let waiting: String
}

// 더미 데이터
let feedItems = [
    FeedItem(title: "맛도리만 찾아다님", description: "오늘도 맛집 탐방!", imageName: "img_charc", rating: "★★★☆☆", waiting: "10분"),
    FeedItem(title: "미식생 해고싶다", description: "마라탕은 역시 탕화라", imageName: "img_charc", rating: "★★★★☆", waiting: "15분"),
    FeedItem(title: "맛집 마스터", description: "겨울에 팥빙수를 먹어보았다", imageName: "img_charc", rating: "★★★☆☆", waiting: "20분"),
    // ... 여기에 더 많은 피드 아이템이 있을 수 있습니다.
]
struct CustomCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
struct CommunityView: View {
    @StateObject var firestoreManager = FireStoreManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItem: FeedItem?
    @StateObject private var locationViewModel = LocationViewModel()

    init() {
        configureNavigationBarAppearance()
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
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(feedItems) { item in
                                Button(action: {
                                    self.selectedItem = item
                                }) {
                                    FeedItemRow(item: item)
                                }
                                .buttonStyle(PlainButtonStyle()) // Removes the button's default styling
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack{
                                Button(action: {}) {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(Color.teMidGray)
                                }
                                Spacer()
                                    .frame(width: 4.0)
                                NavigationLink(destination: CreatePostView().navigationTitle("투데이츠 입력")) {
                                        HStack {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .renderingMode(.template)
                                                .aspectRatio(contentMode: .fill)
                                                .foregroundColor(Color.teMidGray)
                                        }
                                }
                           
                            }
                            .frame(height: 24.0)
                           
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



struct FeedItemRow: View {
    let item: FeedItem

    var body: some View {
        ScrollView {
            VStack{
                Spacer().frame(height: 15)
                // 사용자 정보
              HStack{
                  Spacer().frame(width: 26)
                  Image("tap_mypage")
                      .renderingMode(.template)
                      .resizable()
                      .foregroundColor(Color.teLightGray)
                      .scaledToFit()
                      .frame(width: 33, height: 33)
                      .background(Color.teLightGray)
                      .clipShape(Circle())

                  Spacer()
                      .frame(width: 10)
                  
                  VStack(alignment: .leading){
                      Text(item.title)
                          .font(.teFont14SM())
                          .foregroundColor(Color.teBlack)
                          .frame(height: 18.0)
                      Spacer()
                          .frame(height: 0.0)
                      Text("위치")
                          .multilineTextAlignment(.leading)
                          .font(.teFont12M())
                          .foregroundColor(Color.teMidGray)
                          .frame(height: 15.0)

                  }.frame(height: 33)
                  
                  Spacer()
              }
                
            Spacer().frame(height:10)
            // 게시물 내용
              HStack(alignment: .top) {
                  Spacer().frame(width: 26)
                  // 게시물 이미지
                  Image(item.imageName)
                      .resizable()
                      .scaledToFit()
                      .frame(width: 124, height: 124)
                      .cornerRadius(10)
                      .background(Color.teLightGray)
                  Spacer().frame(width: 22)

                  // 게시물 텍스트
                  VStack(alignment: .leading, spacing: 5) {
                      Text(item.description)
                          .font(.teFont14SM())
                          .foregroundColor(Color.teBlack)
                          .frame(height: 23)
                      Spacer()
                          .frame(height: 0.0)
                      HStack {
                          Text(item.rating)
                              .foregroundColor(.yellow)
                          Spacer()
                              .frame(width: 10.0)
                          
                          Text(item.waiting)
                              .foregroundColor(.teMidGray)
                              .font(.teFont11SM())
                              .padding(.horizontal, 10.0)
                              .frame(height: 20.0)
                              .background(Color.teLightGray)
                              .cornerRadius(32)
                          Spacer()
                      }.frame(height: 15)
                      
                      Spacer()
                  }
                  Spacer().frame(width: 26)
              }.background(Color.white)
                Spacer().frame(height: 15)
                HStack{
                    Spacer().frame(width: 20)
                    Rectangle()
                        .fill(Color.teLightGray)
                        .frame(height: 1)
                        .cornerRadius(20)
                    Spacer().frame(width: 20)

                }
             

          
            }.background(Color.white)
          }.task() {
              await startTask()
          }
                  
                      
    }
    func startTask() async {
           // 위치 사용 권한 설정 확인
           let locationManager = CLLocationManager()
           let authorizationStatus = locationManager.authorizationStatus
           
           // 위치 사용 권한 항상 허용되어 있음
           if authorizationStatus == .authorizedAlways {
           }
           // 위치 사용 권한 앱 사용 시 허용되어 있음
           else if authorizationStatus == .authorizedWhenInUse {
           }
           // 위치 사용 권한 거부되어 있음
           else if authorizationStatus == .denied {
               // 앱 설정화면으로 이동
               DispatchQueue.main.async {
                   UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
               }
           }
           // 위치 사용 권한 대기 상태
           else if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
               // 권한 요청 팝업창
               locationManager.requestWhenInUseAuthorization()
           }
       }
}

struct DetailView: View {
    let feedItem: FeedItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(feedItem.imageName)
                    .resizable()
                    .scaledToFit()

                Text(feedItem.title)
                    .font(.title)
                    .padding()

                Text(feedItem.description)
                    .padding()
                Text(feedItem.rating)
                    .padding()
                Text(feedItem.description)
                    .padding()
                // 여기에 더 많은 세부 정보를 추가할 수 있습니다.
            }
        }
        .navigationTitle(feedItem.title)
    }
}
