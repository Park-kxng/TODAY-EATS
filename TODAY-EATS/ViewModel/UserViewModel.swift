//
//  UserViewModel.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import Foundation
import FirebaseFirestore

class UserViewModel : ObservableObject {
    @Published var user = UserModel(userName: "")
    init(){
        fetchUserName()
    }
    func fetchUserName() {
        let db = Firestore.firestore()
        let uid = "p9l7Lv2RBFfDn2ZpimwspEwXcRy1"
        // 특정 문서(UID)의 데이터 가져오기
        db.collection("user").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let userName = data?["userName"] as? String ?? ""
                self.user.userName = userName
                print("현재 userName: \(userName)")
                UserDefaults.standard.set(userName, forKey: "userName")

            }
        }

    }
    
    func patchUser(user : UserModel) {
        let db = Firestore.firestore()
        let uid = "p9l7Lv2RBFfDn2ZpimwspEwXcRy1"
        // 특정 문서(UID)의 데이터 가져오기
        db.collection("user").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let userName = data?["userName"] as? String ?? ""
                print("현재 userName: \(userName)")
                
            }
            // 필요한 경우 userName 수정하기
            let newUserName = user.userName // 새로운 userName 값
             let updateData = ["userName": newUserName] // 수정할 데이터
             
             // 문서 수정
             db.collection("user").document(uid).updateData(updateData) { err in
                 if let err = err {
                     print("Error updating document: \(err)")
                 } else {
                     UserDefaults.standard.set(newUserName, forKey: "userName") // 앱에 저장
                     print("Document successfully updated")
                 }
             }
        }
    }

}

