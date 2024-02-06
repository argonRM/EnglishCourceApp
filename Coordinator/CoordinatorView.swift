//
//  CoordinatorView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 04.02.2024.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .topicsList)
                .navigationDestination(for: Screen.self) { screen in
                    coordinator.build(screen: screen)
                }
                .sheet(item: $coordinator.sheet) { screen in
                    coordinator.build(screen: screen)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { screen in
                    coordinator.build(screen: screen)
                }
        }
        .environmentObject(coordinator)
    }
}

struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView()
    }
}
