//
//  ToBeExerciseViewModel.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation
import Combine
import SwiftUI

final class ExerciseViewModel<ExerciseService>: ObservableObject where ExerciseService: ExerciseServiceProtocol {
    
    @Published private var exerciseService: ExerciseService
    private var cancellables: Set<AnyCancellable> = []
    @Published var exercises: [ToBeExercise] = []
    @Published var isErrorOccurred: Bool = false
    @Published var isProcessing = false
    
    var exercisesFinished: (()->())?
    
    init(exerciseService: ExerciseService) {
        self.exerciseService = exerciseService
        self.exerciseService.getExercise()
        
        self.setupPublishers()

    }
    
    func setupPublishers() {
        exerciseService.exercisesPublisher
            .assign(to: \.exercises, on: self)
            .store(in: &cancellables)
        
        exerciseService.isErrorOccurredPublisher
            .assign(to: \.isErrorOccurred, on: self)
                        .store(in: &cancellables)
        
        exerciseService.isProcessingPublisher
            .assign(to: \.isProcessing, on: self)
                        .store(in: &cancellables)
        
        $exercises
            .sink(receiveValue: { [weak self] exercises in
                guard exercises.count > 0, exercises.map(\.isDone).allSatisfy({ $0 }) == true else { return }
                self?.exercisesFinished?()
            })
            .store(in: &cancellables)
    }
}
