//
//  ExerciseDoneBuilder.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 11.02.2024.
//

import SwiftUI

final class ExerciseDoneBuilder: ScreenBuilder {
    public func build() -> AnyView {
        return initView()
    }

    private func initView() -> AnyView {
        return AnyView(ExerciseDoneView())
    }
}
