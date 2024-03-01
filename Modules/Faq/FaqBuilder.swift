//
//  FaqBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 01/03/2024.
//

import SwiftUI

class FaqBuilder: ScreenBuilder {
    public func build() -> AnyView {
        return initView()
    }

    private func initView() -> AnyView {
        return AnyView(FaqView())
    }
}
