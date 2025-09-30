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
    @State private var showingPurchaseAlert = false
    @State private var selectedBall: BallItem? = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // TODO: Замінити на фон з assets
            // Image("назва_фону_з_assets")
            //     .resizable()
            //     .aspectRatio(contentMode: .fill)
            //     .ignoresSafeArea()
            
            // Градієнтний фон (замінити на assets)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 1.0),
                    Color(red: 0.1, green: 0.4, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("SHOP")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                    .padding(.top, 20)
                
                HStack {
                    // TODO: Замінити на яйце з assets
                    // Image("назва_яйця_монети_з_assets")
                    //     .resizable()
                    //     .aspectRatio(contentMode: .fit)
                    //     .frame(width: 28, height: 28)
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.title2)
                    
                    Text("\(userSettings.totalCoins)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                )
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                        ForEach(gameData.balls) { ball in
                            BallShopItem(
                                ball: ball,
                                isSelected: userSettings.selectedBall == ball.id,
                                canAfford: userSettings.totalCoins >= ball.price,
                                onPurchase: {
                                    purchaseBall(ball)
                                },
                                onSelect: {
                                    selectBall(ball)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Кнопка повернення
                Button(action: {
                    dismiss()
                }) {
                    Text("BACK TO MENU")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
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
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .alert("Purchase Successful!", isPresented: $showingPurchaseAlert) {
            Button("OK") { }
        } message: {
            Text("You have successfully purchased \(selectedBall?.name ?? "the ball")!")
        }
    }
    
    private func purchaseBall(_ ball: BallItem) {
        if userSettings.totalCoins >= ball.price && !ball.isUnlocked {
            userSettings.totalCoins -= ball.price
            gameData.unlockBall(ball.id)
            selectedBall = ball
            showingPurchaseAlert = true
        }
    }
    
    private func selectBall(_ ball: BallItem) {
        if ball.isUnlocked {
            userSettings.selectedBall = ball.id
        }
    }
}

struct BallShopItem: View {
    let ball: BallItem
    let isSelected: Bool
    let canAfford: Bool
    let onPurchase: () -> Void
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Зображення кулі
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? .green : .white.opacity(0.5),
                                lineWidth: isSelected ? 3 : 2
                            )
                    )
                
                Image(ball.id)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            }
            
            // Назва та ціна
            VStack(spacing: 5) {
                Text(ball.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if ball.price == 0 {
                    Text("FREE")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                } else {
                    HStack {
                        // TODO: Замінити на яйце з assets
                        // Image("назва_яйця_монети_з_assets")
                        //     .resizable()
                        //     .aspectRatio(contentMode: .fit)
                        //     .frame(width: 12, height: 12)
                        
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        
                        Text("\(ball.price)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
            
            // Кнопка
            if ball.isUnlocked {
                if isSelected {
                    Text("SELECTED")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.green.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.green, lineWidth: 1)
                                )
                        )
                } else {
                    Button("SELECT") {
                        onSelect()
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.blue, lineWidth: 1)
                            )
                    )
                }
            } else {
                Button("BUY") {
                    onPurchase()
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(canAfford ? .white : .gray)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(canAfford ? .green.opacity(0.6) : .gray.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(canAfford ? .green : .gray, lineWidth: 1)
                        )
                )
                .disabled(!canAfford)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ShopView()
        .environmentObject(UserSettings())
        .environmentObject(GameData())
}
