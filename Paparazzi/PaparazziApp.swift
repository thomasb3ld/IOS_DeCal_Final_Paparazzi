//
//  PaparazziApp.swift
//  Paparazzi
//
//  Created by Thomas Baldonado on 5/1/25.
//

import SwiftUI
import SwiftData

@main
struct PaparazziApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Quote.self)
    }
}
