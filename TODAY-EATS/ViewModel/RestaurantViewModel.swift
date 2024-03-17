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
    func addFavoriteRes(res: RestaurantModel) {
        let db = Firestore.firestore()
        // 새 문서 ID를 생성하거나 특정 ID를 사용하려면 .document("your_custom_id")를 사용합니다.
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            let docRef = db.collection("restaurant").document() // 새 문서 ID 자동 생성
            docRef.setData([
                "uid" : uid,
                "title" : res.title,
                "category" : res.category,
                "roadAddress" : res.roadAddress,
                "mapx" : res.mapx,
                "mapy" : res.mapy
                
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document successfully added with ID: \(docRef.documentID)")
                }
            }
            
        }
       
    }
    

    func deleteFavoriteRes (res:RestaurantModel) {
        let db = Firestore.firestore()
        // 조건에 맞는 문서 검색
        db.collection("restaurant")
            .whereField("uid", isEqualTo:UserDefaults.standard.string(forKey: "uid") ?? "" )
            .whereField("title", isEqualTo: res.title)
            .whereField("mapx", isEqualTo: res.mapx)
            .whereField("mapy", isEqualTo: res.mapy)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        // 조건에 맞는 문서 삭제
                        db.collection("restaurant").document(document.documentID).delete { error in
                            if let error = error {
                                print("Error removing document: \(error.localizedDescription)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                }
            }
    }
    
    func fetchFavoriteRes() {
        let db = Firestore.firestore()
        db.collection("restaurant").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            
            self.restaurants = documents.compactMap { document -> RestaurantModel? in
                let data = document.data()

                print(data)
                return RestaurantModel(
                    id: data["uid"] as? String ?? "nil",
                    title: data["title"] as? String ?? "nil",
                    category: data["category"] as? String ?? "nil",
                    telephone: "",
                    roadAddress: data["roadAddress"] as? String ?? "nil",
                    mapx: data["mapx"] as? Double ?? 0,
                    mapy: data["mapy"] as? Double ?? 0
                )
                    
            }
        }
    }
    func fetchGoodRestaurant(selection : SelectionModel, completion: @escaping () -> Void) {
        let place = selection.place
        let menu = selection.selectedMenu
        guard let subLocality = UserDefaults.standard.string(forKey: "subLocality") else {
               print("Required information is missing")
               return
           }
           
           let query = "\(subLocality)\(menu)맛집"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
           let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(encodedQuery)&display=5&start=1&sort=comment"
        
        let NAVER_ID = Bundle.main.infoDictionary?["NAVER_ID"] as? String  ?? ""
        let NAVER_SECRET = Bundle.main.infoDictionary?["NAVER_SECRET"] as? String  ?? ""

        
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
                       let roadAddress = item["roadAddress"] as? String
  
                    {
                        let mapx = self.convertStringToCoordinate(item["mapx"] as? String ?? "", num: 3 )
                        let mapy = self.convertStringToCoordinate(item["mapy"] as? String ?? "", num: 2)
                        print(mapx, mapy)
                        let newRes = RestaurantModel(
                            id: self.stripHTML(from: title),
                            title: self.stripHTML(from: title),
                            category: category,
                            telephone: telephone,
                            roadAddress: roadAddress,
                            mapx: mapx,
                            mapy: mapy)
                        
                        restaurantList.append(newRes)

                    }
                }
                
                print(restaurantList)
                
                DispatchQueue.main.async {
                    self.restaurants = restaurantList
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }.resume()
    }
    func stripHTML(from input: String) -> String {
        guard let data = input.data(using: .utf8) else {
            return input
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return input
        }
    }

    func convertStringToCoordinate(_ coordStr: String, num : Int) -> Double {
        guard coordStr.count > num else {
            return Double(coordStr) ?? 0.0
        }
        
        let integerPart = Double(coordStr.prefix(num)) ?? 0.0
        let decimalPartString = String(coordStr.dropFirst(num))
        let decimalPart = Double("0.\(decimalPartString)") ?? 0.0
        
        return integerPart + decimalPart
    }
}

