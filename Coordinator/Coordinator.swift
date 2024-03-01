//
//  Coordinator.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 04.02.2024.
//

import SwiftUI

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Screen?
    @Published var fullScreenCover: Screen?
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func present(sheet screen: Screen) {
        sheet = screen
    }
    
    func present(fullScreenCover screen: Screen) {
        fullScreenCover = screen
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(screen: Screen) -> some View {
        switch screen {
        case .topicsList:
            TopicsListBuilder().build()
        case .topicDescription(let topic):
            TopicLessonBuilder(topic: topic).build()
        case .exercise(let topic):
            ExerciseBuilder(topic: topic).build()
        case .exerciseDone:
            ExerciseDoneBuilder().build()
        case .faqScreen:
            FaqBuilder().build()
        }
    }
}
