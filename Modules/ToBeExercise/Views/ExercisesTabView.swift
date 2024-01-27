//
//  ExercisesTabView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 23.01.2024.
//

import SwiftUI

struct ExercisesTabView: View {
    // MARK: - Properties
    @Binding var exercises: [ToBeExerciseDataFlow.ToBeExercise]
    
    // MARK: - Body
    var body: some View {
        TabView {
            ForEach($exercises) { exercise in
                ZStack {
                    ExerciseView(exercise: exercise)
                }
            }
        }
        .tabViewStyle(.page)
        .background(
            Color(.black)
                .opacity(0.2)
        )
    }
}

// MARK: - Preview
struct ExercisesTabView_Previews: PreviewProvider {
    @State static var exercises: [ToBeExerciseDataFlow.ToBeExercise] = [ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                                                                        ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                                                                        ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])]
    static var previews: some View {
        ExercisesTabView(exercises: $exercises)
    }
}
