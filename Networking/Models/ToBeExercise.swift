//
//  SentenceOption.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation

struct ToBeExercise: Identifiable {
    let id = UUID()
    let sentence: String
    var partsOfSentence: [String]
    let validOption: String
    let options: [String]
    var isDone = false {
        didSet {
            guard isDone == true else { return }
            guard let gapIndex = partsOfSentence.firstIndex(where: { $0 == "_" }) else { return }
           partsOfSentence[gapIndex] = validOption
        }
    }
    
    init(sentence: String, partsOfSentence: [String], validOption: String, options: [String], isDone: Bool = false) {
        self.sentence = sentence
        self.partsOfSentence = partsOfSentence
        self.validOption = validOption
        self.options = options
        self.isDone = isDone
    }
}
