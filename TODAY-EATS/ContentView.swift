import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack {
            // 탭의 컨텐츠 배치
            ZStack {
                if selectedTab == 0 {
                    Text("커뮤니티")
                        .font(.largeTitle)
                } else if selectedTab == 1 {
                    Text("뭐 먹지?")
                        .font(.largeTitle)
                }
                else if selectedTab == 2 {
                    Text("마이페이지")
                        .font(.largeTitle)
                }
                // 필요한 경우 더 많은 탭 추가 가능
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            // 커스텀 탭 바
            HStack {
                Spacer()
                // 버튼1 : 커뮤니티
                Button(action: {
                    self.selectedTab = 0
                }) {
                    VStack {
                        Image("tap_community")
                            .renderingMode(.template).background()
                        Text("커뮤니티")
                            .font(.system(size: 12))
                            .frame(width: 52.0, height: 16.0)
                            .background()
                    }
                    .frame(width: 53.0, height: 53.0)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                }
                .padding(4.0)
                .frame(height: 10.0)
                .foregroundColor(selectedTab == 0 ? .teBlack : .gray)

                
                

                Spacer()
                
                // 버튼2 : 뭐 먹지?
                Button(action: {
                    self.selectedTab = 1
                }) {
                    VStack {
                        Image("tap_spoonAndFork")
                            .renderingMode(.template)
                            .frame(width: 53.0)
                        Text("뭐 먹지?")
                            .font(.system(size: 12))
                            .frame(width: 52.0, height: 16.0)
                            .background()
                    }
                }
                .padding(4.0)
                .frame(width: 53.0, height: 53.0)
                .foregroundColor(selectedTab == 1 ? .teBlack : .gray)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                // 버튼3 : 마이페이지
                Button(action: {
                    self.selectedTab = 2
                }) {
                    VStack {
                        Image("tap_mypage")
                            .renderingMode(.template)
                        Text("마이페이지")
                            .font(.system(size: 12))
                            .frame(width: 52.0, height: 16.0)
                            .background()

                         
                            
                    }
                    .frame(width: 52.0)
                }
                .padding(4.0)
                .foregroundColor(selectedTab == 2 ? .teBlack : .gray)
                
                Spacer()
            }
            .padding()
            .frame(height: 59.0)
            .background(Color.white.shadow(radius: 10, x: 0, y: -5)
                .opacity(0.1)) // 커스텀 탭 바에 그림자 적용
            .frame(maxWidth: .infinity)
        }
        Spacer()

        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

