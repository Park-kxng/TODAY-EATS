//
//  FireStoreManager.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/13/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class FireStoreManager: ObservableObject {
    @Published var freeboardTitle: String = ""
    @Published var freeboardNickName: String = ""

    init() {
        fetchData()

    }
    
    func fetchData() {
            let db = Firestore.firestore()
            let docRef = db.collection("community").document("keCNyEDEAvImovjBedU7")
            docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        self.freeboardTitle = data["feedTitle"] as? String ?? ""
                        self.freeboardNickName = data["userName"] as? String ?? ""
                        print(data["feedTitle"] as? String ?? "")
                        print(data["userName"] as? String ?? "")

                    }
                }
            }
        }
}
