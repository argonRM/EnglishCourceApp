//
//  ToBeExerciseViewModel.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import Foundation
import Combine

class ToBeExerciseViewModel: ObservableObject {
    // MARK: - Private
    private var cancellation: AnyCancellable?
    private var networkManager: NetworkManager
    
    // MARK: - Public
    @Published var exercises: [ToBeExerciseDataFlow.ToBeExercise] = []
    @Published var isErrorOccurred: Bool = false
    @Published var isProcessing = false
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getExercise() {
        isProcessing = true
//        let requestModel = ToBeExerciseRequest(
//            model: "gpt-3.5-turbo",
//            messages: [ToBeExerciseRequest.Message(role: "user", content: "You are an English teacher. Provide me 10 sentences to train 'to be' topic in Present Simple. I forbid you to numerate sentences. For example 'I _ a boy'. After the sentence instead of _ provide 4 to be words that a student needs to past. Separate them by | symbol. Put answers into (). The right answer should be in the next format 'am-ok'. Example: 'I _ a boy.(am-ok|she|he|it)'")])
//
//        cancellation = networkManager.gptRequestPublisher(requestModel: requestModel, requestType: .toBeSentences)
//            .tryMap { data, response in
//                print(response)
//                guard let httpResponse = response as? HTTPURLResponse,
//                      httpResponse.statusCode == 200 else {
//                    throw ToBeExerciseDataFlow.GetToBeExerciseError.badResponse
//                }
//
//                return data
//            }
//
//            .decode(type: ToBeSentenсesResponse.self, decoder: JSONDecoder())
//            .breakpoint(receiveOutput: { receiveOutput in
//                print(receiveOutput)
//                return false
//            })
//            .compactMap { self.parseSentenceOptionsString($0.choices.first?.message.content) }
//            .breakpoint(receiveOutput: { receiveOutput in
//                print(receiveOutput)
//                return false
//            })
//            .receive(on: DispatchQueue.main)
//            .catch { error -> AnyPublisher<[ToBeExerciseDataFlow.ToBeExercise], Error> in
//                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
//            }
//            .sink(receiveCompletion: { [weak self] completion in
//                guard let self else { return }
//                switch completion {
//                case .finished:
//                    isErrorOccurred = false
//                case .failure(let error):
//                    print(error)
//                    isErrorOccurred = true
//                }
//                isProcessing = false
//                cancellation?.cancel()
//            }, receiveValue: { [weak self] exercises in
//                self?.exercises = exercises
//            })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.exercises = [ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])]
            self.isProcessing = false
        }
    }
}

// MARK: - Private
private extension ToBeExerciseViewModel {
    func parseSentenceOptionsString(_ input: String?) -> [ToBeExerciseDataFlow.ToBeExercise]? {
        guard let input else { return nil }
        let lines = input.components(separatedBy: "\n")
        
        return lines.map { line in
            let components = line.components(separatedBy: "(")
            guard components.count == 2 else {
                return nil
            }
            
            let sentence = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let partsOfSentence = getPartsOfSentence(from: sentence)
          
            let optionsString = components[1].replacingOccurrences(of: ")", with: "")
            let options = optionsString.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "-ok", with: "") }
            
            let validOption = options.first { $0.isEmpty == false } ?? ""
            
            return ToBeExerciseDataFlow.ToBeExercise(sentence: sentence, partsOfSentence: partsOfSentence, validOption: validOption, options: options)
        }.compactMap { $0 }
    }
    
    func getPartsOfSentence(from sentence: String) -> [String] {
        let components = sentence.components(separatedBy: " ")

        var separatedStrings: [String] = []

        for (index, component) in components.enumerated() {
            separatedStrings.append(component.trimmingCharacters(in: .whitespacesAndNewlines))

            if index < components.count - 1 {
                separatedStrings.append("_")
            }
        }

        return separatedStrings
    }
}
