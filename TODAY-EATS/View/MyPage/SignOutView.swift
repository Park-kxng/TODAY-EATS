//
//  SignOutView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/15/24.
//

import SwiftUI



struct SignOutView: View {
    @State private var showingDeleteAlert = false
    var action: () -> Void
    var body: some View {
        VStack {
            Button(action: {
                showingDeleteAlert = true
            }, label: {
                HStack {
                Text("탈퇴하기")
                    .foregroundColor(Color.teBlack)
                    .padding()
                    .font(.teFont16M())
                    .kerning(-0.2)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.teMypageGray)
                Spacer()
                    .frame(width: 10.0)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white) // 배경색 설정
                .cornerRadius(5)
            })
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("탈퇴를 정말 하시겠습니까?"),
                    message: Text("이 작업은 되돌릴 수 없습니다."),
                    primaryButton: .destructive(Text("예")) {
                       action()
                    },
                    secondaryButton: .cancel()
                )
            }


        }
    }
}
