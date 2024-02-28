//
//  ToBeExerciseViewModel.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation
import Combine
import SwiftUI

final class ExerciseViewModel: ObservableObject {
    
    @Published private var exerciseService: ExerciseService
    private var cancellables: Set<AnyCancellable> = []
    @Published var exercises: [ToBeExercise] = []
    @Published var isErrorOccurred: Bool = false
    @Published var isProcessing = false
    @Published var topic: Topic
    
    var exercisesFinished: (()->())?
    
    init(topic: Topic, exerciseService: ExerciseService) {
        self.exerciseService = exerciseService
        self.topic = topic
        self.exerciseService.getExercise(for: topic)
        
        self.setupPublishers()

    }
    
    func setupPublishers() {
        exerciseService.$exercises
            .assign(to: \.exercises, on: self)
            .store(in: &cancellables)
        
        exerciseService.$isErrorOccurred
            .assign(to: \.isErrorOccurred, on: self)
                        .store(in: &cancellables)
        
        exerciseService.$isProcessing
            .assign(to: \.isProcessing, on: self)
                        .store(in: &cancellables)
        
        $exercises
            .sink(receiveValue: { [weak self] exercises in
                guard exercises.count > 0, exercises.map(\.isDone).allSatisfy({ $0 }) == true else { return }
                self?.exerciseService.markTopicDone()
                self?.exercisesFinished?()
            })
            .store(in: &cancellables)
    }
}
