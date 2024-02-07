//
//  TopicsListViewCell.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02.02.2024.
//

import SwiftUI

struct TopicsListViewCell: View {
    @ObservedObject var topic: Topic
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cellColor)
                .frame(minHeight: 80)
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(topic.subtitle)
                        .font(Font.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(topic.subtitleColor)
                        .multilineTextAlignment(.leading)
                        .italic()
                    Text(topic.title)
                        .font(.title2)
                        .fontWeight(.heavy)
                }
                .padding(.leading, 15)
                .padding([.top, .bottom], 3)
                
                Spacer()
                
                VStack {
                    printTopic(topic: topic)
                    Image(systemName: topic.status.image)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(topic.statusColor)
                    Text(topic.status.title)
                        .font(.footnote)
                        .foregroundColor(topic.statusColor)
                }
                .padding(.trailing, 15)
                Image(systemName: "")
            }
            
        }
        .listRowBackground(Color.topicsBackground)
        .listRowSeparator(.hidden)
    }
    
    func printTopic(topic: Topic) -> EmptyView {
        print("\(topic.subtitle) \(topic.title) \(topic.status)")
        return EmptyView()
    }
}

struct TopicsListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        TopicsListViewCell(topic: Topic())
    }
}
