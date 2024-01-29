//
//  ToBeExerciseBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

class ToBeExerciseBuilder {
    
    public func build() -> ToBeExerciseView {
        return initView()
    }

    private func initView() -> ToBeExerciseView {
        let networkManager: NetworkManager = NetworkManager()
        let viewModel = ToBeExerciseViewModel(networkManager: networkManager)
        let view = ToBeExerciseView(viewModel: viewModel)
        
        return view
    }
}
