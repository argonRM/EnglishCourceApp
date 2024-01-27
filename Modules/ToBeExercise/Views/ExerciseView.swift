//
//  ExerciseView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 23.01.2024.
//

import SwiftUI
import UIKit

struct ExerciseView: View {
    // MARK: - Properties
    @Binding var exercise: ToBeExerciseDataFlow.ToBeExercise
    @State var isGapAnimating: Bool = false
    @State var isBadAnswerAnimating: Bool = false
    @State var isRightAnswerMoveAnimating: Bool = false
    @State var isRightAnswerHideAnimating: Bool = false
    @State var isBadAnswerAnimatingYValue: CGFloat = -5
    var dragAreaThreshold: CGFloat = 65
    @State var answer = ""
    
    // MARK: - Body
    var body: some View {
            VStack {
                Spacer()
                FlowLayout(spacing: 12, alignment: .center) {
                    ForEach(exercise.partsOfSentence, id: \.self) { string in
                        if string == "_" {
                            ZStack {
                                Capsule()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 80 ,height: 40)
                                Capsule()
                                    .stroke(.gray, lineWidth: 4)
                                    .frame(width: 80, height: 40)
                            }
                            .scaleEffect(isGapAnimating ? 1.1 : 1)
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
                        isGapAnimating.toggle()
                    }
                }
                Spacer()
                
                FlowLayout(spacing: 12, alignment: .center) {
                    ForEach(exercise.options, id: \.self) { string in
                        Button {
                            
                            self.answer = string
                            if !checkRightAnswer(answer: string) {
                                
                                withAnimation {
                                    isBadAnswerAnimating = true
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.6).repeatCount(5, autoreverses: true)) {
                                    
                                    self.isBadAnswerAnimatingYValue = -self.isBadAnswerAnimatingYValue
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            isBadAnswerAnimating = false
                                        }
                                    }
                                }
                            } else {
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
                                .background(
                                    ZStack {
                                        Capsule()
                                            .fill((isBadAnswerAnimating && self.answer == string) ? Color.red.opacity(0.5) : Color.gray.opacity(0.5))
                                        Capsule()
                                            .stroke(.gray, lineWidth: 4)
                                    }
                                )
                                .offset(x: answerOffset(string).x, y: answerOffset(string).y)
                                .opacity(isRightAnswerHideAnimating ? 0 : 1)
                        }
                    }
                }
            }
            
            .background(
                Image("image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        
    }
        
}

private extension ExerciseView {
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
struct ExerciseView_Previews: PreviewProvider {
    @State static var exercise = ToBeExerciseDataFlow.ToBeExercise(sentence: "I _ am a boy.", partsOfSentence: ["I", "_", "a", "good", "little", "boy."],  validOption: "am", options: ["am", "is", "it", "does"])
    
    static var previews: some View {
        ExerciseView(exercise: $exercise)
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
