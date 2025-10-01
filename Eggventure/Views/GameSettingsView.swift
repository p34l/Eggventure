//
//  GameSettingsView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct GameSettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath

    @State private var betAmount: String = "0"
    @State private var selectedGameMode: GameMode = .lightning
    @State private var numberOfBets: String = "0"
    @State private var onWinReset: Bool = true
    @State private var onWinIncrease: String = "0"
    @State private var onLoseReset: Bool = true
    @State private var onLoseIncrease: String = "0"
    @State private var stopOnProfit: String = "0.00"
    @State private var stopOnLoss: String = "0.00"
    @State private var showingBetAmountInput = false
    @State private var showingGame = false

    enum GameMode: String, CaseIterable {
        case lightning = "LIGHTNING"
        case high = "HIGH"
        case medium = "MEDIUM"
        case low = "LOW"
    }

    var body: some View {
        ZStack {
            backgroundView
            mainContent
        }
        .navigationBarHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .sheet(isPresented: $showingBetAmountInput) {
            BetAmountInputSheet(
                betAmount: $betAmount,
                maxAmount: userSettings.totalCoins,
                isPresented: $showingBetAmountInput
            )
        }
        .fullScreenCover(isPresented: $showingGame) {
            GameView()
                .environmentObject(userSettings)
        }
    }
    
    private var backgroundView: some View {
        Image("loading_background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            topBar
            Spacer()
            settingsContent
        }
    }
    
    private var topBar: some View {
        HStack {
            backButton
            Spacer()
            coinIndicator
        }
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image("back")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
        }
        .padding(.top, 20)
        .padding(.leading, 40)
    }
    
    private var coinIndicator: some View {
        ZStack {
            ZStack {
                Image("with_coin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 40)

                Text("\(userSettings.totalCoins)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
                    .offset(x: -8)
            }

            Image("coin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .offset(x: 30)
        }
        .padding(.top, 20)
        .padding(.trailing, 40)
    }
    
    private var settingsContent: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 20)
            
            VStack(spacing: 12) {
                betAmountSection
                gameModeSection
                numberOfBetsSection
                onWinSection
                onLoseSection
                stopOnProfitLossSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            startButton
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.purple.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 30)
    }
    
    private var betAmountSection: some View {
        SectionBox(title: "BET AMOUNT") {
            HStack(spacing: 0) {
                TextField("0", text: $betAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(SettingsTextFieldStyle())
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .onSubmit {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }

                HStack(spacing: 8) {
                    Button("1/2") {
                        if let amount = Double(betAmount) {
                            let newAmount = Int(amount / 2)
                            betAmount = String(newAmount)
                        }
                    }
                    .buttonStyle(BetActionButtonStyle())
                    .frame(height: 35)

                    Button("2") {
                        if let amount = Double(betAmount) {
                            let newAmount = Int(amount * 2)
                            if newAmount > userSettings.totalCoins {
                                betAmount = String(userSettings.totalCoins)
                            } else {
                                betAmount = String(newAmount)
                            }
                        }
                    }
                    .buttonStyle(BetActionButtonStyle())
                    .frame(height: 35)

                    Button("MAX") {
                        betAmount = String(userSettings.totalCoins)
                    }
                    .buttonStyle(BetActionButtonStyle())
                    .frame(height: 35)
                }
                .padding(.trailing, 15)
            }
        }
    }

    private var gameModeSection: some View {
        SectionBox(title: "GAME MODE") {
            HStack(spacing: 10) {
                ForEach(GameMode.allCases, id: \.self) { mode in
                    Button(mode.rawValue) {
                        selectedGameMode = mode
                    }
                    .buttonStyle(SettingsModeButtonStyle(isSelected: selectedGameMode == mode))
                    .frame(height: 35)
                }
            }
        }
    }

    private var numberOfBetsSection: some View {
        SectionBox(title: "NUMBERS OF BETS") {
            TextField("0", text: $numberOfBets)
                .keyboardType(.numberPad)
                .textFieldStyle(SettingsTextFieldStyle())
                .frame(height: 35)
        }
    }

    private var onWinSection: some View {
        SectionBox(title: "ON WIN") {
            HStack(spacing: 10) {
                Button("RESET") {
                    onWinReset = true
                }
                .buttonStyle(SettingsModeButtonStyle(isSelected: onWinReset))
                .frame(height: 50)

                Button("INCREASE BY") {
                    onWinReset = false
                }
                .buttonStyle(SettingsModeButtonStyle(isSelected: !onWinReset))
                .frame(height: 50)

                TextField("0%", text: $onWinIncrease)
                    .keyboardType(.numberPad)
                    .textFieldStyle(SettingsTextFieldStyle())
                    .frame(width: 60, height: 35)
            }
        }
    }

    private var onLoseSection: some View {
        SectionBox(title: "ON LOSE") {
            HStack(spacing: 10) {
                Button("RESET") {
                    onLoseReset = true
                }
                .buttonStyle(SettingsModeButtonStyle(isSelected: onLoseReset))
                .frame(height: 50)

                Button("INCREASE BY") {
                    onLoseReset = false
                }
                .buttonStyle(SettingsModeButtonStyle(isSelected: !onLoseReset))
                .frame(height: 50)

                TextField("0%", text: $onLoseIncrease)
                    .keyboardType(.numberPad)
                    .textFieldStyle(SettingsTextFieldStyle())
                    .frame(width: 60, height: 35)
            }
        }
    }

    private var stopOnProfitLossSection: some View {
        HStack(spacing: 20) {
            stopOnProfitView
            stopOnLossView
        }
    }
    
    private var stopOnProfitView: some View {
        SectionBox(title: "STOP ON PROFIT") {
            HStack(spacing: 5) {
                Button("+") {
                    if let currentValue = Double(stopOnProfit) {
                        stopOnProfit = String(format: "%.2f", currentValue + 1.0)
                    } else {
                        stopOnProfit = "1.00"
                    }
                }
                .buttonStyle(PlusButtonStyle())

                TextField("0.00", text: $stopOnProfit)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(SettingsTextFieldStyle())
                    .frame(height: 35)

                Text("$")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 15, height: 35)
            }
        }
    }
    
    private var stopOnLossView: some View {
        SectionBox(title: "STOP ON LOSS") {
            HStack(spacing: 5) {
                Button("+") {
                    if let currentValue = Double(stopOnLoss) {
                        stopOnLoss = String(format: "%.2f", currentValue + 1.0)
                    } else {
                        stopOnLoss = "1.00"
                    }
                }
                .buttonStyle(PlusButtonStyle())

                TextField("0.00", text: $stopOnLoss)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(SettingsTextFieldStyle())
                    .frame(height: 35)

                Text("$")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 15, height: 35)
            }
        }
    }
    
    private var startButton: some View {
        Button(action: {
            showingGame = true
        }) {
            ZStack {
                Image("start_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 55)
                
                Text("START AUTOGAME")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
            }
        }
    }
}

struct SettingsTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 15)
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.purple.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SettingsModeButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? Color.pink.opacity(0.8) : Color.purple.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct BetActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.pink.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PlusButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 25, height: 35)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.green.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct BetAmountInputSheet: View {
    @Binding var betAmount: String
    let maxAmount: Int
    @Binding var isPresented: Bool
    @State private var tempAmount: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Bet Amount")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            TextField("Amount", text: $tempAmount)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Text("Max: \(maxAmount)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

            HStack(spacing: 20) {
                Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.7))
                )

                Button("Save") {
                    if let amount = Int(tempAmount), amount <= maxAmount {
                        betAmount = String(amount)
                    }
                    isPresented = false
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.pink.opacity(0.7))
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purple.opacity(0.9))
        .presentationDetents([.height(300)])
        .onAppear {
            tempAmount = betAmount
        }
    }
}

struct SectionBox<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
            
            content
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.pink.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

