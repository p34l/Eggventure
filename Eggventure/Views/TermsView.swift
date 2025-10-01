//
//  TermsView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss

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
                    Text("TERMS OF SERVICE")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    Spacer()

                    Text("Terms of Service content will be added here...")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
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
            }
        }
        .navigationBarHidden(true)
    }
}

