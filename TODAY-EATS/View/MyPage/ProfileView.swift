//
//  ProfileView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import SwiftUI



import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isImagePickerDisplayed = false
    @State private var imagePicked = false

    @State private var selectedImage: UIImage?
    // UserDefaults에서 userName을 직접 읽는 대신 ViewModel을 사용
    @State private var userName: String = ""
    @State private var userImgURL : String = ""

    init() {
        // ViewModel의 userName을 State 변수와 동기화
        _userName = State(initialValue: UserViewModel().user.userName)
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            Button(action: {
                self.isImagePickerDisplayed.toggle()
                self.imagePicked = true
            }) {
                if imagePicked {
                    if let selectedImage = selectedImage {
                           Image(uiImage: selectedImage)
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .frame(width: 100.0, height: 100.0)
                               .clipShape(Circle())
                           
                           
                       }
                }else{
                    if viewModel.user.userImgURL == "" {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100.0, height: 100.0)
                            .foregroundColor(Color.teMidGray)
                            .clipShape(Circle())

                        } else {
                            AsyncImage(url: URL(string: viewModel.user.userImgURL)) { image in
                                    image.resizable()
                                    .scaledToFill()

                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())

                        }
                    
                }
                   
                
            }
            .padding()
            .sheet(isPresented: $isImagePickerDisplayed) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerDisplayed)
            }
            
            Spacer().frame(height: 20)
            HStack{
                Spacer().frame(width: 20)
                Text("닉네임")
                    .font(.teFont16M()) // Custom font
                    .foregroundColor(Color.teMidGray) // Text color
                    .frame(maxWidth: .infinity, alignment: .leading) // Max width with alignment
                Spacer().frame(width: 20)
            }
           
            HStack{
                Spacer().frame(width: 20)
                TextField("닉네임을 입력해주세요", text: $viewModel.user.userName)
                    .frame(height: 30) // 텍스트필드의 높이를 설정합니다.
                    .padding(.all, 8.0)
                    .background(Color.teLightGray)
                    .cornerRadius(8)
                    .font(.teFont16R())
                    .kerning(-0.2)
                    .padding(.top, 10)
                Spacer().frame(width: 20)

            }
            .frame(height: 30) // 텍스트필드의 높이를 설정합니다.
          
            
            Spacer()

      
        }
        .onAppear {
            // View가 나타날 때 UserDefaults에서 최신 userName을 가져옴
            self.userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        }
        // 완료 버튼
         HStack{
             Spacer().frame(width: 15.0)
             Button(action: {
                 if let selectedImage = selectedImage{
                     viewModel.uploadImageToStorage(image: selectedImage) { url in
                         guard let imageURL = url else {
                             print("에러 : 이미지 URL을 받아오는데에 실패했습니다.")
                             return
                         }
                         print(imageURL)
                         let newUser = UserModel(userName: viewModel.user.userName, userImgURL: imageURL)
                         viewModel.patchUser(user: newUser)
                     }
                 }
                
                 self.presentationMode.wrappedValue.dismiss()
         
             }) {
                 Spacer()
                 Text("완료").font(.teFont18M())
                     .foregroundColor( .white)
                     .frame(height: 56.0)
                     .kerning(-0.2)
                 
                 Spacer()
             }
             .background(Color.teBlack)
             .cornerRadius(12)
             Spacer()
                 .frame(width: 15.0)
             
         }.padding(.bottom, 10.0)
    }
}
