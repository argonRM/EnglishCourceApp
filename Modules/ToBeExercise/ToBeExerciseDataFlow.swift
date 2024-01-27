//
//  ToBeExerciseDataFlow.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation

enum ToBeExerciseDataFlow {
    enum GetGetToBeExerciseResult {
        case success([ToBeExercise])
        case failure
    }
    
    struct ToBeExercise: Identifiable {
        let id = UUID()
        let sentence: String
        let partsOfSentence: [String]
        let validOption: String
        let options: [String]
    }
    
    enum GetToBeExerciseError: Error {
        case badResponse
    }
}
