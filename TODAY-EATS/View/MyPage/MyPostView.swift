//
//  MyPostView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//


import SwiftUI
import MapKit
import CoreLocation


struct CustomCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
struct MyPostView: View {
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
                }.clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 30))

               
                }
                .sheet(item: $selectedItem) { item in
                    DetailView(feedItem: item)
                }
                .background(Color.teCommunityBG)
        }
        .onAppear {
            viewModel.fetchUserPosts()
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


struct DetailView: View {
    var viewMdoel = UserViewModel()
    @State private var user : [String]?
    let feedItem: FeedModel
    var body: some View {
        ScrollView {
            HStack{
            Spacer().frame(width: 20)
            VStack(alignment: .leading) {
                Spacer().frame(height : 20)

                HStack{
                    if let user = user { // user가 nil이 아닌 경우에만 표시
                        // 사용자 이미지를 가져와서 표시
                        if let imageUrl = URL(string: user[1]) {
                            // 이미지를 비동기적으로 로드하여 표시
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .foregroundColor(Color.teLightGray)
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                        .background(Color.teLightGray)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .foregroundColor(Color.teLightGray)
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                        .background(Color.teLightGray)
                                        .clipShape(Circle())
                                @unknown default:
                                    fatalError()
                                }
                            }
                            
                            Spacer()
                                .frame(width: 10)
                            
                            VStack(alignment: .leading){
                                Text(user[0])
                                    .font(.teFont16SM())
                                    .foregroundColor(Color.teBlack)
                                    .frame(height: 24)
                                Spacer()
                                    .frame(height: 0.0)
                                Text(feedItem.resName)
                                    .multilineTextAlignment(.leading)
                                    .font(.teFont14M())
                                    .foregroundColor(Color.teMidGray)
                                    .frame(height: 19)
                                
                            }.frame(height: 45)
                            
                            Spacer()
                            
                        } else {
                            // 이미지 URL이 유효하지 않은 경우 기본 이미지 표시
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundColor(Color.teLightGray)
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .background(Color.teLightGray)
                                .clipShape(Circle())
                        }
                        
                    }
                }
                .onAppear {
                    // 뷰가 나타날 때 사용자 데이터를 가져오기
                    viewMdoel.fetchOtherUser(uid: feedItem.userID) { result in
                        if let result = result {
                            // 사용자 데이터 가져오기 성공 시 UI 업데이트
                            self.user = result
                            
                        } else {
                            // 사용자 데이터 가져오기 실패 시 에러 처리
                            print("Error fetching user data.")
                        }
                    }
                }
                Spacer().frame(height : 20)

                // 내용
                if feedItem.imageURL == "" {
                    Image("splash")
                        .frame(width: 350, height: 350)
                        .background(Color.teLightGray)
                }else{
                    AsyncImage(url: URL(string: feedItem.imageURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // 이미지가 로드되는 동안 표시될 뷰
                        case .success(let image):
                            image.resizable() // 이미지를 resizable로 만들어줌
                                .aspectRatio(contentMode: .fill) // 비율을 유지하면서 꽉 차게 채움
                                .frame(width:350 ,height: 350) // 원하는 프레임 크기 지정
                                .clipped() // 프레임 밖으로 나가는 부분을 잘라냄
                        case .failure(_):
                            Image(systemName: "photo") // 로드 실패 시 표시될 이미지
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                Spacer().frame(height : 20)

                Text(feedItem.feedTitle)
                    .font(.teFont22B())
                    .kerning(-0.2)
                    .foregroundStyle(Color.teBlack)
                    .padding(.bottom, 18)
                
                
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        // 별 모양을 표시, 채워진 별 또는 빈 별을 조건부로 표시
                        Image(index <= feedItem.rating ? "star_fill" : "star_fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor( index <= feedItem.rating ? .teYellow : .teBlack.opacity(0.3))
                            .frame(width: 22, height: 22) // 이미지 크기를 14x14로 설정
                        
                    }
                    Spacer()
                    Text("\(feedItem.waiting)분")
                        .foregroundColor(.teMidGray)
                        .font(.teFont16SM())
                        .kerning(-0.2)
                    
                        .padding(.horizontal, 10.0)
                        .frame(height: 28)
                        .background(Color.teLightGray)
                        .cornerRadius(32)
                    
                }
                
                Spacer().frame(height: 20)
                
                Text("\(feedItem.feedMemo)")
                    .font(.teFont14M())
                    .kerning(-0.2)
                    .foregroundStyle(Color.teBlack)
                
            }
            .navigationTitle("자세히 보기")
            Spacer().frame(width: 20)
        }
        }.background(Color.white)
    }
}
    struct FeedItemRow: View {
        var viewMdoel = UserViewModel()
        let item: FeedModel
        @State private var user : [String]?
        var body: some View {
            ScrollView {
                VStack{
                    Spacer().frame(height: 15)
                    // 사용자 정보
                    HStack{
                        Spacer().frame(width: 26)
                        if let user = user { // user가 nil이 아닌 경우에만 표시
                            // 사용자 이미지를 가져와서 표시
                            if let imageUrl = URL(string: user[1]) {
                                // 이미지를 비동기적으로 로드하여 표시
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .foregroundColor(Color.teLightGray)
                                            .scaledToFill()
                                            .frame(width: 33, height: 33)
                                            .background(Color.teLightGray)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .foregroundColor(Color.teLightGray)
                                            .scaledToFit()
                                            .frame(width: 33, height: 33)
                                            .background(Color.teLightGray)
                                            .clipShape(Circle())
                                    @unknown default:
                                        fatalError()
                                    }
                                }
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                VStack(alignment: .leading){
                                    Text(user[0])
                                        .font(.teFont14SM())
                                        .foregroundColor(Color.teBlack)
                                        .frame(height: 18.0)
                                    Spacer()
                                        .frame(height: 0.0)
                                    Text(item.resName)
                                        .multilineTextAlignment(.leading)
                                        .font(.teFont12M())
                                        .foregroundColor(Color.teMidGray)
                                        .frame(height: 15.0)
                                    
                                }.frame(height: 33)
                                
                                Spacer()
                                
                            } else {
                                // 이미지 URL이 유효하지 않은 경우 기본 이미지 표시
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundColor(Color.teLightGray)
                                    .scaledToFit()
                                    .frame(width: 33, height: 33)
                                    .background(Color.teLightGray)
                                    .clipShape(Circle())
                            }
                            
                        }
                    }
                    .onAppear {
                        // 뷰가 나타날 때 사용자 데이터를 가져오기
                        viewMdoel.fetchOtherUser(uid: item.userID) { result in
                            if let result = result {
                                // 사용자 데이터 가져오기 성공 시 UI 업데이트
                                self.user = result
                                
                            } else {
                                // 사용자 데이터 가져오기 실패 시 에러 처리
                                print("Error fetching user data.")
                            }
                        }
                    }
                    
                    
                    Spacer().frame(height:10)
                    // 게시물 내용
                    HStack(alignment: .top) {
                        Spacer().frame(width: 26)
                        // 게시물 이미지
                        if item.imageURL == "" {
                            Image("splash")
                                .frame(width: 124, height: 124)
                                .cornerRadius(10)
                                .background(Color.teLightGray)
                        }else{
                            AsyncImage(url: URL(string: item.imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 124, height: 124)
                            .cornerRadius(10)
                        }
                        
                        
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
            
            
        }}
