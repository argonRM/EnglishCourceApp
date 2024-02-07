//
//  ToBeExerciseService.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 30.01.2024.
//

import Foundation
import Combine
import CoreData

final class ToBeExerciseService: ExerciseServiceProtocol {
    var exercisesPublisher: Published<[ToBeExercise]>.Publisher {
        $exercises
    }
    
    var isErrorOccurredPublisher: Published<Bool>.Publisher {
        $isErrorOccurred
    }
    
    var isProcessingPublisher: Published<Bool>.Publisher {
        $isProcessing
    }

    private var cancellation: AnyCancellable?
    private var networkManager: NetworkManager
    private var context: NSManagedObjectContext
    @Published var exercises: [ToBeExercise] = []
    @Published var isErrorOccurred: Bool = false
    @Published var isProcessing = false
    
    init(networkManager: NetworkManager, context: NSManagedObjectContext) {
        self.networkManager = networkManager
        self.context = context
    }
    
    var isAllDone: Bool {
        print("isDone")
        exercises.forEach({ print($0.isDone) })
        
        return exercises.map(\.isDone).allSatisfy { $0 }
    }
    
    func markTopicDone() {
        markTopicDone(context: context)
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
//            .catch { error -> AnyPublisher<[ToBeExercise], Error> in
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
//
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isProcessing = false
            self?.exercises = [ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExercise(sentence: "I _ am a good student.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                              ToBeExercise(sentence: "I _ am a lazy person.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])]
        }
    }
}

// MARK: - Private
private extension ToBeExerciseService {
    func parseSentenceOptionsString(_ input: String?) -> [ToBeExercise]? {
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
            
            return ToBeExercise(sentence: sentence, partsOfSentence: partsOfSentence, validOption: validOption, options: options)
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
    
    func markTopicDone(context: NSManagedObjectContext) {
        let request = NSFetchRequest<TopicManagedModel>(entityName: "TopicManagedModel")
        request.predicate = NSPredicate(format: "subtitle == %@ AND title == %@", "Present Simple", "To Be")

        do {
            let topics = try context.fetch(request)
            
            if let firstTopic = topics.first {
                firstTopic.status = Int16(Topic.Status.finished.rawValue)
                try context.save()
            }
        } catch {
            print("Error fetching or saving data: \(error.localizedDescription)")
        }
    }
}
