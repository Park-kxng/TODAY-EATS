//
//  NextButton.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/10/24.
//



import Foundation
import SwiftUI

struct NextButton: View {
    let isSelected: Bool
    let action: () -> Void
    let fontColor = Color.teMidGray
    let fontColorClicked = Color.white
    let backgroundColor = Color.teLightGray
    let backgroundClicked = Color.teBlack
    
    var body: some View {

            HStack{
                Spacer().frame(width: 15)
                Button(action: action) {
                    HStack {
                        Spacer()
                        Text("다음 단계로")
                            .font(.teFont18M())
                            .foregroundColor(isSelected ? fontColorClicked : fontColor)
                        Spacer()
                    }
                    .frame(height: 56.0)
                    .background(isSelected ? backgroundClicked : backgroundColor)
                    .cornerRadius(12)
                }
                Spacer().frame(width: 15)

            }
           
        }
    }

