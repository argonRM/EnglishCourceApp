//
//  ExerciseOptionsView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 27.01.2024.
//

import SwiftUI

struct ExerciseOptionsView: View {
    // MARK: - Properties
    @Binding var exercise: ToBeExercise
    @State private var isBadAnswerAnimating: Bool = false
    @State private var isRightAnswerMoveAnimating: Bool = false
    @State private var isRightAnswerHideAnimating: Bool = false
    @State private var isBadAnswerAnimatingYValue: CGFloat = -5
    @State private var answer = ""
  
    // MARK: - Body
    var body: some View {
        FlowLayout(spacing: 12, alignment: .center) {
            ForEach(exercise.options, id: \.self) { string in
                Button {
                    
                    answer = string
                    if !checkRightAnswer(answer: string) {
                        withAnimation {
                            isBadAnswerAnimating = true
                        }
                        
                        withAnimation(Animation.easeInOut(duration: 0.6).repeatCount(5, autoreverses: true)) {
                            
                            isBadAnswerAnimatingYValue = -isBadAnswerAnimatingYValue
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    isBadAnswerAnimating = false
                                }
                            }
                        }
                    } else {
                        setupExerciseDone()
                        withAnimation(.easeOut(duration: 2)) {
                            isRightAnswerMoveAnimating = true
                        }
                        
                        withAnimation(.easeOut(duration: 1)) {
                            isRightAnswerHideAnimating = true
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
                        .shadow(radius: 5)
                        .background(
                            ZStack {
                                Capsule()
                                    .fill(getCapsuleFill(optionValue: string))
                                
                                Capsule()
                                    .stroke(.white.opacity(0.5), lineWidth: 4)
                            }
                        )
                        .offset(x: answerOffset(string).x, y: answerOffset(string).y)
                        .opacity(isRightAnswerHideAnimating ? 0 : 1)
                }
            }
        }
    }
}

// MARK: - Private
private extension ExerciseOptionsView {
    
    func setupExerciseDone() {
        exercise.isDone = true
    }
    
    func getCapsuleFill(optionValue: String) -> some ShapeStyle {
        (isBadAnswerAnimating && self.answer == optionValue) ? Color.red.opacity(0.9) : Color.white.opacity(0.15)
    }
    
    func checkRightAnswer(answer: String) -> Bool {
        answer == exercise.validOption
    }
    
    func answerOffset(_ answer: String) -> (x: CGFloat, y: CGFloat) {
        let y: CGFloat
        if isBadAnswerAnimating {
            y = (isBadAnswerAnimating && self.answer == answer) ? isBadAnswerAnimatingYValue : 0
        } else {
            y = (isRightAnswerMoveAnimating && self.answer == answer) ? -100 : 0
        }
        
        let x = (isRightAnswerMoveAnimating && self.answer == answer) ? 0.0 : 0
        
        return (x: x, y: y)
    }
}

// MARK: - Preview
struct ExerciseOptionsView_Previews: PreviewProvider {
    @State static var exercise = ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])
    
    
    static var previews: some View {
        ExerciseOptionsView(exercise: $exercise)
    }
}
