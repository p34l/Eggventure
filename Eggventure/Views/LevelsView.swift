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
    @State private var showingGame = false
    @Environment(\.dismiss) private var dismiss
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    var body: some View {
        ZStack {
            // TODO: Замінити на фон з assets
            // Image("назва_фону_з_assets")
            //     .resizable()
            //     .aspectRatio(contentMode: .fill)
            //     .ignoresSafeArea()
            
            // Градієнтний фон (замінити на assets)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 1.0),
                    Color(red: 0.1, green: 0.4, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Заголовок
                Text("LEVELS")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                    .padding(.top, 20)
                
                // Сітка рівнів
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(1...9, id: \.self) { level in
                        LevelButton(
                            level: level,
                            isUnlocked: userSettings.isLevelUnlocked(level),
                            stars: getStarsForLevel(level),
                            isSelected: selectedLevel == level
                        ) {
                            if userSettings.isLevelUnlocked(level) {
                                selectedLevel = level
                                showingGame = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Кнопка повернення
                Button(action: {
                    dismiss()
                }) {
                    Text("BACK TO MENU")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white.opacity(0.4), lineWidth: 2)
                                )
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingGame) {
            GameView()
                .environmentObject(userSettings)
        }
    }
    
    private func getStarsForLevel(_ level: Int) -> Int {
        // Повертаємо кількість зірок для рівня (0-3)
        return Int.random(in: 0...3)
    }
}

struct LevelButton: View {
    let level: Int
    let isUnlocked: Bool
    let stars: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if isUnlocked {
                    // Розблокований рівень
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.5), lineWidth: 2)
                            )
                        
                        Text("\(level)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Зірки (яйця)
                    HStack(spacing: 2) {
                        ForEach(0..<3) { starIndex in
                            // TODO: Замінити на яйце з assets
                            // Image("назва_яйця_з_assets")
                            //     .resizable()
                            //     .aspectRatio(contentMode: .fit)
                            //     .frame(width: 12, height: 12)
                            //     .opacity(starIndex < stars ? 1.0 : 0.3)
                            
                            Image(systemName: starIndex < stars ? "star.fill" : "star")
                                .foregroundColor(starIndex < stars ? .yellow : .white.opacity(0.3))
                                .font(.system(size: 12))
                        }
                    }
                } else {
                    // Заблокований рівень
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.2), lineWidth: 2)
                            )
                        
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 20))
                    }
                    
                    Text("Locked")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .disabled(!isUnlocked)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    LevelsView()
        .environmentObject(UserSettings())
        .environmentObject(GameData())
}
