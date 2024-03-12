//
//  TODAY_EATSApp.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/8/24.
//

import SwiftUI
import SwiftData

@main
struct YOUR_APPApp: App {
    @StateObject var onBoardingManager = OnboardingManager()

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
