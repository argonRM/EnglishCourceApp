//
//  Topic.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import Foundation
import SwiftUI

class Topic: ObservableObject, Identifiable, Hashable {
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    let subtitle: String
    let title: String
    let date: Date
    let exerciseRequest: String
    let lessonRequest: String
    var status: Status
    var description: String = ""
    let id: String
    
    init(topicManagedModel: TopicManagedModel) {
        self.title = topicManagedModel.title ?? ""
        self.subtitle = topicManagedModel.subtitle ?? ""
        self.date = topicManagedModel.date ?? Date()
        self.status = Status(rawValue: Int(topicManagedModel.status)) ?? .start
        self.id = self.title + self.subtitle
        self.description = topicManagedModel.topicDescription ?? ""
        self.lessonRequest = topicManagedModel.lessonRequest ?? ""
        self.exerciseRequest = topicManagedModel.exerciseRequest ?? ""
    }
    
    init() {
        self.status = .inProgress
        self.title = ""
        self.subtitle = ""
        self.lessonRequest = ""
        self.exerciseRequest = ""
        self.date = Date()
        self.id = UUID().uuidString
    }
    
    init(title: String, subtitle: String) {
        self.status = .inProgress
        self.title = title
        self.subtitle = subtitle
        self.lessonRequest = ""
        self.exerciseRequest = ""
        self.description = "The completions endpoint also supports inserting text by providing a suffix in addition to the standard prompt which is treated as a prefix. This need naturally arises when writing long-form text, transitioning between paragraphs, following an outline, or guiding the model towards an ending. This also works on code, and can be used to insert in the middle of a function or file."
        self.date = Date()
        self.id = UUID().uuidString
    }
    
    var statusColor: Color {
        .subtitleColor
    }
    
    var subtitleColor: Color {
        .subtitleColor
    }
    
    var titleColor: Color {
        .titleColor
    }
    
    enum Status: Int {
        case start
        case inProgress
        case finished
        
        var image: String {
            switch self {
            case .start:
                return "figure.strengthtraining.functional"
            case .inProgress:
                return "figure.walk.motion"
            case .finished:
                return "flag.checkered.2.crossed"
            }
        }
        
        var title: String {
            switch self {
            case .start:
                return "Lets Start"
            case .inProgress:
                return "In Progress"
            case .finished:
                return "Finished"
            }
        }
    }
}
