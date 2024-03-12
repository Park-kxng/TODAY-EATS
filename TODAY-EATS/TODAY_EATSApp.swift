//import SwiftUI
//import Firebase
//
//// AppDelegate class that conforms to UIApplicationDelegate protocol
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // Configure Firebase here
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//@main
//struct TODAY_EATSApp: App {
//    // Use UIApplicationDelegateAdaptor to integrate AppDelegate
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var onBoardingManager = OnboardingManager()
//    
//  
//    
//    // Initialize AuthService and use it as an environment object
//    var authService = AuthService()
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//            if onBoardingManager.isOnboardingCompleted {
//                ContentView()
//            } else {
//                LoginView().environmentObject(authService)
//            }
//        }
//    }
//}
import SwiftUI
import Firebase

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}
import SwiftUI
import Firebase

@main
struct TODAY_EATSApp: App {
    @StateObject var authService : AuthService
    // 1. Add StateObject authManager.

    init() {
        FirebaseApp.configure()
        let authService = AuthService()
        _authService = StateObject(wrappedValue: authService)

    }
    
    var body: some Scene {
        WindowGroup {
//            HomeView()
//            if onBoardingManager.isOnboardingCompleted {
//                HomeView()
//                ContentView().environmentObject(onBoardingManager) // 환경 객체로 추가
//                    .environmentObject(onBoardingManager)
//                    .environmentObject(authService)
//            } else {
            if authService.authState != .signedOut {
                HomeView()
            }else{
                LoginView()
//                    .environmentObject(onBoardingManager)
                    .environmentObject(authService)
            }
               

//            }
        }
    }
}
