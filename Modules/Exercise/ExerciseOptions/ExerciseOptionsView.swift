//
//  ExerciseOptionsView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 27.01.2024.
//

import SwiftUI

struct ExerciseOptionsView<ExerciseOptionsViewModel: ExerciseOptionsViewModelProtocol>: View {
    @ObservedObject var viewModel: ExerciseOptionsViewModel
  
    var body: some View {
        FlowLayout(spacing: 12, alignment: .center) {
            ForEach(viewModel.exercise.options, id: \.self) { string in
                Button {
                    
                    viewModel.answer = string
                    if !viewModel.checkRightAnswer(answer: string) {
                        withAnimation {
                            viewModel.isBadAnswerAnimating = true
                        }
                        
                        withAnimation(Animation.easeInOut(duration: 0.6).repeatCount(5, autoreverses: true)) {
                            
                            viewModel.isBadAnswerAnimatingYValue = -viewModel.isBadAnswerAnimatingYValue
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    viewModel.isBadAnswerAnimating = false
                                }
                            }
                        }
                    } else {
                        viewModel.setupExerciseDone()
                        withAnimation(.easeOut(duration: 2)) {
                            viewModel.isRightAnswerMoveAnimating = true
                        }
                        
                        withAnimation(.easeOut(duration: 1)) {
                            viewModel.isRightAnswerHideAnimating = true
                        }
                        
                    }
                    
                } label: {
                    Text(string)
                        .italic()
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], 20)
                        .background(
                            ZStack {
                                Capsule()
                                    .fill(viewModel.getCapsuleFill(optionValue: string))
                                
                                Capsule()
                                    .stroke(.gray, lineWidth: 4)
                            }
                        )
                        .offset(x: viewModel.answerOffset(string).x, y: viewModel.answerOffset(string).y)
                        .opacity(viewModel.isRightAnswerHideAnimating ? 0 : 1)
                }
            }
        }
    }
}

struct ExerciseOptionsView_Previews: PreviewProvider {
    @State static var exercise = ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])
    @ObservedObject static var viewModel = SentenceExerciseViewModel(exercise: exercise)
    
    
    static var previews: some View {
        ExerciseOptionsView(viewModel: viewModel)
    }
}
