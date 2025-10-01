//
//  LoadingView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: Double = 0.0
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Image("loading_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Image("hero")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 500)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }

                VStack(spacing: 8) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 40)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.red, .orange, .yellow]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 300 * progress, height: 40)
                            .animation(.linear(duration: 0.1), value: progress)

                        HStack {
                            Spacer()
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
                            Spacer()
                        }
                        .frame(width: 300, height: 40)
                    }
                }
                .padding(.top, 30)

                Spacer()
            }
        }
        .onAppear {
            startLoading()
        }
    }

    private func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            withAnimation(.linear(duration: 0.05)) {
                progress += 0.02
            }

            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }
}

