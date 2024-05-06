//
//  ProcessingView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 23.01.2024.
//

import SwiftUI

struct ProcessingView: View {
    // MARK: - Properties
    @State private var processingAnimation = false
    var isVisible: Bool
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if isVisible {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .blur(radius: processingAnimation ? 300 : 100, opaque: false)
                        .scaleEffect(processingAnimation ? 1 : 2)
                    
                    ActivityIndicatorView(style: .medium, color: .white)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .scaleEffect(2)
                        .padding()
                }
                .animation(.easeIn(duration: 2).repeatForever(autoreverses: true), value: processingAnimation)
                .transition(.opacity)
            }
        }
        .animation(.default, value: isVisible)
    }
}

// MARK: - ActivityIndicatorView
private extension ProcessingView {
    struct ActivityIndicatorView: UIViewRepresentable {
        let style: UIActivityIndicatorView.Style
        let color: Color
        
        func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
            UIActivityIndicatorView(style: style)
        }
        
        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
            uiView.color = UIColor(color)
            uiView.startAnimating()
        }
    }
}

// MARK: - Preview
struct Processing_Previews: PreviewProvider {
    @State static var isVisible = true
    static var previews: some View {
        ProcessingView(isVisible: isVisible)
    }
}
