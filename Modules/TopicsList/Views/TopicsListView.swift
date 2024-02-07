//
//  TopicsListView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import SwiftUI

struct TopicsListView: View {
    @ObservedObject private var viewModel: TopicsListViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    init(viewModel: TopicsListViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        List {
            ForEach(viewModel.topics) { topic in
                printTopic(topic: topic)
                TopicsListViewCell(topic: topic)
                    .onTapGesture {
                        coordinator.push(.topicDescription)
                    }
            }
            
        }
        .listStyle(.plain)
        .background(Color.accentColor)
    }
    
    func printTopic(topic: Topic) -> EmptyView {
        print("\(topic.subtitle) \(topic.title) \(topic.status)")
        return EmptyView()
    }
}


struct TopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        TopicsListView(viewModel: TopicsListViewModel(context: PersistenceController.preview.container.viewContext, addTopicsService: AddTopicsService(viewContext: PersistenceController.preview.container.viewContext)))
        }
}
