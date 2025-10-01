//
//  GameOverlays.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct GameOverlay: View {
    let title: String
    let titleColor: Color
    let score: Int?
    let onRestart: () -> Void
    let onHome: () -> Void
    
    init(title: String, titleColor: Color, score: Int? = nil, onRestart: @escaping () -> Void, onHome: @escaping () -> Void) {
        self.title = title
        self.titleColor = titleColor
        self.score = score
        self.onRestart = onRestart
        self.onHome = onHome
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(titleColor)

                if let score = score {
                    Text("SCORE: \(score)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

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

struct PauseOverlay: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()

                    Text("PAUSED")
                        .font(.system(size: min(geometry.size.width * 0.8 / 6, 60), weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)

                    Spacer()

                    HStack(spacing: 20) {
                        Button(action: onHome) {
                            Text("HOME")
                                .font(.system(size: min(geometry.size.width * 0.4 / 4, 30), weight: .bold))
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

                        Button(action: {
                            onRestart()
                            onResume()
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
