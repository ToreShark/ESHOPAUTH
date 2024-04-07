//
//  User.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 07.04.2024.
//

import Foundation

struct ApiResponse: Decodable {
    let success: Bool
}

struct Order: Codable, Identifiable {
    var id: String // Или другой тип, который соответствует идентификатору в вашей базе данных
    // Другие поля заказа
}

// Определение модели пользователя
struct User: Codable, Identifiable {
    var id: String // В MongoDB _id используется как уникальный идентификатор
    var phone: String
    var name: String?
    var email: String?
    var address: String?
    var firstName: String?
    var lastName: String?
    var userName: String?
    var country: String?
    var city: String?
    var index: String?
    var lastSeenAt: Date?
    var tokens: [String]
    var orders: [Order]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case phone, name, email, address, firstName, lastName, userName, country, city, index, lastSeenAt, tokens, orders
    }
}
