//
//  SettingsView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath

    var body: some View {
        ZStack {
            Image("loading_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                NavigationHeader(
                    leftButton: NavigationButton(imageName: "back", action: { dismiss() })
                )

                Spacer()

                VStack(spacing: 0) {
                    Text("SETTINGS")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    VStack(spacing: 20) {
                        SettingRowView(
                            title: "Music",
                            isOn: $userSettings.musicEnabled
                        )
                        
                        SettingRowView(
                            title: "Sound",
                            isOn: $userSettings.soundEnabled
                        )
                        
                        SettingRowView(
                            title: "Notifications",
                            isOn: $userSettings.notificationsEnabled
                        )
                        
                        SettingRowView(
                            title: "Vibration",
                            isOn: $userSettings.vibrationEnabled
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.purple.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 40)

                Spacer()
                
                Button(action: {
                    if !navigationPath.isEmpty {
                        navigationPath.removeLast()
                    }
                }) {
                    ZStack {
                        Image("with_save")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 60)
                        
                        Image("save")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SettingRowView: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .pink))
                .scaleEffect(0.8)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pink.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
