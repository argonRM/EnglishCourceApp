//
//  ToBeExerciseView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject var viewModel: ExerciseViewModel
    @EnvironmentObject private var coordinator: Coordinator
   
    
    var body: some View {
        ZStack {
            ExercisesTabView(exercises: $viewModel.exercises)
                .alert(isPresented: $viewModel.isErrorOccurred) {
                    Alert(title: Text("Error"), message: Text( "Cannot download an exercise")
                          , dismissButton: .default(Text("Ok :(")))
                }
            
            ProcessingView(isVisible: viewModel.isProcessing)
        }
        .onAppear {
            viewModel.exercisesFinished = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    coordinator.present(fullScreenCover: .exerciseDone)
                }
            }
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
    }
}

//MARK: - Preview
struct ToBeExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(viewModel: ExerciseViewModel(topic: Topic(title: "To Be", subtitle: "Present Simple"), exerciseService: ExerciseService(networkManager: NetworkManager(), context: PersistenceController.preview.container.viewContext)))
    }
}
