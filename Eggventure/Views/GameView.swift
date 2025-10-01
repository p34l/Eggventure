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

            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 1.0),
                    Color(red: 0.1, green: 0.4, blue: 0.8),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    HStack {
                        // TODO: Замінити на яйце з assets
                        Image("назва_яйця_з_assets")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)

                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(gameViewModel.score)")
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

                    Button(action: {
                        gameViewModel.togglePause()
                    }) {
                        // TODO: Замінити на кнопки з assets
                        Image(gameViewModel.isPaused ? "play" : "pause")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                GeometryReader { geometry in
                    ZStack {
                        // Платформи
                        ForEach(gameViewModel.platforms) { platform in
                            PlatformView(platform: platform)
                        }

                        // Монети
                        ForEach(gameViewModel.coins) { coin in
                            CoinView(coin: coin)
                        }

                        // Гравець
                        PlayerView(
                            position: gameViewModel.playerPosition,
                            ballType: userSettings.selectedBall
                        )
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .onTapGesture { location in
                        if !gameViewModel.isPaused {
                            if location.x < geometry.size.width / 2 {
                                gameViewModel.movePlayerLeft()
                            } else {
                                gameViewModel.movePlayerRight()
                            }
                        }
                    }
                }

                // Кнопки управління
                if !gameViewModel.isPaused {
                    HStack {
                        Button(action: {
                            gameViewModel.movePlayerLeft()
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

                        Spacer()

                        Button(action: {
                            gameViewModel.jump()
                        }) {
                            Image(systemName: "arrowtriangle.up.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.3))
                                )
                        }

                        Spacer()

                        Button(action: {
                            gameViewModel.movePlayerRight()
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
            gameViewModel.startGame()
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

struct PlayerView: View {
    let position: CGPoint
    let ballType: String

    var body: some View {
        // TODO: Замінити на яйце з assets
        // Image("назва_яйця_персонажа_з_assets")
        //     .resizable()
        //     .aspectRatio(contentMode: .fit)
        //     .frame(width: 40, height: 40)
        //     .position(position)

        Image(ballType)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .position(position)
    }
}

struct PlatformView: View {
    let platform: Platform

    var body: some View {
        // TODO: Замінити на платформу з assets
        // Image("назва_платформи_з_assets")
        //     .resizable()
        //     .frame(width: platform.size.width, height: platform.size.height)
        //     .position(platform.position)

        Rectangle()
            .fill(Color.brown)
            .frame(width: platform.size.width, height: platform.size.height)
            .position(platform.position)
    }
}

struct CoinView: View {
    let coin: Coin

    var body: some View {
        // TODO: Замінити на яйце з assets (замість монети)
        // Image("назва_яйця_монети_з_assets")
        //     .resizable()
        //     .aspectRatio(contentMode: .fit)
        //     .frame(width: 30, height: 30)
        //     .position(coin.position)
        //     .opacity(coin.isCollected ? 0 : 1)

        Image("coin")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .position(coin.position)
            .opacity(coin.isCollected ? 0 : 1)
    }
}

struct PauseOverlay: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("PAUSED")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    Button("RESUME") {
                        onResume()
                    }
                    .buttonStyle(GameButtonStyle())

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
                Text("VICTORY!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.yellow)

                Text("Score: \(score)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    Button("PLAY AGAIN") {
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

