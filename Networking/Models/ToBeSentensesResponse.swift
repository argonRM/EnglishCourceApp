//
//  ToBeSentensesResponse.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation

struct ToBeSentenсesResponse: Codable {
    let choices: [Choice]
    let created: TimeInterval
    let id: String
    let model: String
    let object: String
    let systemFingerprint: String?
    let usage: Usage

    enum CodingKeys: String, CodingKey {
        case choices, created, id, model, object
        case systemFingerprint = "system_fingerprint"
        case usage
    }
}

struct Choice: Codable {
    let finishReason: String
    let index: Int
    let logprobs: String?
    let message: Message

    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case index, logprobs, message
    }
}

struct Message: Codable {
    let content: String
    let role: String
}

struct Usage: Codable {
    let completionTokens, promptTokens, totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case completionTokens = "completion_tokens"
        case promptTokens = "prompt_tokens"
        case totalTokens = "total_tokens"
    }
}
