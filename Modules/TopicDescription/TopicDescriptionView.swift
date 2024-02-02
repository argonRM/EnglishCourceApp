//
//  TopicDescriptionView.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import SwiftUI

struct TopicDescriptionView: View {
    var body: some View {
        VStack {
            Text("TopicDescriptionView")
            
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 200, height: 50)
                    .foregroundColor(Color.pink)
                    .overlay(
                        Text("Start Exercise")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
                    
            }

        }
        
    }
}

struct TopicDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        TopicDescriptionView()
    }
}
