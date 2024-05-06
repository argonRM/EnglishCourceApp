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
    private var cancellable: AnyCancellable?
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
        
        cancellable = $exercises
            .sink(receiveValue: { [weak self] exercises in
                guard let self, exercises.count > 0, exercises.map(\.isDone).allSatisfy({ $0 }) == true else { return }
                cancellable?.cancel()
                self.exerciseService.markTopicDone(self.topic)
                self.exercisesFinished?()
            })
    }
    
    func cancelLoadingActivities() {
        exerciseService.cancelImagesLoading()
    }
}
