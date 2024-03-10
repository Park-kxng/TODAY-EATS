//
//  SwiftUIView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/10/24.
//
import SwiftUI

struct MyPageView: View {
    @State var user = User()
    
    let myPageData = [
        MyPageSection(title: "프로필", items: ["프로필"]),
        MyPageSection(title: "투데이츠", items: ["내 포스팅", "저장한 맛집"]),
        MyPageSection(title: "앱 정보 및 문의", items: ["앱 버전", "약관 및 정책", "개인정보 처리 방침", "1:1 문의하기"]),
        MyPageSection(title: "계정", items: ["로그아웃", "탈퇴하기"])
    ]

    var body: some View {
        NavigationView{
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(myPageData, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer().frame(height: 15.0)
                            Text(section.title)
                                .foregroundColor(Color.teMypageGray)
                                .font(.teFont14R())
                                .kerning(-0.2)
                                .background(Color.white) // 섹션 헤더 배경색 변경
                                .cornerRadius(5)

                            ForEach(section.items, id: \.self) { item in
                                NavigationLink(destination: detailView(for: item)) {
                                    // 클릭 가능한 영역을 정의
                                      HStack {
                                          Text(item)
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
                                    
                                   

                                        
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .cornerRadius(5)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        
    }
    @ViewBuilder
        private func detailView(for item: String) -> some View {
            // Example detail view logic, replace with actual destination views
            switch item {
            case "프로필":
                Text("프로필 상세 화면")
            default:
                Text("\(item) 상세 화면")
            }
        }
}

struct MyPageSection {
    let title: String
    let items: [String]
}

struct User {
    var userNameString: String = ""
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
