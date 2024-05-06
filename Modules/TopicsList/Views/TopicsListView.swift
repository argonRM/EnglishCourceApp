//
//  TopicsListView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import SwiftUI

struct TopicsListView: View {
    // MARK: - Properties
    @StateObject var viewModel: TopicsListViewModel
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showFaqButton = true
    @State var scrollFrame: ScrollFrame?

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            List {
                ForEach(viewModel.topics) { topic in
                    printTopic(topic: topic)
                    TopicsListViewCell(topic: topic)
                        .onTapGesture {
                            coordinator.push(.topicDescription, topic: topic)
                        }
                        .transformAnchorPreference(key: ScrollKey.self, value: .bounds) {
                            $0.append(ScrollFrame(id: topic.id, frame: geometry[$1]))
                            if scrollFrame == nil {
                                scrollFrame = ScrollFrame(id: topic.id, frame: geometry[$1])
                            }
                        }
                        .onPreferenceChange(ScrollKey.self) {
                            let frame = $0.first { $0.id == scrollFrame?.id }
                            if frame == nil || frame?.frame == scrollFrame?.frame  {
                                showFaqButton = true
                            } else {
                                showFaqButton = false
                            }
                        }
                }
            }
            .listStyle(.plain)
            .background(Color.topicsBackground)
            .safeAreaInset(edge: .top, alignment: .trailing, content: {
                Button(action: {
                    coordinator.present(sheet: .faqScreen)
                }, label: {
                    Image(systemName: "questionmark.circle")
                        .font(.title)
                        .fontWeight(.bold)
                })
                .padding(.top, 10)
                .padding(.trailing, 16)
                .foregroundColor(.white)
                .opacity(!showFaqButton ? 0 : 1)
                .shadow(radius: 2)
            })
            .animation(.easeIn, value: showFaqButton)
        }
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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}
