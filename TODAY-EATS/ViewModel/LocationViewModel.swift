//
//  LocationViewModel.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/12/24.
//

import Foundation
import CoreLocation
import MapKit

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
        stopUpdatingLocation()
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
                UserDefaults.standard.set(administrativeArea, forKey: "administrativeArea")
                
                let locality = placemark.locality ?? "" // 시, 구
                UserDefaults.standard.set(locality, forKey: "locality")

                let subLocality = placemark.subLocality ?? "" // 동, 읍, 면
                UserDefaults.standard.set(subLocality, forKey: "subLocality")

                print("주소: \(administrativeArea), \(locality), \(subLocality)")
                DispatchQueue.main.async {
                    self.address = "\(administrativeArea) \(locality) \(subLocality)"
                    
                }
                // 예: "서울특별시, 강남구, 역삼동"
            }
        }
    }
}
