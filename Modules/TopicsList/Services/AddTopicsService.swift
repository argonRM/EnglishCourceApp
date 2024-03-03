//
//  AddTopicsService.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import Foundation
import CoreData

struct UserDefaultsKeys {
    static let isLaunchedFirstTime = "IsLaunchedFirstTime"
    static let apiKey = "apiKey"
}

class AddTopicsService {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func setupTopicsIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLaunchedFirstTime) else { return }
        let persistenceController = PersistenceController.shared
        let toBeTopic = TopicManagedModel(context: viewContext)
        toBeTopic.status = 0
        toBeTopic.subtitle = "Present Simple"
        toBeTopic.title = "To Be"
        toBeTopic.date = Date()
        toBeTopic.exerciseRequest = "You are an English teacher. Provide me 3 sentences to train 'to be' topic in Present Simple. I forbid you to numerate sentences. The sentence should have not more than 6 words. For example 'I _ a boy'. After the sentence instead of _ provide 4 to be words that a student needs to past. Separate them by | symbol. Put answers into (). The right answer should be in the next format 'am-ok'. Example: 'I _ a boy.(am-ok|she|he|it)'"
        toBeTopic.lessonRequest = "You are an English teacher. Provide me an explanation of the 'to be' topic in Present Simple."
        
        let toBePastTopic = TopicManagedModel(context: persistenceController.container.viewContext)
        toBePastTopic.status = 0
        toBePastTopic.title = "Was Were"
        toBePastTopic.subtitle = "Past Simple"
        toBePastTopic.date = Date()
        toBePastTopic.exerciseRequest = "You are an English teacher. Provide me 3 sentences to train 'to be' topic in Past Simple. I forbid you to numerate sentences. The sentence should have not more than 6 words. Put '_' instead of missing word. For example 'I _ a boy'. After the sentence instead of _ provide 4 to be words that a student needs to past. Separate them by | symbol. Put answers into (). The right answer should be in the next format 'was-ok'. Example: 'I _ a boy.(was-ok|do|were|did)'"
        toBePastTopic.lessonRequest = "You are an English teacher. Provide me an explanation of the 'to be' topic in Past Simple."
        
        let toBePastTopicQuestionNegative = TopicManagedModel(context: persistenceController.container.viewContext)
        toBePastTopicQuestionNegative.status = 0
        toBePastTopicQuestionNegative.title = "Was Were - Negative and Question forms"
        toBePastTopicQuestionNegative.subtitle = "Past Simple"
        toBePastTopicQuestionNegative.date = Date()
        toBePastTopicQuestionNegative.exerciseRequest = "You are an English teacher. Provide me 3 sentences to train 'to be' topic in Past Simple. Sentences should be only in negative form or question form. I forbid you to numerate sentences. The sentence should have not more than 6 words. For example 'I _ a boy'. Put '_' instead of missing word. After the sentence instead of _ provide 4 to be words that a student needs to past. Separate them by | symbol. Put answers into (). The right answer should be in the next format 'was-ok'. Example: 'I _ a boy.(was-ok|do|were|did)'"
        toBePastTopicQuestionNegative.lessonRequest = "You are an English teacher. Provide me an explanation of the 'to be' topic of the negative form and question form of in Past Simple."
    
        
        let presentTopic = TopicManagedModel(context: persistenceController.container.viewContext)
        presentTopic.status = 0
        presentTopic.title = "Positive form"
        presentTopic.subtitle = "Present Simple"
        presentTopic.date = Date()
        presentTopic.exerciseRequest = "You are an English teacher. Provide me 3 sentences to train Present Simple. Sentences should be only in positive form. I forbid you to numerate sentences. The sentence should have not more than 6 words. For example 'She _ a boy'. Put '_' instead of missing word. After the sentence instead of _ provide 4 words that a student needs to past. Separate them by | symbol. Put answers into (). The right answer should be in the next format 'loves-ok'. Example: 'She _ a boy.(loves-ok|love|loved|loving)'"
        presentTopic.lessonRequest = "You are an English teacher. Provide me an explanation of the positive form of Present Simple. Where I need to use 's' in the end of the verb where do not need"
        
        let presentQuestionsTopic = TopicManagedModel(context: persistenceController.container.viewContext)
        presentQuestionsTopic.status = 0
        presentQuestionsTopic.title = "Do Does - Question form"
        presentQuestionsTopic.subtitle = "Present Simple"
        presentQuestionsTopic.date = Date()
        presentQuestionsTopic.exerciseRequest = "You are an English teacher. Provide me 6 sentences to train Present Simple. Sentences should be in question form. I forbid you to put some symbols before sentences. The sentence should have not more than 6 words. For example '_ she love this boy?'. Put '_' instead of missing word. After the sentence instead of _ provide 4 words that a student needs to past. Separate them by | symbol. Put answers into (). The right answer should be in the next format 'Does-ok'. Example: '_ she love this boy?(Does-ok|Do|Did|Done)'"
        presentQuestionsTopic.lessonRequest = "You are an English teacher. Provide me an explanation of the question form in Present Simple."
        
        do {
            try persistenceController.container.viewContext.save()
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isLaunchedFirstTime)
        } catch {
            print(error)
        }
    }
}
