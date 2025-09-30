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
            // Градієнтний фон
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 1.0),
                    Color(red: 0.1, green: 0.4, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Логотип/курчатко
                Image("hero")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }
                
                // Назва гри
                Text("EGGVENTURE")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                
                Spacer()
                
                // Прогресбар
                VStack(spacing: 16) {
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .frame(width: 200)
                    
                    Text("Loading... \(Int(progress * 100))%")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
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

#Preview {
    LoadingView()
}