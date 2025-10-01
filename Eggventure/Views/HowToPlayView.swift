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
                HStack {
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

                    Color.clear
                        .frame(width: 60, height: 60)
                        .padding(.top, 20)
                        .padding(.trailing, 40)
                }

                Spacer()

                VStack(spacing: 0) {
                    Text("HOW TO PLAY")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    ScrollView {
                        VStack(spacing: 20) {
                            InstructionCard(
                                icon: "gamecontroller.fill",
                                title: "Game Controls",
                                description: "Use the left and right arrow buttons to move your basket. Hold the buttons for continuous movement. Catch falling eggs before they hit the ground!"
                            )

                            InstructionCard(
                                icon: "target",
                                title: "Objective",
                                description: "Catch 10 eggs to win! Use your basket to collect falling eggs. Be careful - if an egg falls off the screen, you lose a life!"
                            )

                            InstructionCard(
                                icon: "star.fill",
                                title: "Scoring & Lives",
                                description: "• Catch eggs to earn 10 points each\n• You start with 3 lives (hearts)\n• Lose a life when an egg falls off screen\n• Win by catching 10 eggs total"
                            )

                            InstructionCard(
                                icon: "basket.fill",
                                title: "Egg Catcher",
                                description: "Eggs fall from random positions at the top. Move your basket to catch them. The basket has a larger pickup zone than it appears!"
                            )

                            InstructionCard(
                                icon: "trophy.fill",
                                title: "Victory",
                                description: "Successfully catch all 10 eggs to win the game! Your score and coins will be saved. Try to beat your best time!"
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

