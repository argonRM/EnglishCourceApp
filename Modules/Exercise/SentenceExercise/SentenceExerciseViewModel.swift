//
//  SentenceExerciseViewModel.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 27.01.2024.
//

import SwiftUI
import Combine

protocol ExerciseOptionsViewModelProtocol: ObservableObject {
    associatedtype ShapeStyleType: ShapeStyle
    
    var exercise: ToBeExercise { get set }
    var isBadAnswerAnimating: Bool { get set }
    var isRightAnswerMoveAnimating: Bool { get set }
    var isRightAnswerHideAnimating: Bool { get set }
    var isBadAnswerAnimatingYValue: CGFloat { get set }
    var answer: String { get set }
    
    func setupExerciseDone()
    func getCapsuleFill(optionValue: String) -> ShapeStyleType
    func checkRightAnswer(answer: String) -> Bool
    func answerOffset(_ answer: String) -> (x: CGFloat, y: CGFloat)
}

class SentenceExerciseViewModel: ExerciseOptionsViewModelProtocol {
    // MARK: - Properties
    @Published var exercise: ToBeExercise
    @Published var isGapAnimating: Bool = false
    @Published var isBadAnswerAnimating: Bool = false
    @Published var isRightAnswerMoveAnimating: Bool = false
    @Published var isRightAnswerHideAnimating: Bool = false
    @Published var isBadAnswerAnimatingYValue: CGFloat = -5
    @Published var answer = ""
    var dragAreaThreshold: CGFloat = 65
    
    // MARK: - init
    init(exercise: ToBeExercise) {
        self.exercise = exercise
    }
}

// MARK: - ExerciseOptionsViewModelProtocol
extension SentenceExerciseViewModel {
    
    func setupExerciseDone() {
        exercise.isDone = true
    }
    
    func getCapsuleFill(optionValue: String) -> some ShapeStyle {
        (isBadAnswerAnimating && self.answer == optionValue) ? Color.red.opacity(0.5) : Color.gray.opacity(0.5)
    }
    
    func checkRightAnswer(answer: String) -> Bool {
        answer == exercise.validOption
    }
    
    func answerOffset(_ answer: String) -> (x: CGFloat, y: CGFloat) {
        let y: CGFloat
        if isBadAnswerAnimating {
            y = (isBadAnswerAnimating && self.answer == answer) ? isBadAnswerAnimatingYValue : 0
        } else {
            y = (isRightAnswerMoveAnimating && self.answer == answer) ? -100 : 0
        }
        
        let x = (isRightAnswerMoveAnimating && self.answer == answer) ? 0.0 : 0
        
        return (x: x, y: y)
    }
}
