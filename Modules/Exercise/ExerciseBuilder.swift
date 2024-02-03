//
//  ToBeExerciseBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

class ExerciseBuilder {
    public func build() -> ExerciseView<ToBeExerciseService> {
        return initView()
    }

    private func initView() -> ExerciseView<ToBeExerciseService> {
        let networkManager: NetworkManager = NetworkManager()
        let toBeExerciseService = ToBeExerciseService(networkManager: networkManager)
        let viewModel = ExerciseViewModel(exerciseService: toBeExerciseService)
        let view = ExerciseView(viewModel: viewModel)
        
        return view
    }
}
