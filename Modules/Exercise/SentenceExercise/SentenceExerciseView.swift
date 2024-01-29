//
//  SentenceExerciseView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 23.01.2024.
//

import SwiftUI
import UIKit

struct SentenceExerciseView: View {
    // MARK: - Properties
    @StateObject var viewModel: SentenceExerciseViewModel
    
    // MARK: - Body
    var body: some View {
            VStack {
                Spacer()
                FlowLayout(spacing: 12, alignment: .center) {
                    ForEach(viewModel.exercise.partsOfSentence, id: \.self) { string in
                        if string == "_" {
                            ZStack {
                                Capsule()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 80 ,height: 40)
                                Capsule()
                                    .stroke(.gray, lineWidth: 4)
                                    .frame(width: 80, height: 40)
                            }
                            .scaleEffect(viewModel.isGapAnimating ? 1.1 : 1)
                        } else {
                            Text(string)
                                .italic()
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(4)
                        }
                    }
                }
                .padding()
                .onAppear {
                    withAnimation(.easeIn(duration: 0.8).repeatForever(autoreverses: true)) {
                        viewModel.isGapAnimating.toggle()
                    }
                }
                Spacer()
                
                ExerciseOptionsView(viewModel: viewModel)
                    .padding(.bottom, 40)
            }
            
            .background(
                Image("image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
    }
}

// MARK: - Preview
struct ExerciseView_Previews: PreviewProvider {
    @State static var exercise = ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])
    @ObservedObject static var viewModel = SentenceExerciseViewModel(exercise: exercise)
    
    static var previews: some View {
        SentenceExerciseView(viewModel: viewModel)
    }
}

struct StringWidthPreferenceKey: PreferenceKey {
    static var defaultValue: [CGFloat] = []

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}


extension AnyTransition {
    static var top: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .identity,
            removal: AnyTransition.move(edge: .top)
        )
    }
}
