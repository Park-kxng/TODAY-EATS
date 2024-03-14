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


struct CustomCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
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
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.feeds) { item in
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
                                    .frame(width: 10)
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
            viewModel.fetchFeeds()// ViewModel에서 feed 데이터를 불러오는 함수 호출
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
    let item: FeedModel

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
                      Text(item.userName)
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
                  Image("img_charc")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 124, height: 124)
                      .cornerRadius(10)
                      .background(Color.teLightGray)
                  Spacer().frame(width: 22)

                  // 게시물 텍스트
                  VStack(alignment: .leading, spacing: 5) {
                      Text(item.feedTitle)
                          .font(.teFont14SM())
                          .foregroundColor(Color.teBlack)
                          .frame(height: 23)
                      Spacer()
                          .frame(height: 0.0)
                      HStack {
                          ForEach(1...5, id: \.self) { index in
                              // 별 모양을 표시, 채워진 별 또는 빈 별을 조건부로 표시
                              Image(index <= item.rating ? "star_fill" : "star_fill")
                                  .resizable()
                                  .renderingMode(.template)
                                  .foregroundColor( index <= item.rating ? .teYellow : .teBlack.opacity(0.3))
                                  .frame(width: 14, height: 14) // 이미지 크기를 14x14로 설정

                          }
                          Spacer()
                              .frame(width: 10.0)
                          
                          Text("\(item.waiting)분")
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
    let feedItem: FeedModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image("img_charc")
                    .resizable()
                    .scaledToFit()

                Text(feedItem.feedTitle)
                    .font(.title)
                    .padding()

                Text(feedItem.feedMemo)
                    .padding()
                Text("\(feedItem.rating)")
                    .padding()
                Text("\(feedItem.waiting)")
                    .padding()
                // 여기에 더 많은 세부 정보를 추가할 수 있습니다.
            }
        }
        .navigationTitle("자세히 보기")
    }
}
