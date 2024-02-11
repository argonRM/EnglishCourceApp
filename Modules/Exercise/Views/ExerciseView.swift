//
//  ToBeExerciseView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

struct ExerciseView<ExerciseService: ExerciseServiceProtocol>: View {
    @StateObject var viewModel: ExerciseViewModel<ExerciseService>
    @State private var processingAnimation = false
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
                coordinator.popToRoot()
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
        ExerciseView(viewModel: ExerciseViewModel(exerciseService: ToBeExerciseService(networkManager: NetworkManager(), context: PersistenceController.preview.container.viewContext)))
    }
}
