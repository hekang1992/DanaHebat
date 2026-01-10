//
//  UserDataManager.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import Foundation

class UserDataManager {
    static let shared = UserDataManager()
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let phone = "user_phone"
        static let token = "user_token"
        static let cphone = "user_c_phone"
    }
    
    static func savePhone(_ phone: String) {
        shared.userDefaults.set(phone, forKey: Keys.phone)
        shared.userDefaults.synchronize()
    }
    
    static func saveToken(_ token: String) {
        shared.userDefaults.set(token, forKey: Keys.token)
        shared.userDefaults.synchronize()
    }
    
    static func getPhone() -> String? {
        return shared.userDefaults.string(forKey: Keys.phone)
    }
    
    static func getToken() -> String? {
        return shared.userDefaults.string(forKey: Keys.token)
    }
    
    static func saveUserData(phone: String, token: String) {
        savePhone(phone)
        saveToken(token)
    }
    
    static func clearAllUserData() {
        shared.userDefaults.removeObject(forKey: Keys.cphone)
        shared.userDefaults.removeObject(forKey: Keys.phone)
        shared.userDefaults.removeObject(forKey: Keys.token)
        shared.userDefaults.synchronize()
    }
    
    static func isLoggedIn() -> Bool {
        return getToken() != nil
    }
}
