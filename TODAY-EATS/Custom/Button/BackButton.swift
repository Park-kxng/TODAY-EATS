//
//  BackButton.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/15/24.
//

import Foundation
import SwiftUI


struct BackButton: View {
    let title: String
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수


    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left") // 뒤로가기 아이콘
                Text("이전 단계로") // 사용자가 지정한 제목
            }
            .foregroundColor(Color.teMidGray) // 버튼 텍스트 색상 지정
        }
    }
}

