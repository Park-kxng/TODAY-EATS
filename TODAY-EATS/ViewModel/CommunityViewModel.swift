//
//  CommunityViewModel.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/13/24.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import Foundation
import FirebaseFirestore
import FirebaseStorage

class CommunityViewModel: ObservableObject {
    @Published var feeds = [FeedModel]()

    func fetchFeeds() {
        let db = Firestore.firestore()
        db.collection("community").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            
            self.feeds = documents.compactMap { document -> FeedModel? in
                let data = document.data()
                let rating = data["rating"] as? Int ?? 0
                let waiting = data["waiting"] as? Int ?? 0
                print(data)
                return FeedModel(
                    id: document.documentID,
                    userID : data["userID"] as? String ?? "",
                    userName : data["userName"] as? String ?? "",
                    feedTitle : data["feedTitle"] as? String ?? "",
                    feedMemo : data["feedMemo"] as? String ?? "",
                    time : data["time"] as? String ?? "",
                    resName : data["resName"] as? String ?? "",
                    location : data["location"] as? String ?? "",
                    rating : rating,
                    waiting : waiting,
                    administrativeArea: data["administrativeArea"] as? String ?? "",
                    locality: data["locality"] as? String ?? "",
                    subLocality: data["subLocality"] as? String ?? "",
                    imageURL : data["imageURL"] as? String ?? ""
                    
                )
            }
        }
    }
    
    func addFeed(feed: FeedModel) {
        let db = Firestore.firestore()
        // 새 문서 ID를 생성하거나 특정 ID를 사용하려면 .document("your_custom_id")를 사용합니다.
        let docRef = db.collection("community").document() // 새 문서 ID 자동 생성
        docRef.setData([
            "userID": feed.userID,
            "userName": feed.userName,
            "feedTitle": feed.feedTitle,
            "feedMemo": feed.feedMemo,
            "time": feed.time,
            "resName": feed.resName,
            "location": feed.location,
            "rating": feed.rating,
            "waiting": feed.waiting,
            "administrativeArea" : feed.administrativeArea,
            "locality" : feed.locality,
            "subLocality" : feed.subLocality,
            "imageURL" : feed.imageURL
            
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document successfully added with ID: \(docRef.documentID)")
            }
        }
    }
    
    func fetchUserPosts() {
        // Firestore 인스턴스를 가져옵니다.
        let db = Firestore.firestore()
        print(UserDefaults.standard.string(forKey: "uid"))
        // FirebaseAuth에서 현재 로그인한 사용자의 UID를 가져옵니다.
        guard let userID = Auth.auth().currentUser?.uid else {
            print("사용자가 로그인하지 않았습니다.")
            return
        }
        // 'posts' 컬렉션에서 'UserID' 필드가 현재 로그인한 사용자의 UID와 일치하는 문서만 쿼리합니다.
        db.collection("community").whereField("userID", isEqualTo: userID).getDocuments { (snapshot, error) in
            if let error = error {
                // 쿼리 중 에러가 발생한 경우 처리합니다.
                print("Error getting documents: \(error)")
            } else {
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "")")
                    return
                }

                for document in snapshot!.documents {
                    self.feeds = documents.compactMap { document -> FeedModel? in
                        let data = document.data()
                        let rating = data["rating"] as? Int ?? 0
                        let waiting = data["waiting"] as? Int ?? 0
                        let imageURL = data["imageURL"] as? String ?? ""
                        return FeedModel(
                            id: document.documentID,
                            userID : data["userID"] as? String ?? "",
                            userName : data["userName"] as? String ?? "",
                            feedTitle : data["feedTitle"] as? String ?? "",
                            feedMemo : data["feedMemo"] as? String ?? "",
                            time : data["time"] as? String ?? "",
                            resName : data["resName"] as? String ?? "",
                            location : data["location"] as? String ?? "",
                            rating : rating,
                            waiting : waiting,
                            administrativeArea: data["administrativeArea"] as? String ?? "",
                            locality: data["locality"] as? String ?? "",
                            subLocality: data["subLocality"] as? String ?? "", 
                            imageURL: imageURL
                            
                        )
                    }
                    print("\(document.documentID) => \(document.data())")
                    // 필요한 경우 여기서 각 포스팅을 처리합니다. 예를 들어, UI에 표시할 수 있습니다.
                }
            }
        }
    }
    func fetchPostsArea() {
        // Firestore 인스턴스를 가져옵니다.
        let db = Firestore.firestore()
        
        print(UserDefaults.standard.string(forKey: "subLocality") as Any)
        if let subLocality = UserDefaults.standard.string(forKey: "subLocality"){
            // 'posts' 컬렉션에서 'UserID' 필드가 현재 로그인한 사용자의 UID와 일치하는 문서만 쿼리합니다.
            db.collection("community").whereField("subLocality", isEqualTo: subLocality).getDocuments { (snapshot, error) in
                if let error = error {
                    // 쿼리 중 에러가 발생한 경우 처리합니다.
                    print("Error getting documents: \(error)")
                } else {
                    guard let documents = snapshot?.documents, error == nil else {
                        print("Error fetching documents: \(error?.localizedDescription ?? "")")
                        return
                    }

                    for document in snapshot!.documents {
                        self.feeds = documents.compactMap { document -> FeedModel? in
                            let data = document.data()
                            let rating = data["rating"] as? Int ?? 0
                            let waiting = data["waiting"] as? Int ?? 0
                            let imageURL = data["imageURL"] as? String ?? ""
                            return FeedModel(
                                id: document.documentID,
                                userID : data["userID"] as? String ?? "",
                                userName : data["userName"] as? String ?? "",
                                feedTitle : data["feedTitle"] as? String ?? "",
                                feedMemo : data["feedMemo"] as? String ?? "",
                                time : data["time"] as? String ?? "",
                                resName : data["resName"] as? String ?? "",
                                location : data["location"] as? String ?? "",
                                rating : rating,
                                waiting : waiting,
                                administrativeArea: data["administrativeArea"] as? String ?? "",
                                locality: data["locality"] as? String ?? "",
                                subLocality: data["subLocality"] as? String ?? "",
                                imageURL: imageURL
                                
                            )
                        }
                        print("\(document.documentID) => \(document.data())")
                        // 필요한 경우 여기서 각 포스팅을 처리합니다. 예를 들어, UI에 표시할 수 있습니다.
                    }
                }
            }
        }
        
      
    }
    // 이미지 업로드 (이미지(앱)-> URL(Firebase))
    func uploadImageToStorage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("이미지를 Data로 변환하는 데 실패했습니다.")
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("업로드 실패: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("URL 가져오기 실패: \(error!.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    }

   
    
    func saveImageMetadataToFirestore(imageURL: String, userData: [String: Any]) {
        let db = Firestore.firestore()
        var data = userData
        data["imageURL"] = imageURL  // 이미지 URL을 데이터에 추가

        db.collection("community").addDocument(data: data) { error in
            if let error = error {
                print("Firestore 저장 실패: \(error.localizedDescription)")
            } else {
                print("Firestore 저장 성공")
            }
        }
    }


}

