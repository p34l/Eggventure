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
                Image("loading_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
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

                    Image("hero")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 450, height: 450)
                        .onAppear {
                            isAnimating = true
                        }

                    Spacer()

                    Button(action: {
                        navigationPath.append("shop")
                    }) {
                        ZStack {
                            Image("func_button_background")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 80)

                            Text("SHOP")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
                        }
                    }
                    .padding(.bottom, 20)

                    Button(action: {
                        navigationPath.append("levels")
                    }) {
                        ZStack {
                            Image("func_button_background")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 80)

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
                    LevelsView(navigationPath: $navigationPath)
                        .environmentObject(userSettings)
                        .environmentObject(gameData)
                case "howtoplay":
                    HowToPlayView(navigationPath: $navigationPath)
                case "more":
                    MoreView(navigationPath: $navigationPath)
                        .environmentObject(userSettings)
                        .environmentObject(gameData)
                case "profile":
                    ProfileView(navigationPath: $navigationPath)
                        .environmentObject(userSettings)
                case "settings":
                    SettingsView(navigationPath: $navigationPath)
                        .environmentObject(userSettings)
                case "leaderboard":
                    LeaderboardView()
                        .environmentObject(userSettings)
                        .environmentObject(gameData)
                case "policy":
                    PolicyView()
                case "terms":
                    TermsView()
                case "shop":
                    ShopView(navigationPath: $navigationPath)
                        .environmentObject(userSettings)
                        .environmentObject(gameData)
                default:
                    EmptyView()
                }
            }
        }
    }
}
