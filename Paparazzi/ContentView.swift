//
//  ContentView.swift
//  Paparazzi
//
//  Created by Thomas Baldonado on 5/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    // Replace this with your OpenAI API key that starts with "sk-"
    let apiKey = "MY-API-KEY-WENT-HERE"
    
    var body: some View {
        TabView {
            HomeView(apiKey: apiKey, modelContext: modelContext)
                .tabItem {
                    Label("Generate", systemImage: "quote.bubble")
                }
            
            QuotesListView(apiKey: apiKey)
                .tabItem {
                    Label("Quotes", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView()
}
