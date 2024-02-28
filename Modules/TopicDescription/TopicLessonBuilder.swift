//
//  TopicDescriptionBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 04.02.2024.
//

import Foundation

import SwiftUI

class TopicLessonBuilder: ScreenBuilder {
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
        let topicLessonService = TopicLessonService(networkManager: networkManager, context: viewContext)
        let topicLessonViewModel = TopicLessonViewModel(topic: topic, topicLessonService: topicLessonService)
        let view = TopicLessonView(viewModel: topicLessonViewModel)
        
        return AnyView(view)
    }
}
