//
//  TopicLessonView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import SwiftUI

struct TopicLessonView: View {
    // MARK: - Properties
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var viewModel: TopicLessonViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.topic.subtitle)
                                .font(Font.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .italic()
                                .shadow(radius: 10)
                            Text(viewModel.topic.title)
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                        }
                        .padding()
                        Spacer()
                    }
                    
                    Text(viewModel.topic.description)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing])
                        .shadow(radius: 10)
                }
                
                Button {
                    coordinator.push(.exercise, topic: viewModel.topic)
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 50)
                        .foregroundColor(Color.pink)
                        .overlay(
                            Text("Start Exercise")
                                .font(.title2)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                        .padding([.leading, .bottom, .trailing])
                }
                .shadow(radius: 10)
            }
            .background(
                ZStack {
                    Image("boardImage")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                }
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.regenerateTopicDescription()
                    }, label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    })
                    .shadow(radius: 10)
                }//: toolbar buttons
            }//: toolbar
            
            ProcessingView(isVisible: viewModel.isProcessing)
        }
        .alert(isPresented: $viewModel.isErrorOccurred) {
            Alert(title: Text("Error"), message: Text( "Cannot download a lesson")
                  , dismissButton: .default(Text("Ok :(")))
        }
    }
}

struct TopicDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        TopicLessonView(viewModel: getViewModel())
    }
    
    static func getViewModel() -> TopicLessonViewModel {
        let viewModel = TopicLessonViewModel(topic: Topic(title: "ToBe", subtitle: "Present Simple"), topicLessonService: TopicLessonService(networkManager: NetworkManager(), context: PersistenceController.preview.container.viewContext))

        return viewModel
    }
}
