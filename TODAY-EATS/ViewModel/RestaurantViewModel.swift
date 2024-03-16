//
//  RestuarantViewModel.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/17/24.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import Foundation
import FirebaseFirestore
import FirebaseStorage

class RestaurantViewModel: ObservableObject {
    @Published var restaurants : [RestaurantModel] = []

    func fetchGoodRestaurant(selection : SelectionModel) {
        let NAVER_ID = Bundle.main.infoDictionary?["NAVER_ID"] as? String  ?? ""
        let NAVER_SECRET = Bundle.main.infoDictionary?["NAVER_SECRET"] as? String  ?? ""

        let urlString = "https://openapi.naver.com/v1/search/local.json?query=중화동 햄버거집&display=5&start=1&sort=comment"
        
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue(NAVER_ID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(NAVER_SECRET, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    print("데이터 불러오기 실패")
                }
                return
            }

            // 디버깅을 위해 응답 JSON 출력
            print(String(data: data, encoding: .utf8) ?? "Invalid JSON response")
            var restaurantList : [RestaurantModel] = []
            // JSON 데이터 파싱
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let items = json["items"] as? [[String: Any]]
            {
                for item in items {
                    if let title = item["title"] as? String,
                       let link = item["link"] as? String,
                       let category = item["category"] as? String,
                       let description = item["description"] as? String,
                       let telephone = item["telephone"] as? String,
                       let roadAddress = item["roadAddress"] as? String,
                       let mapx = Int(item["mapx"] as? String ?? ""),
                       let mapy = Int(item["mapy"] as? String ?? "")
                    {
                        let newRes = RestaurantModel(
                            id: title, 
                            title: title,
                            category: category,
                            telephone: telephone,
                            roadAddress: roadAddress,
                            mapx: mapx,
                            mapy: mapy)
                        
                        restaurantList.append(newRes)
                        self.restaurants = restaurantList

                    }
                }
                
                print(restaurantList)
                
                DispatchQueue.main.async {
                   
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }.resume()
    }
}

