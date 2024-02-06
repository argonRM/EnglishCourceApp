//
//  ToBeExerciseBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

class ExerciseBuilder: ScreenBuilder {
    public func build() -> AnyView {
        return initView()
    }

    private func initView() -> AnyView {
        let networkManager: NetworkManager = NetworkManager()
        let toBeExerciseService = ToBeExerciseService(networkManager: networkManager)
        let viewModel = ExerciseViewModel(exerciseService: toBeExerciseService)
        let view = ExerciseView(viewModel: viewModel)
        
        return AnyView(view)
    }
}
