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
    var viewName : String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let fontColor = Color.teMidGray
    let backgroundColor = Color.teLightGray
    let fontColorClicked = Color.white
    let backgroundClicked = Color.teBlack
    var body: some View {
        if viewName == "spicySelection" {
            Button(action: action) {
                HStack{
                    Spacer().frame(width: 12)
                    Text(title)
                        .font(Font.teFont16SM())
                    
                    Spacer().frame(width: 12)
                }
                .frame(width: 115.0, height: 43.0)

               
            }
            .foregroundColor(isSelected ? fontColorClicked: fontColor) // 선택 상태에 따른 색상 변경
            .background(isSelected ? backgroundClicked: backgroundColor)
            .cornerRadius(32.0)
        }
        else if viewName == "result" {
            Button(action: action) {
                HStack{
                    Spacer().frame(width: 12)
                    Text(title)
                        .font(Font.teFont16SM())
                    
                    Spacer().frame(width: 12)
                }
                .frame(width: 150, height: 43.0)

               
            }
            .foregroundColor(isSelected ? fontColorClicked: fontColor) // 선택 상태에 따른 색상 변경
            .background(isSelected ? backgroundClicked: backgroundColor)
            .cornerRadius(32.0)
        }else{
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
}

