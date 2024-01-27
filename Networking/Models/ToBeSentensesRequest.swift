//
//  ToBeSentensesRequest.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation

struct ToBeExerciseRequest: Codable {
    let model: String
    let messages: [Message]
  
    struct Message: Codable {
        let role: String
        let content: String
    }
}
