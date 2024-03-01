//
//  ScrollDelegate.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 01/03/2024.
//

import UIKit
import SwiftUI
import Combine

struct ScrollFrame : Equatable {
    let id : String
    let frame : CGRect

    static func == (lhs: ScrollFrame, rhs: ScrollFrame) -> Bool {
        lhs.id == rhs.id && lhs.frame == rhs.frame
    }
}

struct ScrollKey : PreferenceKey {
    typealias Value = [ScrollFrame] // The list of view frame changes in a View tree.

    static var defaultValue: [ScrollFrame] = []

    /// When traversing the view tree, Swift UI will use this function to collect all view frame changes.
    static func reduce(value: inout [ScrollFrame], nextValue: () -> [ScrollFrame]) {
        value.append(contentsOf: nextValue())
    }
}
