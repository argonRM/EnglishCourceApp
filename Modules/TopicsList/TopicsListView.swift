//
//  TopicsListView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import SwiftUI

struct TopicsListView: View {
    @ObservedObject private var viewModel: TopicsListViewModel
    
    init(viewModel: TopicsListViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        List {
            ForEach(viewModel.topics) { topic in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.cellColor)
                        .frame(height: 80)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(topic.subtitle)
                                .font(Font.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(topic.subtitleColor)
                                .multilineTextAlignment(.leading)
                                .italic()
                            Text(topic.title)
                                .font(.title2)
                                .fontWeight(.heavy)
                        }
                        .padding(.leading, 15)
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: topic.status.image)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(topic.statusColor)
                            Text(topic.status.title)
                                .font(.footnote)
                                .foregroundColor(topic.statusColor)
                        }
                        .padding(.trailing, 15)
                        Image(systemName: "")
                    }
                    
                }
                .listRowBackground(Color.accentColor)
                .listRowSeparator(.hidden)
            }
            
        }
        .listStyle(.plain)
        .background(Color.accentColor)
    }
}

struct TopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        TopicsListView(viewModel: TopicsListViewModel(context: PersistenceController.preview.container.viewContext, addTopicsService: AddTopicsService(viewContext: PersistenceController.preview.container.viewContext)))
        }
}
