//
//  SmallButton.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/10/24.
//

import Foundation
import Foundation
import SwiftUI

import SwiftUI


struct SmallButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let fontColor = Color.teMidGray
    let backgroundColor = Color.teLightGray
    let fontColorClicked = Color.white
    let backgroundClicked = Color.teBlack
    var body: some View {
        
        Button(action: action) {
            HStack{
                Spacer().frame(width: 12)
                Text(title)
                    .font(Font.teFont16SM())
                
                Spacer().frame(width: 12)
            }
            .frame(height: 43.0)

           
        }
        .foregroundColor(isSelected ? fontColorClicked: fontColor) // 선택 상태에 따른 색상 변경
        .background(isSelected ? backgroundClicked: backgroundColor)
        .cornerRadius(32.0)

    }
}
#Preview {
    CuisineSelectionView()
    
}
