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
    
    func getLesson(for topic: Topic, forceFetch: Bool = false) {
        isProcessing = true
        topicLesson = topic
        if topic.description.isEmpty || forceFetch {
            getTopicLesson(for: topic)
        } else {
            self.isProcessing = false
        }
    }
}

// MARK: - Private
private extension TopicLessonService {
    func updateTopic() {
        let request = NSFetchRequest<TopicManagedModel>(entityName: "TopicManagedModel")
        request.predicate = NSPredicate(format: "subtitle == %@ AND title == %@", topicLesson.subtitle, topicLesson.title)

        do {
            let topics = try context.fetch(request)
            
            if let firstTopic = topics.first {
                firstTopic.topicDescription = topicLesson.description
                try context.save()
            }
        } catch {
            print("Error fetching or saving data: \(error.localizedDescription)")
        }
    }
    
    private func getTopicLesson(for topic: Topic) {
        if !apiKey.isEmpty {
            getChatGPTLesson()
        } else {
            getHardcodedLesson()
        }
    }
    
    private func getChatGPTLesson() {
        isProcessing = true
        
        let requestModel = GeneralGTPRequest(
            model: "gpt-3.5-turbo",
            messages: [GeneralGTPRequest.Message(role: "user", content: topicLesson.lessonRequest)])
        
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
                self.topicLesson.description = description
                self.updateTopic()
            })
            .store(in: &cancellables)
    }
    
    private func getHardcodedLesson() {
        isProcessing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            self.isProcessing = false
            self.topicLesson.description = hardcodedLesson
            self.updateTopic()
        }
    }
    
    var hardcodedLesson: String {
    """
    This is hardcoded text!!!
    
    Present Simple is a tense in English used to describe actions that are habitual, routine, or generally true. It is also used to express future events that are scheduled or timetabled. The basic form of a verb in Present Simple is the same as the base form of the verb (e.g., 'I work' or 'He works'). In third-person singular (he, she, it), 's' or 'es' is added to the base form of the verb (e.g., 'He works'). Statements in Present Simple do not require auxiliary verbs like 'do' or 'does' except for negative statements and questions.
    Usage:

    Habitual actions: "I drink coffee every morning."
    General truths: "The sun rises in the east."
    Scheduled events: "The train leaves at 8 PM."
    Form:

    Affirmative: Subject + base form of the verb (+ -s/-es for third person singular)
    Negative: Subject + do not/does not + base form of the verb
    Questions: Do/Does + subject + base form of the verb?
    Spelling rules:

    Verbs ending in -s, -ss, -sh, -ch, -x, -o add -es in the third person singular: "He passes the ball."
    Verbs ending in a consonant + y, change the y to i and add -es: "She studies hard."
    Verbs ending in a vowel + y, just add -s: "They play in the park."
    Use of the third person singular -s:

    He, she, it + base form of the verb + -s/es: "She goes to school."
    Signal words often used with Present Simple:

    Always, usually, often, sometimes, rarely, never (for habitual actions)
    Every day/week/month/year, always, never (for frequency)
    On Mondays, in the summer, in April (for regular occurrences)
    Note:

    The Present Simple tense does not use auxiliary verbs in the positive form, except for the third person singular.
    In questions and negatives, the auxiliary verb "do" is used (does for third person singular).
    Example sentences:

    Affirmative: "I work from home."
    Negative: "She does not like spicy food."
    Question: "Do they play tennis on Saturdays?
    """
    }
}

// MARK: - Error
extension TopicLessonService {
    enum TopicLessonServiceError: Error {
        case badResponse
    }
}

