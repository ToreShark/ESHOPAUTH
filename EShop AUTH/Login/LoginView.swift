//
//  LoginView.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 07.04.2024.
//

import SwiftUI

class UserSession: ObservableObject {
    @Published var phoneNumber: String = ""
}

struct LoginView: View {
    @State private var phoneNumber: String = "+7"
    @State private var formattedPhoneNumber: String = "+7"
    private var formatter = PhoneNumberFormatter()
    @State private var navigateToSmsEnter = false
    @StateObject var userSession = UserSession()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Введите номер телефона", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                    .onReceive(phoneNumber.publisher.collect()) {
                        let phoneString = String($0)
                        formattedPhoneNumber = formatter.formatPhoneNumber(phoneNumber: phoneString)
                        // Если вы хотите сохранить форматирование но убрать маску, используйте другую логику здесь
                    }
                
                Button(action: {
                    print("Введённый номер: \(phoneNumber)")
                    userSession.phoneNumber = phoneNumber
                    LoginService.signup(phoneNumber: phoneNumber) { result in
                        switch result {
                        case .success(let response):
                            print("Успех: \(response)")
                            navigateToSmsEnter = true
                            // Обработка успешного ответа
                        case .failure(let error):
                            print("Ошибка: \(error)")
                            
                            // Обработка ошибки
                        }
                    }
                }) {
                    Text("Получить код")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5)
                }
            }
            .padding()
            .navigationDestination(isPresented: $navigateToSmsEnter) { // Используем navigationDestination
                SmsEnterView(userSession: userSession) // Передаем userSession в SmsEnterView
            }
        }
        
    }
}
