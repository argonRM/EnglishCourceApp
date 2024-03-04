//
//  ToBeExerciseService.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 30.01.2024.
//

import Foundation
import Combine
import CoreData

final class ExerciseService {
    @Published var exercises: [ToBeExercise] = []
    @Published var isErrorOccurred: Bool = false
    @Published var isProcessing = false
    private var cancellables: Set<AnyCancellable> = []
    private var networkManager: NetworkManager
    private var context: NSManagedObjectContext
    
    init(networkManager: NetworkManager, context: NSManagedObjectContext) {
        self.networkManager = networkManager
        self.context = context
    }
    
    var isAllDone: Bool {
        exercises.forEach({ print($0.isDone) })
        return exercises.map(\.isDone).allSatisfy { $0 }
    }
    
    func markTopicDone(_ topic: Topic) {
        markTopicDone(topic, context: context)
    }
    
    func getExercise(for topic: Topic) {
        if !apiKey.isEmpty {
            getChatGPTExercise(for: topic)
        } else {
            getHardcodedExercise()
        }
    }
}

// MARK: - Private
private extension ExerciseService {
    private func getChatGPTExercise(for topic: Topic) {
        isProcessing = true
        
        let requestModel = GeneralGTPRequest(
            model: "gpt-3.5-turbo",
            messages: [GeneralGTPRequest.Message(role: "user", content: topic.exerciseRequest)])
        
        networkManager.gptRequestPublisher(requestModel: requestModel, requestType: .toBeSentences)
            .tryMap { data, response in
                print(response)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw ToBeExerciseServiceError.badResponse
                }
                
                return data
            }
        
            .decode(type: GeneralGTPResponse.self, decoder: JSONDecoder())
            .breakpoint(receiveOutput: { receiveOutput in
                print(receiveOutput)
                return false
            })
            .compactMap { self.parseSentenceOptionsString($0.choices.first?.message.content) }
            .breakpoint(receiveOutput: { receiveOutput in
                print(receiveOutput)
                return false
            })
            .receive(on: DispatchQueue.main)
            .mapError { error -> Error in
                print(error)
                self.isErrorOccurred = true
                self.isProcessing = false
                return error
            }
            .catch { error -> AnyPublisher<[ToBeExercise], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.getImagesForExercises()
                case .failure(let error):
                    print(error)
                    isErrorOccurred = true
                    isProcessing = false
                }
            }, receiveValue: { [weak self] exercises in
                self?.exercises = exercises
            })
            .store(in: &cancellables)
    }
    
    func getHardcodedExercise() {
        isProcessing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isProcessing = false
            self?.exercises = [ToBeExercise(sentence: "I _ a little good boy.", partsOfSentence: ["I", "_", "a", "little", "good", "boy."],  validOption: "am", options: ["am", "is", "it", "does"], imageUrl: "https://img.freepik.com/free-photo/little-boy-expressing-pure-happiness_23-2148244742.jpg?t=st=1709342331~exp=1709345931~hmac=37919454bbddf075d805e9f20057886514e0de892112947a3958a8444086eee8&w=1060"),
                               ToBeExercise(sentence: "She _ a good student studying in a University.", partsOfSentence: ["She", "_", "a", "good", "student", "studying", "in", "a", "University."],  validOption: "is", options: ["am", "is", "it", "does"], imageUrl: "https://img.freepik.com/free-photo/vertical-shot-happy-young-woman-with-curly-hair-holds-notepad-pen-makes-notes-what-she-observes-around-city-dressed-casual-green-jumper-poses-outdoors-against-blurred-background_273609-56665.jpg?t=st=1709342447~exp=1709346047~hmac=bc5f6292f08fbe879a754feccb7d1c932dba2365b29b8c5804aecbe6fcb6c1c2&w=740"),
                               ToBeExercise(sentence: "This _ a lazy person.", partsOfSentence: ["This", "_", "a", "lazy", "person."],  validOption: "is", options: ["am", "is", "it", "does"], imageUrl: "https://img.freepik.com/free-photo/woman-wrapped-blanket-sits-bed-with-cup-coffee-her-hands_169016-18396.jpg?t=st=1709342490~exp=1709346090~hmac=86365caa213c27c2995df56fb1d22c2a313892f9439e0d9406e031d2cb0f5a8d&w=1800")]
        }
    }
    
    func getImageFor(exercise: ToBeExercise, completion: @escaping () -> Void) {
        let requestModel = GenerateImageRequest(model: "dall-e-3", prompt: "Generate an image that reflect the essence of the sentence <\(exercise.sentence)>. The image should be in cartoon format.", n: 1, size: "1024x1024")
        
        networkManager.gptRequestPublisher(requestModel: requestModel, requestType: .generateImage)
            .tryMap { data, response in
                print(response)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw ToBeExerciseServiceError.badResponse
                }
                
                return data
            }
            .decode(type: GenerateImageResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                completion()
            }, receiveValue: { [weak self] generateImageResponse in
                guard let self = self else { return }
                if let index = self.exercises.firstIndex(where: { $0.sentence == exercise.sentence }) {
                    print(generateImageResponse.data.first?.url ?? "no image response")
                    self.exercises[index].imageUrl = generateImageResponse.data.first?.url
                }
            })
            .store(in: &cancellables)
    }
    
    func getImagesForExercises() {
        var responsesReceived = 0
        let totalExercises = exercises.count
        
        exercises.forEach { [weak self] exercise in
            self?.getImageFor(exercise: exercise) {
                responsesReceived += 1
                if responsesReceived == totalExercises {
                    self?.isProcessing = false
                }
            }
        }
    }
    
    func parseSentenceOptionsString(_ input: String?) -> [ToBeExercise]? {
        guard let input else { return nil }
        let lines = input.components(separatedBy: "\n")
        
        return lines.map { line in
            let components = line.components(separatedBy: "(")
            guard components.count == 2 else {
                return nil
            }
            
            var sentence = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let partsOfSentence = getPartsOfSentence(from: sentence)
            
            let optionsString = components[1].replacingOccurrences(of: ")", with: "")
            let options = optionsString.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "-ok", with: "") }
            
            let validOption = options.first { $0.isEmpty == false } ?? ""
            
            sentence = sentence.replacingOccurrences(of: "_", with: validOption)
            
            return ToBeExercise(sentence: sentence, partsOfSentence: partsOfSentence, validOption: validOption, options: options.shuffled())
        }.compactMap { $0 }
    }
    
    func getPartsOfSentence(from sentence: String) -> [String] {
        let components = sentence.components(separatedBy: " ")
        
        var separatedStrings: [String] = []
        
        components.forEach {
            separatedStrings.append($0.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        return separatedStrings
    }
    
    func markTopicDone(_ topic: Topic, context: NSManagedObjectContext) {
        let request = NSFetchRequest<TopicManagedModel>(entityName: "TopicManagedModel")
        request.predicate = NSPredicate(format: "subtitle == %@ AND title == %@", topic.subtitle, topic.title)
        
        do {
            let topics = try context.fetch(request)
            
            if let firstTopic = topics.first {
                firstTopic.status = Int16(Topic.Status.finished.rawValue)
                topic.status = .finished
                try context.save()
            }
        } catch {
            print("Error fetching or saving data: \(error.localizedDescription)")
        }
    }
}

extension ExerciseService {
    enum ToBeExerciseServiceError: Error {
        case badResponse
    }
}
