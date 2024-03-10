//
//  NavigationManager.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()

    func popToRootView() {
        path.removeLast(path.count)
    }
}
