//
//  Topic.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import Foundation
import SwiftUI

class Topic: ObservableObject, Identifiable {
    let subtitle: String
    let title: String
    let date: Date
    var status: Status
    var description: String = ""
    let id: UUID
    
    init(topicManagedModel: TopicManagedModel) {
        self.title = topicManagedModel.title ?? ""
        self.subtitle = topicManagedModel.subtitle ?? ""
        self.date = topicManagedModel.date ?? Date()
        self.status = Status(rawValue: Int(topicManagedModel.status)) ?? .start
        self.id = topicManagedModel.id ?? UUID()
        self.description = topicManagedModel.topicDescription ?? ""
    }
    
    init() {
        self.status = .inProgress
        self.title = ""
        self.subtitle = ""
        self.date = Date()
        self.id = UUID()
    }
    
    init(title: String, subtitle: String) {
        self.status = .inProgress
        self.title = title
        self.subtitle = subtitle
        self.date = Date()
        self.id = UUID()
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
