//
//  GameData.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import Foundation

struct BallItem: Identifiable, Codable {
    let id: String
    let name: String
    let price: Int
    let isUnlocked: Bool
    
    init(id: String, name: String, price: Int, isUnlocked: Bool = false) {
        self.id = id
        self.name = name
        self.price = price
        self.isUnlocked = isUnlocked
    }
}

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let playerName: String
    let score: Int
    let stars: Int
    let isCurrentPlayer: Bool
}

struct LevelData: Identifiable {
    let id: Int
    let isUnlocked: Bool
    let stars: Int
    let bestScore: Int
}

class GameData: ObservableObject {
    @Published var balls: [BallItem] = [
        BallItem(id: "hero", name: "Default Ball", price: 0, isUnlocked: true),
        BallItem(id: "ball2", name: "Golden Ball", price: 500, isUnlocked: false),
        BallItem(id: "ball3", name: "Amethyst Ball", price: 300, isUnlocked: false),
        BallItem(id: "ball4", name: "Ice Ball", price: 800, isUnlocked: false),
        BallItem(id: "ball5", name: "Fire Ball", price: 1000, isUnlocked: false)
    ]
    
    @Published var levels: [LevelData] = []
    
    @Published var leaderboard: [LeaderboardEntry] = [
        LeaderboardEntry(playerName: "Champion", score: 15000, stars: 3, isCurrentPlayer: false),
        LeaderboardEntry(playerName: "ProGamer", score: 12000, stars: 3, isCurrentPlayer: false),
        LeaderboardEntry(playerName: "Player", score: 8500, stars: 2, isCurrentPlayer: true),
        LeaderboardEntry(playerName: "Newbie", score: 5000, stars: 1, isCurrentPlayer: false),
        LeaderboardEntry(playerName: "Rookie", score: 3000, stars: 1, isCurrentPlayer: false)
    ]
    
    init() {
        generateLevels()
    }
    
    private func generateLevels() {
        levels = (1...9).map { level in
            LevelData(
                id: level,
                isUnlocked: level == 1, 
                stars: 0,
                bestScore: 0
            )
        }
    }
    
    func unlockBall(_ ballId: String) {
        if let index = balls.firstIndex(where: { $0.id == ballId }) {
            balls[index] = BallItem(
                id: balls[index].id,
                name: balls[index].name,
                price: balls[index].price,
                isUnlocked: true
            )
        }
    }
    
    func unlockLevel(_ levelId: Int) {
        if let index = levels.firstIndex(where: { $0.id == levelId }) {
            levels[index] = LevelData(
                id: levels[index].id,
                isUnlocked: true,
                stars: levels[index].stars,
                bestScore: levels[index].bestScore
            )
        }
    }
}
