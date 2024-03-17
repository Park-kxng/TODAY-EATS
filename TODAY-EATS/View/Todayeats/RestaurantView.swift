//
//  RestaurantView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import SwiftUI
import MapKit
extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

struct Place: Identifiable {
    var id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let color: Color
}


struct RestaurantView: View {
    @EnvironmentObject var selectionModel: SelectionModel
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var selection: UUID?

    var navigationManager: NavigationManager
    
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var navigationValue: NavigationDestination?
    @State private var selectedItem: String?

    @State private var selectedLatitude: String?
    @State private var selectedLongitude: String?
    @State var region = MKCoordinateRegion(center:.init(latitude: -32.5,
                                                       longitude: 115.75),
                                               latitudinalMeters: 100_000,
                                              longitudinalMeters: 100_000)
    let title : String = "투데이츠 추천 맛집"
    let subTitle = "♡ 표시를 누르면 맛집을 저장해보세요!\n(마이페이지 > 저장한 맛집)"

    @State var buttonTitles : [String] = ["마라탕", "스파게티", "떡볶이"]
    let buttonLines : [ClosedRange<Int>] = [1...4, 5...8]
        @State private var selectedCuisines: Set<String> = []
        @State private var nextButtonEnabled: Bool = false


    let fontColor = Color.teMidGray
    let fontColorClicked = Color.white
    let backgroundColor = Color.teLightGray
    let backgroundClicked = Color.teBlack
    let backgroundClickedRed = Color.teRed
    @State var annotations : [Place] = [Place(name: "현 위치",
                                              coordinate: .init(latitude: UserDefaults.standard.double(forKey: "latitude") , longitude: UserDefaults.standard.double(forKey: "longitude")),
                                                  color: .black)]
        var body: some View {
                
                VStack{
                    Spacer()
                        .frame(height: 20)
                
                    // 제목
                    Text(title)
                        .font(.teFont26B())
                        .kerning(-0.2)
                        .foregroundStyle(Color.teBlack)

                    Spacer()
                        .frame(height: 8.0)
                    
                    Text(subTitle)
                        .font(.teFont16M())
                        .foregroundColor(Color.teTitleGray)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                        .frame(height: 20)

                    
                    ScrollView{
                            HStack{
                                Spacer().frame(width: 30)
                                
                                VStack(spacing: 15) {
                                    ForEach(viewModel.restaurants) { item in
                                        Button(action: {
                                            if selectedItem == item.title {
                                                selectedItem = nil
                                            }else{
                                                selectedItem = item.title
                                                selectedLongitude = String(item.mapx)
                                                selectedLatitude = String(item.mapy)
                                            }
                                      
                                            
                                        }, label: {
                                            RestaurantButton(item: item, isSelected: selectedItem == item.title)                                        })
                                        
                                    }
                                }
                                
                                Spacer().frame(width: 30)
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
                        Spacer().frame(width: 8)

                        Button(action: {openNaverMap()}) {
                            HStack {
                                Spacer()
                                Text("길 찾기")
                                    .font(.teFont18M())
                                    .foregroundColor( selectedItem != nil ? fontColorClicked : fontColor)
                                Spacer()
                            }
                            .frame(height: 56.0)
                            .background(selectedItem != nil ? backgroundClicked : backgroundColor)
                            .cornerRadius(12)
                        }
                        .disabled(selectedItem == nil)

                        
                        Spacer().frame(width: 15)
                        
                    }
                        

                    
                    Spacer().frame(height: 20.0)
                    
                
               
                }
                .onAppear {
                    viewModel.fetchGoodRestaurant(selection: selectionModel) {
                    }
                }.background(Color.white)
            
            

            
        }
    func openNaverMap() {
        guard let lat = UserDefaults.standard.string(forKey: "latitude"),
              let lng = UserDefaults.standard.string(forKey: "longitude"),
              let selectedLatitude = selectedLatitude,
              let selectedLongitude = selectedLongitude,
              let selectedItem = selectedItem else {
            print("Required information is missing")
            return
        }
        print(lat,lng,selectedLatitude,selectedLongitude, selectedItem)
        var components = URLComponents(string: "nmap://route/public")
        
        components?.queryItems = [
            URLQueryItem(name: "slat", value: lat),
            URLQueryItem(name: "slng", value: lng),
            URLQueryItem(name: "sname", value: "현재 위치"),
            URLQueryItem(name: "dlat", value: selectedLatitude),
            URLQueryItem(name: "dlng", value: selectedLongitude),
            URLQueryItem(name: "dname", value: selectedItem),
            URLQueryItem(name: "appname", value: "com.pky.todayEats")
        ]
        
        guard let url = components?.url else {
            print("Failed to create URL")
            return
        }
        
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
       

        
    
    
}
