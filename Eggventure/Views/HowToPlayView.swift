//
//  HowToPlayView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct HowToPlayView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        ZStack {
            // Фон такий самий як в меню
            Image("loading_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Верхня частина з кнопкою назад (як в MenuView)
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

                    // Порожнє місце під другу кнопку (як settings у меню)
                    Color.clear
                        .frame(width: 60, height: 60)
                        .padding(.top, 20)
                        .padding(.trailing, 40)
                }

                Spacer()

                // Фіолетовий прямокутник з контентом
                VStack(spacing: 0) {
                    // Заголовок "HOW TO PLAY"
                    Text("HOW TO PLAY")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    // Контент з інструкціями
                    ScrollView {
                        VStack(spacing: 20) {
                            InstructionCard(
                                icon: "gamecontroller.fill",
                                title: "Game Controls",
                                description: "Tap the left side of the screen to move left, tap the right side to move right. Your character will automatically jump when landing on platforms."
                            )

                            InstructionCard(
                                icon: "target",
                                title: "Objective",
                                description: "Collect coins and reach as high as possible! Avoid falling off the screen. Each coin gives you points and helps you progress."
                            )

                            InstructionCard(
                                icon: "star.fill",
                                title: "Scoring",
                                description: "• Collect coins for points\n• Reach higher platforms for bonus points\n• Complete levels to unlock new ones\n• Earn stars based on your performance"
                            )

                            InstructionCard(
                                icon: "shop",
                                title: "Shop & Customization",
                                description: "Use your earned coins to buy new balls and customize your character. Different balls may have special abilities!"
                            )

                            InstructionCard(
                                icon: "trophy.fill",
                                title: "Leaderboard",
                                description: "Compete with other players and see how you rank on the global leaderboard. Try to beat the high scores!"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
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
        }
        .navigationBarHidden(true)
    }
}

struct InstructionCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.yellow)
                    .font(.title2)

                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }

            Text(description)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HowToPlayView(navigationPath: .constant(NavigationPath()))
}
