//
//  UserSettings.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var playerName: String {
        didSet {
            UserDefaults.standard.set(playerName, forKey: "playerName")
        }
    }
    
    @Published var selectedBall: String {
        didSet {
            UserDefaults.standard.set(selectedBall, forKey: "selectedBall")
        }
    }
    
    @Published var totalCoins: Int {
        didSet {
            UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
        }
    }
    
    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        }
    }
    
    @Published var musicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")
        }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    
    @Published var unlockedLevels: Set<Int> {
        didSet {
            let array = Array(unlockedLevels)
            UserDefaults.standard.set(array, forKey: "unlockedLevels")
        }
    }
    
    @Published var playerScore: Int {
        didSet {
            UserDefaults.standard.set(playerScore, forKey: "playerScore")
        }
    }
    
    init() {
        self.playerName = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
        self.selectedBall = UserDefaults.standard.string(forKey: "selectedBall") ?? "hero"
        self.totalCoins = UserDefaults.standard.integer(forKey: "totalCoins") == 0 ? 1000 : UserDefaults.standard.integer(forKey: "totalCoins")
        self.soundEnabled = UserDefaults.standard.object(forKey: "soundEnabled") == nil ? true : UserDefaults.standard.bool(forKey: "soundEnabled")
        self.musicEnabled = UserDefaults.standard.object(forKey: "musicEnabled") == nil ? true : UserDefaults.standard.bool(forKey: "musicEnabled")
        self.notificationsEnabled = UserDefaults.standard.object(forKey: "notificationsEnabled") == nil ? true : UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        let levelsArray = UserDefaults.standard.array(forKey: "unlockedLevels") as? [Int] ?? [1]
        self.unlockedLevels = Set(levelsArray)
        
        self.playerScore = UserDefaults.standard.integer(forKey: "playerScore")
    }
    
    func unlockLevel(_ level: Int) {
        unlockedLevels.insert(level)
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        return unlockedLevels.contains(level)
    }
}