//
//  NavigationHeader.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SwiftUI

struct NavigationHeader: View {
    let leftButton: NavigationButton?
    let rightButton: NavigationButton?
    
    init(leftButton: NavigationButton? = nil, rightButton: NavigationButton? = nil) {
        self.leftButton = leftButton
        self.rightButton = rightButton
    }
    
    var body: some View {
        HStack {
            if let leftButton = leftButton {
                Button(action: leftButton.action) {
                    Image(leftButton.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }
                .padding(.top, 20)
                .padding(.leading, 40)
            } else {
                Color.clear
                    .frame(width: 60, height: 60)
                    .padding(.top, 20)
                    .padding(.leading, 40)
            }
            
            Spacer()
            
            if let rightButton = rightButton {
                Button(action: rightButton.action) {
                    Image(rightButton.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }
                .padding(.top, 20)
                .padding(.trailing, 40)
            } else {
                Color.clear
                    .frame(width: 60, height: 60)
                    .padding(.top, 20)
                    .padding(.trailing, 40)
            }
        }
    }
}

struct NavigationButton {
    let imageName: String
    let action: () -> Void
    
    init(imageName: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.action = action
    }
}

struct CoinIndicator: View {
    let totalCoins: Int
    
    var body: some View {
        ZStack {
            ZStack {
                Image("with_coin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 40)

                Text("\(totalCoins)")
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
}
