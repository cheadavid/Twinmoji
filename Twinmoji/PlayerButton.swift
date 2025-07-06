//
//  PlayerButton.swift
//  Twinmoji
//
//  Created by David Chea on 30/06/2025.
//

import SwiftUI

struct PlayerButton: View {
    // MARK: - Properties
    
    var gameState: GameState
    var score: Int
    var color: Color
    var onSelect: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: onSelect) {
            Rectangle()
                .fill(color)
                .frame(minWidth: 60)
                .overlay(
                    Text(String(score))
                        .fixedSize()
                        .foregroundStyle(.white)
                        .font(.system(size: 48).bold())
                )
        }
        .disabled(gameState != .waiting)
    }
}

#Preview {
    PlayerButton(gameState: .waiting, score: 5, color: .blue) {}
}
