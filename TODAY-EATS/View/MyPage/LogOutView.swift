//
//  LogOutView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/15/24.
//

import SwiftUI

struct LogOutView: View {
    @State private var showingLogoutAlert = false
    var action: () -> Void
    var body: some View {
        VStack {
            Button(action: {
                showingLogoutAlert = true
            }, label: {
                HStack {
                Text("로그아웃")
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
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("로그아웃을 정말 하시겠습니까?"),
                    primaryButton: .destructive(Text("예")) {
                       action()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}


