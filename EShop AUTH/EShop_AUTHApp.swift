//
//  EShop_AUTHApp.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 07.04.2024.
//

import SwiftUI

@main
struct EShop_AUTHApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserSession())
        }
    }
}
