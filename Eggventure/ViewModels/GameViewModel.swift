//
//  GameViewModel.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import Foundation
import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

enum GameState {
    case playing
    case paused
    case gameOver
    case victory
}

struct FallingEgg: Identifiable {
    let id = UUID()
    var position: CGPoint
    let ballType: String
    var isCaught: Bool = false
}

class GameViewModel: ObservableObject {
    @Published var gameState: GameState = .playing
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var eggsCaught: Int = 0
    @Published var targetEggs: Int = 10
    @Published var fallingEggs: [FallingEgg] = []
    @Published var basketPosition: CGFloat = 0
    @Published var isPaused: Bool = false
    @Published var isMovingLeft = false
    @Published var isMovingRight = false
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    private let basketWidth: CGFloat = 80
    private let basketHeight: CGFloat = 40
    private let eggSize: CGFloat = 40
    private let fallSpeed: CGFloat = 200
    private let moveSpeed: CGFloat = 600
    
    private var gameTimer: Timer?
    private var eggSpawnTimer: Timer?
    private var movementTimer: Timer?
    private var userSettings: UserSettings?
    
    init() {
        basketPosition = UIScreen.main.bounds.width / 2
    }
    
    func setUserSettings(_ userSettings: UserSettings) {
        self.userSettings = userSettings
    }
    
    func startGame() {
        gameState = .playing
        score = 0
        lives = 3
        eggsCaught = 0
        basketPosition = screenWidth / 2
        fallingEggs.removeAll()
        
        spawnEgg()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            if self.gameState == .playing && !self.isPaused {
                self.updateGame()
            }
        }
        
        eggSpawnTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            if self.gameState == .playing && !self.isPaused {
                self.spawnEgg()
            }
        }
    }

    
    func stopGame() {
        gameTimer?.invalidate()
        eggSpawnTimer?.invalidate()
        movementTimer?.invalidate()
        gameTimer = nil
        eggSpawnTimer = nil
        movementTimer = nil
        isMovingLeft = false
        isMovingRight = false
    }
    
    func togglePause() {
        isPaused.toggle()
        gameState = isPaused ? .paused : .playing
    }
    
    func restartGame() {
        stopGame()
        startGame()
    }
    
    func moveBasketLeft() {
        if gameState == .playing && !isPaused {
            let newPos = max(basketPosition - 30, basketWidth / 2)
            withAnimation(.linear(duration: 0.1)) {
                basketPosition = newPos
            }
        }
    }
    
    func moveBasketRight() {
        if gameState == .playing && !isPaused {
            let newPos = min(basketPosition + 30, screenWidth - basketWidth / 2)
            withAnimation(.linear(duration: 0.1)) {
                basketPosition = newPos
            }
        }
    }
    
    func startMovingLeft() {
        isMovingLeft = true
        startMovementTimer()
    }
    
    func stopMovingLeft() {
        isMovingLeft = false
    }
    
    func startMovingRight() {
        isMovingRight = true
        startMovementTimer()
    }
    
    func stopMovingRight() {
        isMovingRight = false
    }
    
    private func startMovementTimer() {
        guard movementTimer == nil else { return }
        
        movementTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            guard self.gameState == .playing && !self.isPaused else { return }
            
            if self.isMovingLeft {
                let newPos = max(self.basketPosition - 5, self.basketWidth / 2)
                withAnimation(.linear(duration: 0.016)) {
                    self.basketPosition = newPos
                }
            }
            if self.isMovingRight {
                let newPos = min(self.basketPosition + 5, self.screenWidth - self.basketWidth / 2)
                withAnimation(.linear(duration: 0.016)) {
                    self.basketPosition = newPos
                }
            }
            
            if !self.isMovingLeft && !self.isMovingRight {
                self.movementTimer?.invalidate()
                self.movementTimer = nil
            }
        }
    }
    
    private func updateGame() {
        let basketY = screenHeight - basketHeight/2
        let pickupZoneWidth = basketWidth + 40
        let pickupZoneHeight = basketHeight + 20
        let basketRect = CGRect(
            x: basketPosition - pickupZoneWidth/2,
            y: basketY - pickupZoneHeight/2,
            width: pickupZoneWidth,
            height: pickupZoneHeight
        )
        
        for index in fallingEggs.indices.reversed() {
            let eggRect = CGRect(
                x: fallingEggs[index].position.x - eggSize/2,
                y: fallingEggs[index].position.y - eggSize/2,
                width: eggSize,
                height: eggSize
            )
            
            if basketRect.intersects(eggRect) {
                score += 10
                eggsCaught += 1
                userSettings?.totalCoins += 10
                fallingEggs.remove(at: index)
                
                if eggsCaught >= targetEggs {
                    gameState = .victory
                    stopGame()
                }
                continue
            }
            
            fallingEggs[index].position.y += fallSpeed * 0.016
            
            if fallingEggs[index].position.y > screenHeight + eggSize {
                lives -= 1
                fallingEggs.remove(at: index)
                
                if lives <= 0 {
                    gameState = .gameOver
                    stopGame()
                }
            }
        }
    }
    
    private func spawnEgg() {
        let margin: CGFloat = basketWidth/2 + 20
        let randomX = CGFloat.random(in: margin...(screenWidth - margin))
        let ballType = userSettings?.selectedBall ?? "Default Ball"
        
        let newEgg = FallingEgg(
            position: CGPoint(x: randomX, y: -eggSize),
            ballType: ballType
        )
        
        fallingEggs.append(newEgg)
    }
    
}
