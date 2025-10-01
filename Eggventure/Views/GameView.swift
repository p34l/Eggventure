//
//  GameView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var userSettings: UserSettings
    @StateObject private var gameViewModel = GameViewModel()
    @State private var showingGameOver = false
    @State private var showingVictory = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Image("game_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    HStack {
                        Image("coin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        
                        Text("\(userSettings.totalCoins)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.black.opacity(0.3))
                    )

                    Spacer()

                    HStack(spacing: 5) {
                        ForEach(0..<gameViewModel.lives, id: \.self) { _ in
                            Text("🧡")
                                .font(.title2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.black.opacity(0.3))
                    )

                    Spacer()

                    Button(action: {
                        gameViewModel.togglePause()
                    }) {
                        Image("pause")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)

                Text("Eggs Caught: \(gameViewModel.eggsCaught)/\(gameViewModel.targetEggs)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.black.opacity(0.3))
                    )
                    .padding(.top, 10)

                GeometryReader { geometry in
                    ZStack {
                        ForEach(gameViewModel.fallingEggs) { egg in
                            Image(egg.ballType)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .position(egg.position)
                        }

                        Image(systemName: "basket.fill")
                            .resizable()
                            .frame(width: 80, height: 40)
                            .foregroundColor(.brown)
                            .position(x: gameViewModel.basketPosition, y: geometry.size.height - 20)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                }

                if !gameViewModel.isPaused {
                    HStack {
                        Button(action: {
                            gameViewModel.moveBasketLeft()
                        }) {
                            Image(systemName: "arrowtriangle.left.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.3))
                                )
                        }
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            if pressing {
                                gameViewModel.startMovingLeft()
                            } else {
                                gameViewModel.stopMovingLeft()
                            }
                        }, perform: {})

                        Spacer()

                        Button(action: {
                            gameViewModel.moveBasketRight()
                        }) {
                            Image(systemName: "arrowtriangle.right.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.3))
                                )
                        }
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            if pressing {
                                gameViewModel.startMovingRight()
                            } else {
                                gameViewModel.stopMovingRight()
                            }
                        }, perform: {})
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }

            if gameViewModel.isPaused {
                PauseOverlay {
                    gameViewModel.togglePause()
                } onRestart: {
                    gameViewModel.restartGame()
                } onHome: {
                    dismiss()
                }
            }

            if showingGameOver {
                GameOverlay(title: "GAME OVER", titleColor: .red, score: gameViewModel.score) {
                    gameViewModel.restartGame()
                    showingGameOver = false
                } onHome: {
                    dismiss()
                }
            }

            if showingVictory {
                GameOverlay(title: "VICTORY", titleColor: .green) {
                    gameViewModel.restartGame()
                    showingVictory = false
                } onHome: {
                    dismiss()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            gameViewModel.setUserSettings(userSettings)
            gameViewModel.startGame()
        }
        .onDisappear {
            gameViewModel.stopGame()
        }
        .onChange(of: gameViewModel.gameState) { state in
            switch state {
            case .gameOver:
                showingGameOver = true
            case .victory:
                showingVictory = true
            default:
                break
            }
        }
    }
}





