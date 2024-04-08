//
//  Welcome.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 08.04.2024.
//

import SwiftUI

struct Welcome: View {
    @EnvironmentObject var userSession: UserSession
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
                
                Button("Выйти") {
                    userSession.logout()
                    
                    // Здесь предполагается, что изменение состояния isAuthenticated
                    // в userSession вызовет перерисовку родительского вида и
                    // произойдет перенаправление на LoginView
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(5)
            }
        }
    }
}

#Preview {
    Welcome().environmentObject(UserSession())
}
