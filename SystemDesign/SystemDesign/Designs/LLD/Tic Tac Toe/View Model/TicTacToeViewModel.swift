//
//  TicTacToe.swift
//  SystemDesign
//
//  Created by Hirendra Sharma on 03/08/25.
//

import SwiftUI

class TicTacToeViewModel: ObservableObject {
    @Published var board: [[Player?]] = [[Player?]](repeating: [Player?](repeating: nil, count: 3), count: 3)
    @Published var currentPlayer: Player = .x
    @Published var status: GameStatus = .inProgress
    
    var isSoloMode = true
    
    /// Handles a player's move
    func makeMove(row: Int, col: Int) {
        guard board[row][col] == nil, status == .inProgress else { return }
        board[row][col] = currentPlayer
        if checkWin(for: currentPlayer) {
            status = .win(currentPlayer)
            return
        }
        if isDraw() {
            status = .draw
            return
        }
        
        currentPlayer = currentPlayer == .x ? .o : .x
        
        if isSoloMode && currentPlayer == .o {
            performAIMode()
        }
        
    }
    
    /// Checks if the specified player has won
    private func checkWin(for player: Player) -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            let rowWin = (0..<3).allSatisfy( { board[i][$0] == player })
            let colWin = (0..<3).allSatisfy( { board[$0][i] == player })
            
            if rowWin || colWin {
                return true
            }
        }
        
        // Check diagonals
        let diag1Win = (0..<3).allSatisfy( { board[$0][$0] == player })
        let diag2Win = (0..<3).allSatisfy( { board[$0][2-$0] == player })

        return diag1Win || diag2Win
    }
    
    /// Checks for draw condition (i.e., all cells are filled)
    private func isDraw() -> Bool {
        return !board.flatMap { $0 }.contains(nil)
    }
    
    /// Performs AI move for solo mode
    private func performAIMode() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let (row, col) = self.findBestMove(for: self.currentPlayer) {
                self.makeMove(row: row, col: col)
            }
        }
    }
    
    /// Finds the best possible move for the current player
    private func findBestMove(for player: Player) -> (Int, Int)? {
        // 1. Try to win
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col] == nil {
                    board[row][col] = player
                    if checkWin(for: player) {
                        board[row][col]  = nil
                        return (row, col)
                    }
                    board[row][col]  = nil
                }
            }
        }
        
        // 2. Block opponent's win
        let opponent: Player = player == .x ? .o : .x
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col] == nil {
                    board[row][col] = opponent
                    if checkWin(for: opponent) {
                        board[row][col] = nil
                        return (row, col)
                    }
                    board[row][col]  = nil
                }
            }
        }
        
        // 3. Take center if free
        if board[1][1] == nil {
            return (1, 1)
        }
        
        // 4. Take a random corner
        let corners = [(0,0),(2,0),(0,2),(2,2)].shuffled()
        for (row, col) in corners {
            if board[row][col] == nil {
                return (row, col)
            }
        }
        
        // 5. Take any available cell
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col] == nil {
                    return (row, col)
                }
            }
        }
        
        return nil
    }
    
    /// Resets the game to its initial state
    func resetGame() {
        currentPlayer = .x
        status = .inProgress
        board = [[Player?]](repeating: [Player?](repeating: nil, count: 3), count: 3)
    }
}
