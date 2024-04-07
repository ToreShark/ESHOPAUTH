//
//  File.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 07.04.2024.
//

import Foundation
struct PhoneNumberFormatter {
    func formatPhoneNumber(phoneNumber: String) -> String {
        let digits = phoneNumber.filter("0123456789+".contains)
        if digits.hasPrefix("+7") && digits.count <= 12 {
            var formattedString = "+"
            for (index, digit) in digits.dropFirst().enumerated() {
                formattedString.append(digit)
                if index == 0 || index == 3 || index == 6 || index == 8 {
                    formattedString.append(" ")
                }
            }
            return formattedString
        }
        return phoneNumber // Возвращаем входной номер, если он не соответствует формату
    }
}
