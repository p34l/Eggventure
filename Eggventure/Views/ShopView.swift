//
//  ShopView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath
    
    @State private var selectedBall: String = "Default Ball"
    
    var balls: [BallItem] {
        gameData.balls.map { ball in
            BallItem(
                id: ball.id,
                name: ball.name,
                price: ball.price,
                isUnlocked: userSettings.ownedBalls.contains(ball.name)
            )
        }
    }
    
    var body: some View {
        ZStack {
            Image("loading_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    }
                    .padding(.top, 45)
                    .padding(.leading, 60)

                    Spacer()

                    ZStack {
                        ZStack {
                            Image("with_coin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 40)

                            Text("\(userSettings.totalCoins)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
                                .offset(x: -8)
                        }

                        Image("coin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .offset(x: 30)
                    }
                    .padding(.top, 45)
                    .padding(.trailing, 80)
                }

                Spacer()

                VStack(spacing: 20) {
                    Text("Choose Ball for Game")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(balls, id: \.name) { ball in
                            BallCard(
                                ball: ball,
                                isSelected: selectedBall == ball.name,
                                onSelect: {
                                    if ball.isUnlocked {
                                        selectedBall = ball.name
                                        userSettings.selectedBall = ball.name
                                    }
                                },
                                onBuy: {
                                    if !ball.isUnlocked && userSettings.totalCoins >= ball.price {
                                        userSettings.totalCoins -= ball.price
                                        userSettings.ownedBalls.append(ball.name)
                                        gameData.unlockBall(ball.id)
                                        selectedBall = ball.name
                                        userSettings.selectedBall = ball.name
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 40)
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
                .padding(.horizontal, 30)
                .padding(.vertical, 20)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            selectedBall = userSettings.selectedBall
        }
    }
}


struct BallCard: View {
    let ball: BallItem
    let isSelected: Bool
    let onSelect: () -> Void
    let onBuy: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Image(ball.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)

            Text(ball.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            if ball.isUnlocked {
                Button(action: onSelect) {
                    Text(isSelected ? "SELECTED" : "SELECT")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isSelected ? Color.green : Color.blue)
                        )
                }
            } else {
                Button(action: onBuy) {
                    VStack(spacing: 2) {
                        Text("BUY")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                        Text("\(ball.price)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.yellow)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange)
                    )
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pink.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
