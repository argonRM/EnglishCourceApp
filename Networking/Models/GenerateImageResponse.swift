//
//  GenerateImageResponse.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 07.02.2024.
//

import Foundation

struct GenerateImageResponse: Codable {
    let created: Int
    let data: [DataItem]
    
    struct DataItem: Codable {
        let url: String
    }
}
