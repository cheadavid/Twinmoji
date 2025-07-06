//
//  CardView.swift
//  Twinmoji
//
//  Created by David Chea on 29/06/2025.
//

import SwiftUI

struct CardView: View {
    // MARK: - Properties
    
    var card: [String]
    var userCanAnswer: Bool
    var onSelect: (String) -> Void
    
    // MARK: - Computed Properties
    
    var rows: Int {
        if card.count == 12 {
            4
        } else {
            3
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<rows, id: \.self) { i in
                GridRow {
                    ForEach(0..<3) { j in
                        let text = card[i * 3 + j]
                        
                        Button(text) {
                            onSelect(text)
                        }
                    }
                }
            }
        }
        .font(.system(size: 64))
        .padding()
        .background(.white)
        .clipShape(.rect(cornerRadius: 20))
        .fixedSize()
        .shadow(radius: 10)
        .disabled(!userCanAnswer)
        .transition(.push(from: .top))
        .id(card)
    }
}

#Preview {
    CardView(card: Array("😎🥹🥰😔😂😳🧐🙂😇😅😆😙😬🙃😍🥸😣😶🙄🤨😩😉🥲😋😛🤓😏😭😯😵😐😘😢😠").map(String.init), userCanAnswer: true) { _ in }
}
