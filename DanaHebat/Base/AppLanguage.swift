//
//  AppLanguage.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import Foundation

enum AppLanguage: Int {
    case english = 1
    case indonesian = 2
    
    var localeCode: String {
        switch self {
        case .english: return "en"
        case .indonesian: return "id"
        }
    }
}

class LanguageManager {
    
    static let shared = LanguageManager()
    
    private let languageKey = "AppLanguageKey"
    
    private(set) var currentLanguage: AppLanguage = .english
    
    private var currentBundle: Bundle?
    
    private init() {
        loadSavedLanguage()
        setupBundle()
    }
    
    func setLanguage(code: Int) {
        guard let language = AppLanguage(rawValue: code) else {
            return
        }
        
        currentLanguage = language
        saveLanguage()
        setupBundle()
    }
    
    func localizedString(for key: String) -> String {
        if let bundle = currentBundle {
            return bundle.localizedString(forKey: key, value: key, table: nil)
        }
        
        return Bundle.main.localizedString(forKey: key, value: key, table: nil)
    }
    
    static func localizedString(for key: String) -> String {
        return shared.localizedString(for: key)
    }
    
    func isEnglish() -> Bool {
        return currentLanguage == .english
    }
    
    func isIndonesian() -> Bool {
        return currentLanguage == .indonesian
    }
    
    func getCurrentLanguageCode() -> Int {
        return currentLanguage.rawValue
    }
    
    func getCurrentLocaleCode() -> String {
        return currentLanguage.localeCode
    }
    
    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
    }
    
    private func loadSavedLanguage() {
        if let savedCode = UserDefaults.standard.object(forKey: languageKey) as? Int,
           let language = AppLanguage(rawValue: savedCode) {
            currentLanguage = language
        }
    }
    
    private func setupBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage.localeCode,
                                          ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            currentBundle = nil
            return
        }
        currentBundle = bundle
    }
}
