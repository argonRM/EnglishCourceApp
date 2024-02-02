//
//  CoreDataHandler.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import CoreData
import Combine
import SwiftUI

class TopicsListViewModel: ObservableObject {
    @Published var topics: [Topic] = []
    let addTopicsService: AddTopicsService

    init(context: NSManagedObjectContext, addTopicsService: AddTopicsService) {
        self.addTopicsService = addTopicsService
        self.addTopicsService.setupTopicsIfNeeded()
        fetchDataFromCoreData(context: context)
    }

    private func fetchDataFromCoreData(context: NSManagedObjectContext) {
        let request = NSFetchRequest<TopicManagedModel>(entityName: "TopicManagedModel")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TopicManagedModel.date, ascending: true)]

        context.publisher(for: \.hasChanges)
            .compactMap { _ in
                try? context.fetch(request).map { Topic(topicManagedModel: $0) }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$topics)
    }
}

