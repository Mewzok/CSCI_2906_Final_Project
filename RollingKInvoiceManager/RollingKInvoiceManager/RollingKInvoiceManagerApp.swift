//
//  RollingKInvoiceManagerApp.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import SwiftUI
import Firebase

@main
struct RollingKInvoiceManagerApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
