//
//  ContentView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/8/24.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    var body: some View {
        TabView {
            Text("첫 번째 탭")
            .font(.mpFont26B())
            .foregroundColor(.mpMainColor) // mpMainColor 색상 사용
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("첫 번째")


                }
            
            Text("두 번째 탭")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("두 번째")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
