//
//  TopicsListBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import SwiftUI

class TopicsListBuilder: ScreenBuilder {
    public func build() -> AnyView {
        return initView()
    }

    private func initView() -> AnyView {
        let viewContext = PersistenceController.shared.container.viewContext
        let addTopicsService = AddTopicsService(viewContext: viewContext)
        let viewModel = TopicsListViewModel(context: viewContext, addTopicsService: addTopicsService)
        let view = TopicsListView(viewModel: viewModel)
        
        return AnyView(view)
    }
}
