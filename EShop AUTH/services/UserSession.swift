//
//  UserSession.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 08.04.2024.
//

import Foundation

class UserSession: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var accessToken: String?

    init() {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "jsonwebtoken") {
            print("Token found: \(token)")
            self.accessToken = token
            self.isAuthenticated = true
            // Здесь можно добавить загрузку данных пользователя, если это необходимо
        } else {
            print("No token found")
            self.isAuthenticated = false
        }
    }
    
    // Метод для обновления статуса аутентификации при успешной авторизации
    func authenticateUser(accessToken: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(accessToken, forKey: "jsonwebtoken")
        self.accessToken = accessToken
        self.isAuthenticated = true
    }

    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "jsonwebtoken")
        self.accessToken = nil
        self.isAuthenticated = false
    }
}

