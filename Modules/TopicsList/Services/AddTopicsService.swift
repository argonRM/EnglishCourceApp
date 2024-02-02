//
//  AddTopicsService.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import Foundation
import CoreData

class AddTopicsService {
    
    private let viewContext: NSManagedObjectContext
    
    private struct UserDefaultsKeys {
        static let isLaunchedFirstTime = "IsLaunchedFirstTime"
    }
    
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
        toBeTopic.id = UUID()
        
        let toBePastTopic = TopicManagedModel(context: persistenceController.container.viewContext)
        toBePastTopic.status = 0
        toBePastTopic.title = "Was Were"
        toBePastTopic.subtitle = "Past Simple"
        toBePastTopic.date = Date()
        toBePastTopic.id = UUID()
        
        let presentTopic = TopicManagedModel(context: persistenceController.container.viewContext)
        presentTopic.status = 0
        presentTopic.title = "Do does"
        presentTopic.subtitle = "Present Simple"
        presentTopic.date = Date()
        presentTopic.id = UUID()
        
        let presentQuestionsTopic = TopicManagedModel(context: persistenceController.container.viewContext)
        presentQuestionsTopic.status = 0
        presentQuestionsTopic.title = "Present Simple Questions"
        presentQuestionsTopic.subtitle = "Present Simple"
        presentQuestionsTopic.date = Date()
        presentQuestionsTopic.id = UUID()
        
        do {
            try persistenceController.container.viewContext.save()
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isLaunchedFirstTime)
        } catch {
            print(error)
        }
    }
}
