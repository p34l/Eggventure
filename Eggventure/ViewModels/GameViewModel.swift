//
//  GameViewModel.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import Foundation
import SwiftUI

enum GameState {
    case playing
    case paused
    case gameOver
    case victory
}

struct Platform: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGSize
    var isActive: Bool = true
}

struct Coin: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGSize = CGSize(width: 30, height: 30)
    var isCollected: Bool = false
    let value: Int = 10
}

class GameViewModel: ObservableObject {
    @Published var gameState: GameState = .playing
    @Published var score: Int = 0
    @Published var platforms: [Platform] = []
    @Published var coins: [Coin] = []
    @Published var playerPosition: CGPoint = CGPoint(x: 200, y: 600)
    @Published var isPaused: Bool = false
    
    private var playerVelocity: CGPoint = CGPoint(x: 0, y: 0)
    private var lastUpdateTime: Date = Date()
    private let gravity: CGFloat = 800
    private let jumpForce: CGFloat = 400
    private let moveSpeed: CGFloat = 200
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    init() {
        generateInitialLevel()
    }
    
    func startGame() {
        gameState = .playing
        score = 0
        playerPosition = CGPoint(x: screenWidth / 2, y: screenHeight - 150)
        playerVelocity = CGPoint.zero
        platforms.removeAll()
        coins.removeAll()
        generateInitialLevel()
        startGameLoop()
    }
    
    func togglePause() {
        isPaused.toggle()
        gameState = isPaused ? .paused : .playing
    }
    
    func restartGame() {
        startGame()
    }
    
    func jump() {
        if gameState == .playing && !isPaused {
            playerVelocity.y = jumpForce
        }
    }
    
    func movePlayerLeft() {
        if gameState == .playing && !isPaused {
            playerVelocity.x = -moveSpeed
        }
    }
    
    func movePlayerRight() {
        if gameState == .playing && !isPaused {
            playerVelocity.x = moveSpeed
        }
    }
    
    private func startGameLoop() {
        Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { timer in
            if self.gameState == .playing && !self.isPaused {
                self.updateGame()
            }
            
            if self.gameState == .gameOver || self.gameState == .victory {
                timer.invalidate()
            }
        }
    }
    
    private func updateGame() {
        let currentTime = Date()
        let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = currentTime
        
        playerVelocity.y -= gravity * deltaTime
        
        playerPosition.x += playerVelocity.x * deltaTime
        playerPosition.y += playerVelocity.y * deltaTime
        
        let playerRadius: CGFloat = 20
        if playerPosition.x < playerRadius {
            playerPosition.x = playerRadius
            playerVelocity.x = 0
        } else if playerPosition.x > screenWidth - playerRadius {
            playerPosition.x = screenWidth - playerRadius
            playerVelocity.x = 0
        }
        
        checkPlatformCollisions()
        
        checkCoinCollection()
        
        generateNewElements()
        
        checkGameConditions()
        
        playerVelocity.x *= 0.9
    }
    
    private func checkPlatformCollisions() {
        for platform in platforms {
            let playerBottom = playerPosition.y - 20
            let playerTop = playerPosition.y + 20
            let playerLeft = playerPosition.x - 20
            let playerRight = playerPosition.x + 20
            
            let platformTop = platform.position.y + platform.size.height / 2
            let platformBottom = platform.position.y - platform.size.height / 2
            let platformLeft = platform.position.x - platform.size.width / 2
            let platformRight = platform.position.x + platform.size.width / 2
            
            if playerBottom <= platformTop && playerTop >= platformBottom &&
               playerRight >= platformLeft && playerLeft <= platformRight &&
               playerVelocity.y <= 0 {
                
                playerPosition.y = platformTop + 20
                playerVelocity.y = 0
                break
            }
        }
    }
    
    private func checkCoinCollection() {
        for (index, coin) in coins.enumerated().reversed() {
            if !coin.isCollected {
                let distance = sqrt(pow(playerPosition.x - coin.position.x, 2) + pow(playerPosition.y - coin.position.y, 2))
                if distance < 30 {
                    coins[index].isCollected = true
                    score += coin.value
                }
            }
        }
    }
    
    private func generateNewElements() {
        // Генерація нових платформ
        if platforms.isEmpty || platforms.last!.position.y < screenHeight + 200 {
            let x = CGFloat.random(in: 50...(screenWidth - 50))
            let y = (platforms.last?.position.y ?? 0) + CGFloat.random(in: 150...250)
            let platform = Platform(
                position: CGPoint(x: x, y: y),
                size: CGSize(width: CGFloat.random(in: 80...120), height: 20)
            )
            platforms.append(platform)
        }
        
        // Генерація нових монет
        if coins.count < 5 {
            let x = CGFloat.random(in: 50...(screenWidth - 50))
            let baseY = platforms.last?.position.y ?? (playerPosition.y + screenHeight / 2)
            let y = baseY + CGFloat.random(in: 50...150)
            let coin = Coin(position: CGPoint(x: x, y: y))
            coins.append(coin)
        }
    }
    
    private func checkGameConditions() {
        // Перевірка програшу - гравець падає за нижню межу екрану
        if playerPosition.y > screenHeight + 100 {
            gameState = .gameOver
        }
        
        // Перевірка перемоги
        if score >= 1000 {
            gameState = .victory
        }
    }
    
    private func generateInitialLevel() {
        // Генерація початкових платформ
        let startY = screenHeight - 200
        for i in 0..<5 {
            let x = CGFloat.random(in: 50...(screenWidth - 50))
            let y = startY - CGFloat(i) * 150
            let platform = Platform(
                position: CGPoint(x: x, y: y),
                size: CGSize(width: CGFloat.random(in: 80...120), height: 20)
            )
            platforms.append(platform)
        }
        
        // Генерація початкових монет
        for i in 0..<3 {
            let x = CGFloat.random(in: 50...(screenWidth - 50))
            let y = startY - CGFloat(i) * 150 - 50
            let coin = Coin(position: CGPoint(x: x, y: y))
            coins.append(coin)
        }
    }
}
