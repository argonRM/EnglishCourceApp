//
//  TopicDescriptionService.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 12.02.2024.
//

import Foundation
import Combine
import CoreData

final class TopicLessonService: ObservableObject {
    
    private var networkManager: NetworkManager
    private var context: NSManagedObjectContext
    @Published var topicLesson = Topic()
    @Published var isErrorOccurred: Bool = false
    @Published var isProcessing = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkManager: NetworkManager, context: NSManagedObjectContext) {
        self.networkManager = networkManager
        self.context = context
    }
    
    func getDescription(for topic: Topic, forceFetch: Bool = false) {
        isProcessing = true
        topicLesson = topic
        if topic.description.isEmpty || forceFetch {
            getTopicLesson(for: topic)
        } else {
            self.isProcessing = false
        }
    }
    
    private func getTopicLesson(for topic: Topic) {
        isProcessing = true
        
        let requestModel = GeneralGTPRequest(
            model: "gpt-3.5-turbo",
            messages: [GeneralGTPRequest.Message(role: "user", content: topic.lessonRequest)])
        
        networkManager.gptRequestPublisher(requestModel: requestModel, requestType: .toBeSentences)
            .tryMap { data, response in
                print(response)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw TopicLessonServiceError.badResponse
                }
                
                return data
            }
        
            .decode(type: GeneralGTPResponse.self, decoder: JSONDecoder())
            .breakpoint(receiveOutput: { receiveOutput in
                print(receiveOutput)
                return false
            })
            .compactMap { $0.choices.first?.message.content }
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
            .catch { error -> AnyPublisher<String, Error> in
                return Just("").setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    isErrorOccurred = self.topicLesson.description.isEmpty ? true : false
                    isProcessing = false
                case .failure(let error):
                    print(error)
                    isErrorOccurred = true
                    isProcessing = false
                }
            }, receiveValue: { [weak self] description in
                guard let self, !description.isEmpty else { return }
                let changedTopic = self.topicLesson
                changedTopic.description = description
                self.topicLesson = changedTopic
                self.updateTopic(topic, description: description)
            })
            .store(in: &cancellables)
    }
    
    func updateTopic(_ topic: Topic, description: String) {
        let request = NSFetchRequest<TopicManagedModel>(entityName: "TopicManagedModel")
        request.predicate = NSPredicate(format: "subtitle == %@ AND title == %@", topic.subtitle, topic.title)

        do {
            let topics = try context.fetch(request)
            
            if let firstTopic = topics.first {
                firstTopic.topicDescription = description
                try context.save()
            }
        } catch {
            print("Error fetching or saving data: \(error.localizedDescription)")
        }
    }
}

// MARK: - Error
extension TopicLessonService {
    enum TopicLessonServiceError: Error {
        case badResponse
    }
}

