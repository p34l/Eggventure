//
//  LevelsView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct LevelsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var gameData: GameData
    @State private var selectedLevel: Int? = nil
    @State private var showingGameSettings = false
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    var body: some View {
        ZStack {
            Image("loading_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    NavigationHeader(
                        leftButton: NavigationButton(imageName: "back", action: { dismiss() })
                    )
                    Spacer()
                    CoinIndicator(totalCoins: userSettings.totalCoins)
                }

                Spacer()

                Text("CHANGE LEVEL")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                    .padding(.bottom, 40)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(1...9, id: \.self) { level in
                        LevelButton(
                            level: level,
                            isUnlocked: userSettings.isLevelUnlocked(level),
                            isSelected: selectedLevel == level
                        ) {
                            if userSettings.isLevelUnlocked(level) {
                                selectedLevel = level
                                showingGameSettings = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingGameSettings) {
            GameSettingsView(navigationPath: $navigationPath)
                .environmentObject(userSettings)
                .environmentObject(gameData)
        }
    }
}

struct LevelButton: View {
    let level: Int
    let isUnlocked: Bool
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image("photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .opacity(isUnlocked ? 1.0 : 0.3)
                    .grayscale(isUnlocked ? 0.0 : 1.0)
                
                Text("\(level)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isUnlocked ? .white : .gray)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
            }
        }
        .disabled(!isUnlocked)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

