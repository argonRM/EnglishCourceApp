//
//  Screen.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 28/02/2024.
//

import Foundation

enum Screen: Identifiable, Hashable {
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
    
    case topicsList, topicDescription(Topic), exercise(Topic), exerciseDone, faqScreen
    
    var id: UUID {
        UUID()
    }
}
