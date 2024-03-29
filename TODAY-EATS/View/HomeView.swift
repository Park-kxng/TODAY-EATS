//
//  HomeView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int = 0
    @State private var navigationValue: NavigationDestination?
    @Environment(\.colorScheme) var colorScheme
    @StateObject var onBoardingManager = OnboardingManager()


   
    var body: some View {
        NavigationStack {
            VStack {
                // 탭의 컨텐츠 배치
                ZStack {
                    if selectedTab == 0 {
                        CommunityView()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarTitleDisplayMode(.inline)


                    } else if selectedTab == 1 {
                        TodayEatsView()
                    } else if selectedTab == 2 {
                        MyPageView().environmentObject(AuthService())
                            .navigationBarBackButtonHidden(true)

                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer().frame(height: 0)
                
                // 커스텀 탭 바
                HStack {
                    Spacer()
                        .frame(width: 20.0)
                    
                    // 버튼1 : 커뮤니티
                    Button(action: {
                        self.selectedTab = 0
                    }) {
                        VStack {
                            Image("tap_community")
                                .resizable() // 이미지가 리사이즈 가능하도록 설정
                                .renderingMode(.template)
                                .frame(width: 27, height: 27)
                                .aspectRatio(contentMode: .fit)
                            
                            
                            Text("커뮤니티")
                                .font(.teFont12M())
                                .multilineTextAlignment(.center)
                                .frame(width: 42.0, height: 14.0)
                                .kerning(-0.2)
                            
                        }
                    }
                    .padding(4.0)
                    .frame(width: 52, height: 45)
                    .foregroundColor(selectedTab == 0 ? .black : .gray)
                    .cornerRadius(5) // 모서리 둥글게 처리
                    .padding(.bottom, 10) // 탭 바 위에서 띄우기
                    
                    Spacer()
                    
                    // 버튼2 : 뭐 먹지?
                    Button(action: {
                        self.selectedTab = 1
                    }) {
                        VStack {
                            Image("tap_spoonAndFork")
                                .resizable() // 이미지가 리사이즈 가능하도록 설정
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 27)
                            
                            Text("뭐 먹지?")
                                .font(.teFont12M())
                                .frame(width: 42.0, height: 14.0)
                                .kerning(-0.2)
                        }
                    }
                    .padding(4.0)
                    .frame(width: 52, height: 45)
                    .foregroundColor(selectedTab == 1 ? .black : .gray)
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
                    // 버튼3 : 마이페이지
                    Button(action: {
                        self.selectedTab = 2
                    }) {
                        VStack {
                            Image("tap_mypage")
                                .renderingMode(.template)
                                .frame(width: 27, height: 27)
                            
                            Text("마이페이지")
                                .font(.teFont12M())
                                .frame(width: 52, height: 14.0)
                                .kerning(-0.2)
                            
                        }
                    }
                    .padding(4.0)
                    .frame(width: 52, height: 45)
                    .foregroundColor(selectedTab == 2 ? .black : .gray)
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                    
                    Spacer()
                        .frame(width: 20.0)
                }
                .padding()
                .frame(height: 90.0) // 전체 탭 바의 높이 조정
                .background(Color.white) // 커스텀 탭 바의 배경색
                .shadow(color: Color.black.opacity(0.03), radius: 5, y: -7)
                .frame(maxWidth: .infinity)
                
            }
            .edgesIgnoringSafeArea(.bottom) // 하단의 안전 영역 무시
        }
        .navigationBarBackButtonHidden(true)
        
        
    }
}

#Preview {
    HomeView()
}
