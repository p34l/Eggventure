//
//  MenuView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var gameData: GameData
    @State private var isAnimating = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Фон з assets
                Image("loading_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Верхня частина з кнопками
                    HStack {
                        // Кнопка info зліва
                        Button(action: {
                            navigationPath.append("howtoplay")
                        }) {
                            Image("info")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                        .padding(.top, 20)
                        .padding(.leading, 40)

                        Spacer()

                        // Кнопка menu справа
                        Button(action: {
                            navigationPath.append("more")
                        }) {
                            Image("more")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 40)
                    }

                    Spacer()

                    // Персонаж hero по центру
                    Image("hero")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 450, height: 450)
                        .onAppear {
                            isAnimating = true
                        }

                    Spacer()

                    // Кнопка PLAY знизу по центру
                    Button(action: {
                        navigationPath.append("levels")
                    }) {
                        ZStack {
                            // Фон кнопки
                            Image("func_button_background")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 80)

                            // Текст кнопки (картинка play)
                            Image("play")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "levels":
                    LevelsView()
                        .environmentObject(userSettings)
                        .environmentObject(gameData)
                case "howtoplay":
                    HowToPlayView(navigationPath: $navigationPath)
                case "more":
                    MoreView(navigationPath: $navigationPath)
                        .environmentObject(userSettings)
                        .environmentObject(gameData)
                case "profile":
                    ProfileView()
                        .environmentObject(userSettings)
                case "settings":
                    SettingsView()
                        .environmentObject(userSettings)
                case "leaderboard":
                    LeaderboardView()
                        .environmentObject(userSettings)
                        .environmentObject(gameData)
                case "policy":
                    PolicyView()
                case "terms":
                    TermsView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    MenuView()
        .environmentObject(UserSettings())
        .environmentObject(GameData())
}
