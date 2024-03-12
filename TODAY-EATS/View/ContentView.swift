import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var navigationValue: NavigationDestination?
    @Environment(\.colorScheme) var colorScheme
    @StateObject var onBoardingManager = OnboardingManager()
    var authService = AuthService()
   
    var body: some View {
        if onBoardingManager.isOnboardingCompleted {
                        ContentView()
                    } else {
                        LoginView().environmentObject(authService)
                    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

