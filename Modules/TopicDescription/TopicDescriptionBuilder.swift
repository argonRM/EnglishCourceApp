//
//  TopicDescriptionBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 04.02.2024.
//

import Foundation

import SwiftUI

class TopicDescriptionBuilder: ScreenBuilder {
    public func build() -> AnyView {
        return initView()
    }

    private func initView() -> AnyView {
        let view = TopicDescriptionView()
        
        return AnyView(view)
    }
}
