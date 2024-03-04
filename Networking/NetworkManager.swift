//
//  NetworkManager.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation
import Combine

var apiKey: String = UserDefaults.standard.string(forKey: UserDefaultsKeys.apiKey) ?? "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"

struct NetworkManager {
    
    // MARK: - Request
    enum Request {
        case toBeSentences
        case generateImage
        
        var endPoint: String {
            switch self {
            case .toBeSentences:
                return "https://api.openai.com/v1/chat/completions"
            case .generateImage:
                return "https://api.openai.com/v1/images/generations"
            }
        }
        
        private var method: String {
            switch self {
            case .toBeSentences, .generateImage:
                return "POST"
            }
        }
        
        func getURLRequest(from data: Data) -> URLRequest {
            guard let url = URL(string: endPoint) else {
                fatalError("Invalid URL")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            return request
        }
    }
    
    // MARK: - Publisher
    func gptRequestPublisher(requestModel: Codable, requestType: Request) -> URLSession.DataTaskPublisher {
        let httpBody = getRequestBody(requestModel: requestModel)
        let request = requestType.getURLRequest(from: httpBody)
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
        return publisher
    }
}

// MARK: - Private
private extension NetworkManager {
    func getRequestBody(requestModel: Codable) -> Data {
        do {
            let jsonData = try JSONEncoder().encode(requestModel)
            
            return jsonData
        } catch {
            fatalError("Error encoding JSON: \(error)")
        }
    }
}
