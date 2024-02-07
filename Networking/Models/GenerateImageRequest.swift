//
//  GenerateImageRequest.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 07.02.2024.
//

import Foundation

struct GenerateImageRequest: Codable {
    let model: String
    let prompt: String
    let n: Int
    let size: String
}
