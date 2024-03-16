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
        let latitude = latestLocation.coordinate.latitude
        let longitude = latestLocation.coordinate.longitude

        
        UserDefaults.standard.setValue(latitude, forKey: "latitude")
        UserDefaults.standard.setValue(longitude, forKey: "longitude")

        reverseGeocodeLocationNaver(location: latestLocation)
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
        reverseGeocodeLocationNaver(location: location)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("역지오코딩 에러: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                
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
    func reverseGeocodeLocationNaver(location: CLLocation) {
        let RGid = Bundle.main.infoDictionary?["RGid"] as! String
        let RGsecret = Bundle.main.infoDictionary?["RGsecret"] as! String

        let clientId = RGid
        let clientSecret = RGsecret
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let coords = "\(longitude),\(latitude)"
        let urlString = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(coords)&sourcecrs=epsg:4326&output=json&orders=addr"
        
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.address = "주소 검색 실패: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.address = "주소 정보를 받아올 수 없습니다."
                }
                return
            }

            // 디버깅을 위해 응답 JSON 출력
            print(String(data: data, encoding: .utf8) ?? "Invalid JSON response")

            // JSON 데이터 파싱
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let region = results.first?["region"] as? [String: Any],
               let area1 = region["area1"] as? [String: Any],
               let area2 = region["area2"] as? [String: Any],
               let area3 = region["area3"] as? [String: Any] {
                
                let administrativeArea = area1["name"] as? String ?? "N/A"
                let locality = area2["name"] as? String ?? "N/A"
                let subLocality = area3["name"] as? String ?? "N/A"
                
                DispatchQueue.main.async {
                    self.address = "\(administrativeArea) \(locality) \(subLocality)"
                    UserDefaults.standard.set(administrativeArea, forKey: "administrativeArea")
                    UserDefaults.standard.set(locality, forKey: "locality")
                    UserDefaults.standard.set(subLocality, forKey: "subLocality")
                    
                    print("주소: \(self.address)")
                }
            } else {
                DispatchQueue.main.async {
                    self.address = "주소 정보를 파싱할 수 없습니다."
                }
            }
        }.resume()
    }
        
    
}
