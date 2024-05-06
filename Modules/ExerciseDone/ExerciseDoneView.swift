//
//  ExerciseDoneView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 11.02.2024.
//

import SwiftUI

struct ExerciseDoneView: View {
    // MARK: - Properties
    @State private var isAnimation = false
    @EnvironmentObject private var coordinator: Coordinator
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.topicsBackground
                .ignoresSafeArea()
            
            VStack {
                Text("You've successfully finished the topic")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding()
                Image("firecrackerImage")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .scaleEffect(isAnimation ? 1.1 : 0.9)
                    .rotationEffect(.degrees(isAnimation ? -10 : 10))
                    .padding(40)
                    .onAppear(perform: {
                        withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(5, autoreverses: true)) {
                            isAnimation = true
                        }
                    })
            }
        }
        .overlay(
            Button(action: {
                coordinator.dismissFullScreenCover()
                coordinator.popToRoot()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .fontWeight(.bold)
            })
            .padding(.top, 10)
            .padding(.trailing, 16)
            .foregroundColor(.white)
            , alignment: .topTrailing
        )
        
    }
}

#Preview {
    ExerciseDoneView()
}
