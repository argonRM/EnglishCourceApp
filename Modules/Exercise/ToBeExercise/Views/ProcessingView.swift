//
//  ProcessingView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 23.01.2024.
//

import SwiftUI

// MARK: - ProcessingView
struct ProcessingView: View {
    @State private var processingAnimation = false
    @Binding var isVisible: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(isVisible ? 0.6 : 0)
                .ignoresSafeArea()
                .blur(radius: processingAnimation ? 300 : 100, opaque: false)
                .scaleEffect(processingAnimation ? 1 : 2)
            
            VStack {
                Spacer()
                ActivityIndicatorView(style: .medium, color: .white)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(width: 100)
                    .scaleEffect(2)
                Spacer()
            }
            .cornerRadius(10)
            .padding()
        }
        .onAppear {
            withAnimation(.easeIn(duration: 2).repeatForever(autoreverses: true)) {
                processingAnimation.toggle()
            }
        }
        .opacity(isVisible ? 1 : 0)
        .animation(.easeOut(duration: 1), value: isVisible)
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
        ProcessingView(isVisible: $isVisible)
    }
}
