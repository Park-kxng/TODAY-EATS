//
//  CuisineSelectionView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/10/24.
//

import SwiftUI

struct CuisineSelectionView: View {
    let title : String = "먹고 싶은 음식의 종류는?"
    let subTitle = "복수 선택 가능해요!"

    let buttonTitles : [String] = ["한식", "중식", "일식", "양식", "아시아 음식", "분식", "카페", "기타"]
    @State private var selectedCuisines: Set<String> = []
    @State private var nextButtonClicked: Bool = false

    var body: some View {
        SelectionView(Title: title, subTitle: subTitle, buttonTitles: buttonTitles)
    }
    
}

#Preview {
    CuisineSelectionView()
}
