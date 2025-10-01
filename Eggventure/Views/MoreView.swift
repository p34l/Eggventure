//
//  MoreView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var gameData: GameData
    @Binding var navigationPath: NavigationPath

    var body: some View {
        ZStack {
            // Фон такий самий як в HowToPlayView
            Image("loading_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Верхня частина з кнопкою назад та індикатором монеток
                HStack {
                    // Кнопка назад зліва
                    Button(action: {
                        if !navigationPath.isEmpty {
                            navigationPath.removeLast()
                        }
                    }) {
                        Image("back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    }
                    .padding(.top, 20)
                    .padding(.leading, 40)

                    Spacer()

                    // Індикатор монеток справа
                    ZStack {
                        // Asset with_coin з кількістю монеток
                        ZStack {
                            Image("with_coin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 40)

                            Text("\(userSettings.totalCoins)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
                                .offset(x: -8) // Зсуваємо текст лівіше
                        }

                        // Asset coin (справа в кінці індикатора)
                        Image("coin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .offset(x: 30) // Зсуваємо монетку ще правіше
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 40)
                }

                Spacer()

                // Фіолетовий прямокутник з кнопками
                VStack(spacing: 0) {
                    // 5 кнопок з assets
                    VStack(spacing: 20) {
                        // Кнопка Profile
                        MoreButton(
                            imageName: "profile",
                            action: {
                                navigationPath.append("profile")
                            }
                        )

                        // Кнопка Settings
                        MoreButton(
                            imageName: "settings",
                            action: {
                                navigationPath.append("settings")
                            }
                        )

                        // Кнопка Leaderboard
                        MoreButton(
                            imageName: "leaderboard",
                            action: {
                                navigationPath.append("leaderboard")
                            }
                        )

                        // Кнопка Policy
                        MoreButton(
                            imageName: "policy",
                            action: {
                                navigationPath.append("policy")
                            }
                        )

                        // Кнопка Terms
                        MoreButton(
                            imageName: "term",
                            action: {
                                navigationPath.append("terms")
                            }
                        )
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.purple.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 40)

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct MoreButton: View {
    let imageName: String
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

