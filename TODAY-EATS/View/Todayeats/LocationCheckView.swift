//
//  LocationCheckView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI
import MapKit
import CoreLocation
class LocationViewModel: NSObject, MKMapViewDelegate, CLLocationManagerDelegate, ObservableObject{
    var locationManager: CLLocationManager?
    @Published var address: String = "위치 정보를 가져오는 중..."

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization() // 앱 사용 중 위치 서비스 권한 요청
        self.locationManager?.startUpdatingLocation() // 위치 업데이트 시작
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        // 여기서 latestLocation을 사용하여 위치 데이터를 저장합니다.
        // 예: UserDefaults, CoreData, 서버 등
        print("Updated Location: \(latestLocation)")
        reverseGeocodeLocation(location: latestLocation)
    }
    // 위치 업데이트 중지 메서드
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func reverseGeocodeLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("역지오코딩 에러: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                
                
                // 상세 주소 정보를 출력합니다.
                let administrativeArea = placemark.administrativeArea ?? "" // 시, 도
                let locality = placemark.locality ?? "" // 시, 구
                let subLocality = placemark.subLocality ?? "" // 동, 읍, 면
                print("주소: \(administrativeArea), \(locality), \(subLocality)")
                DispatchQueue.main.async {
                    self.address = "\(administrativeArea) \(locality) \(subLocality)"
                    
                }
                // 예: "서울특별시, 강남구, 역삼동"
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    func makeCoordinator() -> LocationViewModel {
        LocationViewModel()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true // 사용자 위치 표시 활성화
        mapView.userTrackingMode = .follow // 사용자 위치 추적 활성화
        mapView.delegate = context.coordinator // MapViewCoordinator를 MKMapView의 델리게이트로 설정
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}
struct LocationCheckView: View {
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
                        .frame(height: 20)
                    
                    ZStack(alignment: .top) { // 텍스트를 지도 위쪽에 배치합니다.
                        MapView()
                        
                        
                        // 텍스트 뷰를 추가합니다.
                        Text(locationViewModel.address)
                            .font(.teFont20SM()) // 폰트 크기 설정
                            .padding(.all, 10.0) // 패딩 추가
                            .background(Color.teBlack.opacity(0.7)) // 텍스트 배경 색상 설정
                            .foregroundColor(.white) // 텍스트 색상 설정
                            .cornerRadius(30) // 텍스트 뷰 모서리 둥글게
                            .padding() // 안쪽 여백 추가
                    }.frame(height: 400)
                    Spacer()
                        .frame(height: 20.0).background(Color.red)
                    
                    Spacer()
                    HStack{
                        Spacer().frame(width: 15)
                        
                        NavigationLink {
                            ResultView(navigationManager : navigationManager)
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


