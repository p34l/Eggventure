//
//  ContentView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var gameData = GameData()
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isLoading = false
                            }
                        }
                    }
            } else {
                MenuView()
                    .environmentObject(userSettings)
                    .environmentObject(gameData)
            }
        }
    }
}

