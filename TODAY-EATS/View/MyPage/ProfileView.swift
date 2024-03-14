//
//  ProfileView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/14/24.
//

import SwiftUI


#Preview {
    ProfileView()
}
struct ProfileView: View {
    // 이전 화면으로 돌아가기 위한 presentationMode 환경 변수
    @ObservedObject var viewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    // 초기화
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    

    
  
    var body: some View {
            VStack{
                VStack{
                    Text("닉네임")
                        .font(.teFont16M())
                        .foregroundColor(Color.teMidGray)
                    HStack{
                        Spacer().frame(width: 15)
                        TextField("닉네임 입력", text: $viewModel.user.userName)
                            .frame(height: 30) // 텍스트필드의 높이를 설정합니다.
                            .padding(.all, 8.0)
                            .background(Color.teLightGray)
                            .cornerRadius(8)
                            .font(.teFont16R())
                            .kerning(-0.2)
                            
                        Spacer().frame(width: 15)

                    }
                    
                    Spacer()
                    
                }

                HStack{
                    Spacer().frame(width: 15.0)
                    Button(action: {
                        let newUser = UserModel(userName: viewModel.user.userName)
                        viewModel.patchUser(user: newUser)
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
                // 완료 버튼
            }
            .frame(height: .infinity)
            
           
            

        }
        
    
}
