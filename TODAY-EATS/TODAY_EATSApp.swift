//
//  TODAY_EATSApp.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/8/24.
//

import SwiftUI
import SwiftData
import Firebase

struct YOUR_APPApp: App {
    @StateObject var onBoardingManager = OnboardingManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if onBoardingManager.isOnboardingCompleted {
                ContentView()
            } else {
                OnBoarding1View(onBoardingManager:onBoardingManager)
            }
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
