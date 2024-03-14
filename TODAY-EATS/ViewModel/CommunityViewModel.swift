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
                    subLocality: data["subLocality"] as? String ?? ""
                    
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
            "subLocality" : feed.subLocality
            
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document successfully added with ID: \(docRef.documentID)")
            }
        }
    }

}

