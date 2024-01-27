//
//  ToBeExerciseView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

// MARK: - ToBeExerciseView
struct ToBeExerciseView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: ToBeExerciseViewModel
    @State private var processingAnimation = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            ExercisesTabView(exercises: $viewModel.exercises)
                .alert(isPresented: $viewModel.isErrorOccurred) {
                    Alert(title: Text("Error"), message: Text( "Cannot download an exercise")
                          , dismissButton: .default(Text("Ok:(")))
                }
                .onAppear {
                    viewModel.getExercise()
                }
            ProcessingView(isVisible: $viewModel.isProcessing)
        }
    }
}

private extension ToBeExerciseView {
   
}

// MARK: - Preview
struct ToBeExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ToBeExerciseView(viewModel: ToBeExerciseViewModel(networkManager: NetworkManager()))
    }
}
