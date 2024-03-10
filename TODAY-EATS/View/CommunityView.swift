//
//  CommunityView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI

// 피드 아이템을 나타내는 데이터 모델
struct FeedItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let rating: String
    let waiting: String
}

// 더미 데이터
let feedItems = [
    FeedItem(title: "맛도리만 찾아다님", description: "오늘도 맛집 탐방!", imageName: "img_charc", rating: "★★★☆☆", waiting: "10분"),
    FeedItem(title: "미식생 해고싶다", description: "마라탕은 역시 탕화라", imageName: "img_charc", rating: "★★★★☆", waiting: "15분"),
    FeedItem(title: "맛집 마스터", description: "겨울에 팥빙수를 먹어보았다", imageName: "img_charc", rating: "★★★☆☆", waiting: "20분"),
    // ... 여기에 더 많은 피드 아이템이 있을 수 있습니다.
]

struct CommunityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItem: FeedItem?

    init() {
        configureNavigationBarAppearance()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(feedItems) { item in
                        Button(action: {
                            self.selectedItem = item
                        }) {
                            FeedItemRow(item: item)
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes the button's default styling
                    }
                }
            }
            .background(Color.white) // Set ScrollView's background color
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Text("현재 위치")
                            .font(.teFont18B())
                            .foregroundColor(Color.teBlack)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.teBlack)
                    }
                }
            }
            .sheet(item: $selectedItem) { item in
                DetailView(feedItem: item)
            }
        }
    }

    private func configureNavigationBarAppearance() {
        // Your existing configuration code
    }
}

#Preview {
    CommunityView()
}
struct FeedItemRow: View {
    let item: FeedItem

    var body: some View {
        ScrollView {
            VStack{
                Spacer().frame(height: 15)
              HStack{
                  Spacer().frame(width: 20)
                  Image("tap_mypage")
                      .renderingMode(.template)
                      .resizable()
                      .foregroundColor(Color.black)
                      .scaledToFit()
                      .frame(width: 38.0, height: 38.0)
                      .background(Color.teMidGray)
                      .clipShape(Circle())

                  Spacer()
                      .frame(width: 10)
                  VStack(alignment: .leading){
                      Text(item.title)
                          .font(.headline)

                      Text("위치")
                          .multilineTextAlignment(.leading)
                          .font(.subheadline)
                          .foregroundColor(.secondary)
                  }
                  
                  Spacer()
              }.background()
                
                Spacer().frame(height:15)
              HStack(alignment: .top) {
                  Spacer().frame(width: 20)

                  Image(item.imageName)
                      .resizable()
                      .scaledToFit()
                      .frame(width: 80, height: 80)
                      .cornerRadius(10)
                  
                  VStack(alignment: .leading, spacing: 5) {
                      Text(item.description)
                          .font(.headline)

                      HStack {
                          Text(item.rating)
                              .foregroundColor(.yellow)
                          Spacer()
                          Text(item.waiting)
                              .foregroundColor(.secondary)
                              .font(.caption)
                      }
                  }
                  Spacer().frame(width: 20)
              }.background()
                Spacer().frame(height: 15)
                HStack{
                    Spacer().frame(width: 20)
                    Rectangle()
                        .fill(Color.teLightGray)
                        .frame(height: 1)
                        .cornerRadius(20)
                    Spacer().frame(width: 20)

                }
             

          
              }
          }
                  
                      
    }
}

struct DetailView: View {
    let feedItem: FeedItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(feedItem.imageName)
                    .resizable()
                    .scaledToFit()

                Text(feedItem.title)
                    .font(.title)
                    .padding()

                Text(feedItem.description)
                    .padding()
                Text(feedItem.rating)
                    .padding()
                Text(feedItem.description)
                    .padding()
                // 여기에 더 많은 세부 정보를 추가할 수 있습니다.
            }
        }
        .navigationTitle(feedItem.title)
    }
}
