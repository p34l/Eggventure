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
                GameOverOverlay(score: gameViewModel.score) {
                    gameViewModel.restartGame()
                    showingGameOver = false
                } onHome: {
                    dismiss()
                }
            }

            if showingVictory {
                VictoryOverlay(score: gameViewModel.score) {
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


struct PauseOverlay: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // Напис PAUSED на 80% ширини екрану
                    Text("PAUSED")
                        .font(.system(size: min(geometry.size.width * 0.8 / 6, 80), weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.8)
                        .multilineTextAlignment(.center)

                    // Кнопки HOME та RESTART на одному рівні
                    HStack(spacing: 30) {
                        // Кнопка HOME
                        Button(action: onHome) {
                            Text("HOME")
                                .font(.system(size: min(geometry.size.width * 0.4 / 4, 40), weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.35, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(.white.opacity(0.4), lineWidth: 2)
                                        )
                                )
                        }
                        .buttonStyle(PauseOverlayButtonStyle())

                        // Кнопка RESTART
                        Button(action: {
                            onRestart()
                            onResume() // Також закриває віконце паузи
                        }) {
                            Text("RESTART")
                                .font(.system(size: min(geometry.size.width * 0.4 / 7, 40), weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.35, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(.white.opacity(0.4), lineWidth: 2)
                                        )
                                )
                        }
                        .buttonStyle(PauseOverlayButtonStyle())
                    }

                    Spacer()

                    // Велика кнопка PLAY знизу трошки вище (ширша)
                    Button(action: onResume) {
                        ZStack {
                            Image("func_button_background")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 180)

                            Image("play")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 50)
                                .offset(y: -10)
                        }
                    }
                    .buttonStyle(PlayButtonStyle())
                    .padding(.bottom, 80)
                }
            }
        }
    }
}

struct GameOverOverlay: View {
    let score: Int
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("GAME OVER")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.red)

                Text("Score: \(score)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    Button("RESTART") {
                        onRestart()
                    }
                    .buttonStyle(GameButtonStyle())

                    Button("HOME") {
                        onHome()
                    }
                    .buttonStyle(GameButtonStyle())
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.4), lineWidth: 2)
                    )
            )
        }
    }
}

struct VictoryOverlay: View {
    let score: Int
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("VICTORY")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.green)

                VStack(spacing: 15) {
                    Button("RESTART") {
                        onRestart()
                    }
                    .buttonStyle(GameButtonStyle())

                    Button("HOME") {
                        onHome()
                    }
                    .buttonStyle(GameButtonStyle())
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.4), lineWidth: 2)
                    )
            )
        }
    }
}

struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
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
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PauseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .fill(.white.opacity(0.2))
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.4), lineWidth: 2)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PauseOverlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

