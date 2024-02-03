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
    
   
    
    var body: some View {
        ZStack {
            if viewModel.isAllDone {
                Color.red.ignoresSafeArea()
            } else {
                ExercisesTabView(exercises: $viewModel.exercises)
                    .alert(isPresented: $viewModel.isErrorOccurred) {
                        Alert(title: Text("Error"), message: Text( "Cannot download an exercise")
                              , dismissButton: .default(Text("Ok:(")))
                    }
            }
            
            ProcessingView(isVisible: viewModel.isProcessing)
        }
    }
}

//MARK: - Preview
struct ToBeExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(viewModel: ExerciseViewModel(exerciseService: ToBeExerciseService(networkManager: NetworkManager())))
    }
}
