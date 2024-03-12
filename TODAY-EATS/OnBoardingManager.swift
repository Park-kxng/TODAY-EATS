//
//  OnboardingManager.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/12/24.
//

import Foundation
class OnboardingManager: ObservableObject {
    // 온보딩 완료 여부
        @Published var isOnboardingCompleted = false
        // 현재 온보딩 단계 (예: 1에서 4까지)
        @Published var currentStep = 1

        // 온보딩 상태 초기화 함수
        func resetOnboarding() {
            isOnboardingCompleted = false
            currentStep = 1
        }

        // 온보딩 완료 처리 함수
        func completeOnboarding() {
            isOnboardingCompleted = true
        }

        // 다음 온보딩 단계로 이동
        func goToNextStep() {
            currentStep += 1
        }
}
