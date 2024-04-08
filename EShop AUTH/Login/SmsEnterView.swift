//
//  SmsEnterView.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 07.04.2024.
//

import SwiftUI

struct SmsEnterView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var enteredCode: String = ""
    
    var body: some View {
        VStack {
            TextField("Введите код из SMS", text: $enteredCode)
                .keyboardType(.numberPad)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            Button(action: {
                self.validateCode()
            }) {
                Text("Подтвердить")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
        }
        .padding()
    }
    private func validateCode() {
        let phoneNumber = userSession.phoneNumber
        ValidationService.validateCode(phoneNumber: phoneNumber, code: enteredCode) { result in
            switch result {
            case .success(let validationResponse):
                print("Код соответствует, получен токен: \(validationResponse.accessToken)")
                DispatchQueue.main.async {
                    print("tested many times")
                    self.userSession.authenticateUser(accessToken: validationResponse.accessToken)
                }
            case .failure(let error):
                print("Ошибка валидации: \(error.localizedDescription)")
            }
        }
    }
}
