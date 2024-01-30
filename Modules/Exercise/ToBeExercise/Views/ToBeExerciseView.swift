//
//  ToBeExerciseView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

struct ToBeExerciseView: View {
    @StateObject var viewModel: ToBeExerciseViewModel
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

private extension ToBeExerciseView {
   
}

// MARK: - Preview
struct ToBeExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ToBeExerciseView(viewModel: ToBeExerciseViewModel(networkManager: NetworkManager()))
    }
}
