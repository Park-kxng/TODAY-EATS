//
//  RestaurantButton.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/17/24.
//

import Foundation
import SwiftUI

struct RestaurantButton : View {
    var item : RestaurantModel
    // 초기화
    var title: String = "맘스터리 중화점"
    var category : String = "햄버거"
    var address : String = "서울특별시 중랑구 망우로 211 1층"
   

    @State var buttonIsSelected = false
    let isSelected: Bool
    let fontColor = Color.teMidGray
    let backgroundColor = Color.teLightGray
    let fontColorClicked = Color.white
    let backgroundClicked = Color.teBlack
    
    var body: some View {
        
 
                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text(item.title)
                                .foregroundStyle(isSelected ? fontColorClicked: fontColor)
                                .foregroundStyle(Color.teBlack)
                                .kerning(-0.2)
                            Spacer()
                            Button {
                                self.buttonIsSelected.toggle()
                                // 저장된 맛집에 추가하는 데이터 로직 추가
                                
                            } label: {
                                Image(buttonIsSelected ? "heart_fill" : "heart")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }

                            
                        }
                        .frame(height: 20)


                        Text(item.category)
                            .foregroundStyle(isSelected ? Color.teBlack : Color.teMidGray)
                            .font(.teFont12M())
                            .padding(.horizontal, 10.0)
                            .frame(height: 25)
                            .background(Color.teLightGray)
                            .cornerRadius(32)
                            .kerning(-0.2)

                        Text(item.roadAddress)
                            .font(Font.teFont12M())
                            .kerning(-0.2)
                            .padding(.top, 5.0)
                            .frame(height: 15)

                        
                    }
                    .padding(15)
                    
                   
                    
                
                

            }
            .foregroundStyle(isSelected ? fontColorClicked: fontColor) // 선택 상태에 따른 색상 변경
            .background(isSelected ? backgroundClicked: Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 18) // 모서리의 둥근 정도를 지정
                    .stroke(isSelected ? Color.clear: fontColor, lineWidth: 1) // 테두리 색상과 두께 지정
            )
            .cornerRadius(18)
        }
        

    
}
