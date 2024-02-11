//
//  EnglishCourseApp.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 22.01.2024.
//

import SwiftUI

@main
struct EnglishCourseApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
    }
}
