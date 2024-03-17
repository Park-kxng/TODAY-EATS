//
//  FavariteResView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/17/24.
//

import Foundation
import SwiftUI
import MapKit



struct FavoriteResView: View {
    @EnvironmentObject var selectionModel: SelectionModel
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var selection: UUID?

    
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
    let subTitle = "저장한 맛집을 클릭하면 바로 길을 찾아드려요!\n"

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
                Spacer()
                    .frame(height: 8.0)
                
                Text(subTitle)
                    .font(.teFont16M())
                    .foregroundColor(Color.teTitleGray)
                    .multilineTextAlignment(.center)
                    ScrollView{
                            HStack{
                                Spacer().frame(width: 30)
                                
                                VStack(spacing: 15) {
                                    ForEach(viewModel.restaurants) { item in
                                        Button(action: {

                                            selectedItem = item.title
                                            selectedLongitude = String(item.mapx)
                                            selectedLatitude = String(item.mapy)
                                            openNaverMap(dlat: selectedLatitude!, dlng: selectedLongitude!, dname: selectedItem!)
                                            
                                      
                                            
                                        }, label: {
                                            RestaurantButton(item: item, buttonIsSelected: true, isSelected: true)                                        })
                                        
                                    }
                                }
                                
                                Spacer().frame(width: 30)
                        }
                        
                    }
                    
                        

                        

                    
                    Spacer().frame(height: 20.0)
                    
                
               
                }
                .onAppear {
                    viewModel.fetchFavoriteRes()
                    
                }.background(Color.white)
            
            

            
        }
    func openNaverMap(dlat:String , dlng : String, dname : String ) {
        guard let lat = UserDefaults.standard.string(forKey: "latitude"),
              let lng = UserDefaults.standard.string(forKey: "longitude") else {
            print("Required information is missing")
            return
        }
        print(lat,lng)
        var components = URLComponents(string: "nmap://route/public")
        
        components?.queryItems = [
            URLQueryItem(name: "slat", value: lat),
            URLQueryItem(name: "slng", value: lng),
            URLQueryItem(name: "sname", value: "현재 위치"),
            URLQueryItem(name: "dlat", value: dlat),
            URLQueryItem(name: "dlng", value: dlng),
            URLQueryItem(name: "dname", value: dname),
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
