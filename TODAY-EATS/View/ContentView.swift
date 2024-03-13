import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService : AuthService
    
    @State private var selectedTab: Int = 0
    @State private var navigationValue: NavigationDestination?
    @Environment(\.colorScheme) var colorScheme
    @StateObject var onBoardingManager = OnboardingManager()
    // 화면 전환을 위한 상태 관리
    @State private var isActive = false
    var body: some View {
        if isActive {
            if authService.authState != .signedOut {
                HomeView()
            }else{
                LoginView()
                    .environmentObject(authService)
            }
        } else {
            // 스플래쉬 화면 디자인
            VStack {
                SplashView()
            }
            .onAppear {
                // 3초 후 화면 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

