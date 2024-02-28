//
//  NetworkManager.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation
import Combine

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
        
        private var apiKey: String {
            "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"
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
            // Конвертація в JSON
            let jsonData = try JSONEncoder().encode(requestModel)
            
            return jsonData
        } catch {
            fatalError("Error encoding JSON: \(error)")
        }
    }
}
    
    
//    func generateChatGPTResponse() {
//        guard let url = URL(string: endpoint) else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody =  getRequestBody()
//
//
//
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//            } else if let data = data {
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("Response: \(jsonResponse)")
//
//                    let response = try JSONDecoder().decode(GeneralGTPResponse.self, from: data)
//                    print(response.choices.first?.message)
//
//                    let sentenceOption = self.parseSentenceOptionsString(response.choices.first?.message.content ?? "")
//                    print(sentenceOption)
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }
//
//        task.resume()
//    }
    

    
//    func generateChatGPTResponse() -> AnyPublisher<[ToBeExercise], Error> {
//        guard let url = URL(string: endpoint) else {
//            print("Invalid URL")
//            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody =  getRequestBody()
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response in
//                guard let httpResponse = response as? HTTPURLResponse,
//                      httpResponse.statusCode == 200 else {
//                    throw NetworkError.badResponse
//                }
//
//                return data
//            }
//            .decode(type: ToBeSentenсesResponse.self, decoder: JSONDecoder())
//            .compactMap{ self.parseSentenceOptionsString($0.choices.first?.message.content) }
//            .receive(on: DispatchQueue.main)
//            .catch { error -> AnyPublisher<[ToBeExercise], Error> in
//                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
//            }
//            .eraseToAnyPublisher()
//    }
//
//    func parseSentenceOptionsString(_ input: String?) -> [ToBeExercise]? {
//        guard let input else { return nil }
//        let lines = input.components(separatedBy: "\n")
//
//        return lines.map { line in
//            let components = line.components(separatedBy: "(")
//            guard components.count == 2 else {
//                return nil
//            }
//
//            let sentence = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
//
//            let optionsString = components[1].replacingOccurrences(of: ")", with: "")
//            let options = optionsString.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "-ok", with: "") }
//
//            let validOption = options.first { $0.isEmpty == false } ?? ""
//
//            return ToBeExercise(sentence: sentence, validOption: validOption, options: options)
//        }.compactMap { $0 }
//    }
//
//    func getRequestBody() -> Data {
//        let request = GeneralGTPRequest(
//            model: "gpt-3.5-turbo",
//            messages: [ToBeExerciseRequest.Message(role: "user", content: "Provide me 10 sentences to train 'to be' topic in Present Simple. For example 'I _ a boy'. After the sentence instead of _ provide 4 to be words that a student needs to past. Separate them by | symbol. Put answers into (). The right answer should be in the next format 'am-ok'. Example: 'I _ a boy.(am-ok|she|he|it)'")])
//
//        // Конвертація в JSON
//        do {
//            // Конвертація в JSON
//            let jsonData = try JSONEncoder().encode(request)
//
//            return jsonData
//        } catch {
//            fatalError("Error encoding JSON: \(error)")
//        }
//    }
//
//    func getRequestBody(requestModel: Codable) -> Data {
//        do {
//            // Конвертація в JSON
//            let jsonData = try JSONEncoder().encode(requestModel)
//
//            return jsonData
//        } catch {
//            fatalError("Error encoding JSON: \(error)")
//        }
//    }
//}
