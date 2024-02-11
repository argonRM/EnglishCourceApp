//
//  ExercisesTabView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 23.01.2024.
//

import SwiftUI

struct ExercisesTabView: View {
    // MARK: - Properties
    @Binding var exercises: [ToBeExercise]
    
    // MARK: - Body
    var body: some View {
        TabView {
            ForEach($exercises) { exercise in
                SentenceExerciseView(exercise: exercise)
                    .tag(exercise.id)
            }
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
        .background(
            Color.clear
        )
    }
}

// MARK: - Preview
struct ExercisesTabView_Previews: PreviewProvider {
    @State static var exercises: [ToBeExercise] = [ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                                                                        ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"]),
                                                                        ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])]
    static var previews: some View {
        ExercisesTabView(exercises: $exercises)
    }
}
