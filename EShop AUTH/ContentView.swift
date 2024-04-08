//
//  ContentView.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 07.04.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        if userSession.isAuthenticated {
            Welcome()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
