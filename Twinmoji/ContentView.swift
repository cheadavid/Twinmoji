//
//  ContentView.swift
//  Twinmoji
//
//  Created by David Chea on 29/06/2025.
//

import SwiftUI

enum GameState {
    case waiting
    case player1Answering
    case player2Answering
}

struct ContentView: View {
    // MARK: - States
    
    @State private var currentEmoji = [String]()
    
    @State private var leftCard = [String]()
    @State private var rightCard = [String]()
    
    @State private var gameState = GameState.waiting
    
    @State private var player1Score = 0
    @State private var player2Score = 0
    
    @State private var answerColor = Color.clear
    @State private var answerScale = 1.0
    @State private var answerAnchor = UnitPoint.center
    
    @State private var playerHasWon = false
    
    // MARK: - Bindings
    
    @Binding var isGameActive: Bool
    
    // MARK: - Constants
    
    let allEmoji = Array("😎🥹🥰😔😂😳🧐🙂😇😅😆😙😬🙃😍🥸😣😶🙄🤨😩😉🥲😋😛🤓😏😭😯😵😐😘😢😠").map(String.init)
    
    // MARK: - Properties
    
    var itemCount: Int
    var answerTime: Double
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                PlayerButton(gameState: gameState, score: player1Score, color: .blue, onSelect: selectPlayer1)
                
                ZStack {
                    answerColor.scaleEffect(x: answerScale, anchor: answerAnchor)
                    
                    if !leftCard.isEmpty {
                        HStack {
                            CardView(card: leftCard, userCanAnswer: gameState != .waiting, onSelect: checkAnswer)
                            CardView(card: rightCard, userCanAnswer: gameState != .waiting, onSelect: checkAnswer)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
                PlayerButton(gameState: gameState, score: player2Score, color: .red, onSelect: selectPlayer2)
            }
            
            Button("End Game", systemImage: "xmark.circle") {
                isGameActive = false
            }
            .symbolVariant(.fill)
            .labelStyle(.iconOnly)
            .font(.largeTitle)
            .tint(.white)
            .padding(40)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.9))
        .persistentSystemOverlays(.hidden)
        .onAppear(perform: createLevel)
        .alert("Game Over!", isPresented: $playerHasWon) {
            Button("Play Again") {
                isGameActive = false
            }
        } message: {
            if player1Score > player2Score {
                Text("Player 1 Won \(player1Score)-\(player2Score)")
            } else {
                Text("Player 2 Won \(player2Score)-\(player1Score)")
            }
        }
    }
    
    // MARK: - Methods
    
    func createLevel() {
        currentEmoji = allEmoji.shuffled()
        
        withAnimation(.spring(duration: 0.75)) {
            leftCard = Array(currentEmoji[0..<itemCount]).shuffled()
            rightCard = Array(currentEmoji[itemCount + 1..<itemCount + itemCount] + [currentEmoji[0]]).shuffled()
        }
    }
    
    func selectPlayer1() {
        guard gameState == .waiting else { return }
        
        gameState = .player1Answering
        answerColor = .blue
        answerAnchor = .leading
        
        runClock()
    }
    
    func selectPlayer2() {
        guard gameState == .waiting else { return }
        
        gameState = .player2Answering
        answerColor = .red
        answerAnchor = .trailing
        
        runClock()
    }
    
    func runClock() {
        let checkEmoji = currentEmoji
        
        answerScale = 1
        
        withAnimation(.linear(duration: answerTime)) {
            answerScale = 0
        } completion: {
            timeOut(for: checkEmoji)
        }
    }
    
    func timeOut(for emoji: [String]) {
        guard currentEmoji == emoji else { return }
        
        if gameState == .player1Answering {
            player1Score -= 1
        } else if gameState == .player2Answering {
            player2Score -= 1
        }
        
        gameState = .waiting
    }
    
    func checkAnswer(_ string: String) {
        if string == currentEmoji[0] {
            if gameState == .player1Answering {
                player1Score += 1
            } else if gameState == .player2Answering {
                player2Score += 1
            }
            
            if player1Score == 5 || player2Score == 5 {
                playerHasWon = true
            } else {
                createLevel()
            }
        } else {
            if gameState == .player1Answering {
                player1Score -= 1
            } else if gameState == .player2Answering {
                player2Score -= 1
            }
        }
        
        gameState = .waiting
        answerColor = .clear
        answerScale = 0
    }
}

#Preview {
    ContentView(isGameActive: .constant(true), itemCount: 9, answerTime: 1)
}
