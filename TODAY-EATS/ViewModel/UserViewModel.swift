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
import FirebaseStorage

class UserViewModel : ObservableObject {
    @Published var user = UserModel(userName: "", userImgURL: "")
    init(){
        fetchUserName()
    }
    func fetchUserName() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("사용자가 로그인하지 않았습니다.")
            return
        }
        // 특정 문서(UID)의 데이터 가져오기
        db.collection("user").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let userName = data?["userName"] as? String ?? ""
                let userImgURL = data?["userImgURL"] as? String ?? ""

                self.user.userName = userName
                self.user.userImgURL = userImgURL
                
                print("현재 userName: \(userName)")
                print("현재 userImgURL: \(userImgURL)")

                UserDefaults.standard.set(userName, forKey: "userName")
                UserDefaults.standard.set(userImgURL, forKey: "userImgURL")

            }
        }

    }
    
    func fetchOtherUser(uid: String, completion: @escaping ([String]?) -> Void) {
        let db = Firestore.firestore()
        
        // 특정 문서(UID)의 데이터 가져오기
        db.collection("user").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let userName = data?["userName"] as? String ?? ""
                let userImgURL = data?["userImgURL"] as? String ?? ""
                
                // Call the completion handler with the fetched data
                completion([userName, userImgURL])
            } else {
                // Call the completion handler with nil if there's an error or document doesn't exist
                completion(nil)
            }
        }
    }

    
    func patchUser(user : UserModel) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("사용자가 로그인하지 않았습니다.")
            return
        }

        // 필요한 경우 userName 수정하기
        let newUserName = user.userName // 새로운 userName 값
        let newUserImgURL = user.userImgURL // 새로운 userName 값
        let updateData = ["userName": newUserName, "userImgURL": newUserImgURL] // 수정할 데이터
             
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


}

