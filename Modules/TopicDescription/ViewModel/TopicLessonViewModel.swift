//
//  TopicDescriptionViewModel.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 11.02.2024.
//

import Foundation
import Combine
import SwiftUI

final class TopicLessonViewModel: ObservableObject {
    @Published private var topicLessonService: TopicLessonService
    @Published var topic = Topic()
    @Published var isErrorOccurred: Bool = false
    @Published var isProcessing = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(topicLessonService: TopicLessonService) {
        self.topicLessonService = topicLessonService
        setupPublishers()
        self.topicLessonService.getTopic()
    }
    
    func setupPublishers() {
        topicLessonService.$topicLesson
            .assign(to: \.topic, on: self)
            .store(in: &cancellables)
        
        topicLessonService.$isErrorOccurred
            .assign(to: \.isErrorOccurred, on: self)
                        .store(in: &cancellables)
        
        topicLessonService.$isProcessing
            .assign(to: \.isProcessing, on: self)
                        .store(in: &cancellables)
        
    }
    
    func regenerateTopicDescription() {
        topicLessonService.getTopic(forceFetch: true)
    }
}
