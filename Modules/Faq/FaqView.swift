//
//  FaqView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 01/03/2024.
//

import SwiftUI
import Combine

struct FaqView: View {
    // MARK: - Properties
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var viewModel: FaqViewModel

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.topicsBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Read before using")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding()
    
                Text("This app provides English courses generated by ChatGPT. To use ChatGPT, you need to obtain an API key from your OpenAI Developers console. You can input the API key in this text field or find the variable called apiKey in the code. If you do not enter the API key, the app will work in hardcoded mode, allowing you to test the design of the SwiftUI screens.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding([.leading, .trailing])
                TextField(text: $viewModel.apiKeyText) {
                    Text("API key is empty now")
                }
                .foregroundColor(.white)
                .shadow(radius: 10)
                .font(.headline)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0.5), lineWidth: 5)
                            .shadow(radius: 10)
                    )
                .padding()
                
                Button {
                    viewModel.setApiKey()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 50)
                        .foregroundColor(Color.pink)
                        .overlay(
                            Text("Confirm Api key")
                                .font(.title2)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                        .padding([.leading, .bottom, .trailing])
                }
                .shadow(radius: 10)
            }
        }
        .overlay(
            Button(action: {
                coordinator.dismissSheet()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .fontWeight(.bold)
            })
            .padding(.top, 10)
            .padding(.trailing, 16)
            .foregroundColor(.white)
            , alignment: .topTrailing
        )
        .alert(isPresented: $viewModel.faqAlertPresented) {
            Alert(title: Text(viewModel.faqAlert.title), message: Text(viewModel.faqAlert.message)
                  , dismissButton: .default(Text(viewModel.faqAlert.button)))
        }
    }
}

final class ApiKeyTextPublisher: ObservableObject {
    @Published var apiKeyText: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setup()
    }
    
    private func setup() {
        $apiKeyText
            .sink(receiveValue: { _ in
                apiKey = self.apiKeyText
            })
            .store(in: &cancellables)
    }
}

#Preview {
    FaqView(viewModel: FaqViewModel())
}
