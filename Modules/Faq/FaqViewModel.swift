//
//  FaqViewModel.swift
//  EnglishCourse
//
//  Created by Roman Maiboroda on 02/03/2024.
//

import Foundation
import Combine

final class FaqViewModel: ObservableObject {
    @Published var apiKeyText: String = ""
    @Published var faqAlertPresented = false
    var faqAlert: FaqAlert = .none
        
    init() {
        self.apiKeyText = apiKey
    }
    
    func setApiKey() {
        guard !apiKeyText.isEmpty else {
            faqAlert = .emptyKeyAlert
            faqAlertPresented = true
            return
        }
        
        guard apiKeyText != apiKey else {
            faqAlert = .theSameKeyAlert
            faqAlertPresented = true
            return
        }
        
        apiKey = apiKeyText
        UserDefaults.standard.setValue(apiKeyText, forKey: UserDefaultsKeys.apiKey)
    }
}

extension FaqViewModel {
    enum FaqAlert {
        case none
        case emptyKeyAlert
        case theSameKeyAlert
        
        var message: String {
            switch self {
            case .none:
                ""
            case .emptyKeyAlert:
                "The API key is empty."
            case .theSameKeyAlert:
                "You already use the same API key."
            }
        }
        
        var title: String {
            "Cannot save"
        }
        
        var button: String {
            "Ok"
        }
    }
}
