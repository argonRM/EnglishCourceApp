//
//  ToBeExerciseBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

final class ExerciseBuilder: ScreenBuilder {
    let topic: Topic
    
    init(topic: Topic) {
        self.topic = topic
    }
    
    public func build() -> AnyView {
        return initView()
    }

    private func initView() -> AnyView {
        let networkManager: NetworkManager = NetworkManager()
        let viewContext = PersistenceController.shared.container.viewContext
        let toBeExerciseService = ExerciseService(networkManager: networkManager, context: viewContext)
        let viewModel = ExerciseViewModel(topic: topic, exerciseService: toBeExerciseService)
        let view = ExerciseView(viewModel: viewModel)
        
        return AnyView(view)
    }
}
