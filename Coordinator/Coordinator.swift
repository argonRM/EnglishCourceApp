//
//  Coordinator.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 04.02.2024.
//

import SwiftUI

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Screen?
    @Published var fullScreenCover: Screen?
    private var topic: Topic?
    
    func push(_ screen: Screen, topic: Topic? = nil) {
        path.append(screen)
        self.topic = topic
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
        case .topicDescription:
            if let topic {
                TopicLessonBuilder(topic: topic).build()
            } else {
                nonTopicView()
            }
        case .exercise:
            if let topic {
                ExerciseBuilder(topic: topic).build()
            } else {
                nonTopicView()
            }
        case .exerciseDone:
            ExerciseDoneBuilder().build()
        case .faqScreen:
            FaqBuilder().build()
        }
    }
    
    private func nonTopicView() -> some View {
        ZStack {
            Color(.topicsBackground)
                .ignoresSafeArea()
            Text("Oops... it seems that there is no topic here...")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(radius: 10)
        }
    }
}
