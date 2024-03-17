//
//  LocationCheckView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationCheckView: View {
    @EnvironmentObject var selectionModel: SelectionModel

    var navigationManager: NavigationManager

    @StateObject private var locationViewModel = LocationViewModel()

        @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
        @State private var isNavigationActive = false
        @State private var selectedItem: String? = nil
        @State private var navigationValue: NavigationDestination?

    let title : String = "현재 위치가 여기인가요?"
    let subTitle = "위치를 기반으로 음식점을 추천해줘요!"

    @State private var selectedCuisines: Set<String> = []
    @State private var nextButtonEnabled: Bool = false
    
    let fontColor = Color.teMidGray
    let fontColorClicked = Color.white
    let backgroundColor = Color.teLightGray
    let backgroundClicked = Color.teBlack
    
    
    
        var body: some View {
                
                VStack{
                    Spacer()
                        .frame(height: 40)
                    Text(title)
                        .font(.teFont26B())
                        .kerning(-0.2)
                        .foregroundStyle(Color.teBlack)

                    Spacer()
                        .frame(height: 8.0)
                    Text(subTitle)
                        .font(.teFont16M())
                        .foregroundColor(Color.teTitleGray)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    ZStack(alignment: .top) { // 텍스트를 지도 위쪽에 배치합니다.
                        MapView()
                        
                        
                        // 텍스트 뷰를 추가합니다.
                        Text(locationViewModel.address)
                            .font(.teFont18M()) // 폰트 크기 설정
                            .padding(.all, 10.0) // 패딩 추가
                            .background(Color.teBlack.opacity(0.7)) // 텍스트 배경 색상 설정
                            .foregroundColor(.white) // 텍스트 색상 설정
                            .cornerRadius(30) // 텍스트 뷰 모서리 둥글게
                            .padding() // 안쪽 여백 추가
                    }.frame(minHeight: 200, maxHeight: 400)
                    Spacer()
                        .frame(height: 20.0).background(Color.red)
                    
                    Spacer()
                    HStack{
                        Spacer().frame(width: 15)
                        
                        NavigationLink {
                            PlaceSelectionView(navigationManager : navigationManager)
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨기기
                                .navigationBarItems(leading: BackButton(title: "이전 단계로")) // 커스텀 뒤로가기 버튼 추가
                                .environmentObject(selectionModel)

                        } label: {
                            Spacer()
                            Text("다음 단계로")
                                .font(.teFont18M())
                                .foregroundColor(  fontColorClicked  )
                            Spacer()
                        }.frame(height: 56.0)
                            .background( backgroundClicked  )
                            .cornerRadius(12)
                            .renameAction({locationViewModel.stopUpdatingLocation()}
                            

)

                        Spacer().frame(width: 15)

                    }
                 
                    Spacer().frame(height: 20.0)
                    
                    
                
               
            } .task() {
                await startTask()
                
            }.onAppear {
                print(selectionModel.selectedMenu)
               
            }.background(Color.white)
            
            
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


#Preview {
    LocationCheckView(navigationManager: NavigationManager())
}
