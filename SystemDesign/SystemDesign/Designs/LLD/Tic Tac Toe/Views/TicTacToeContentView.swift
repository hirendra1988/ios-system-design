//
//  TicTacToeContentView.swift
//  SystemDesign
//
//  Created by Hirendra Sharma on 03/08/25.
//

import SwiftUI

struct TicTacToeContentView: View {
    
    @StateObject var viewModel = TicTacToeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(titleText)
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<3, id: \.self) { col in
                            CellView(player: viewModel.board[row][col])
                                .onTapGesture {
                                    if viewModel.status == .inProgress {
                                        viewModel.makeMove(row: row, col: col)
                                    }
                                }
                        }
                    }
                }
            }
            .padding()
            
            Button("Restart Game") {
                viewModel.resetGame()
            }
            .padding()
        }
        .padding()
    }
    
    private var titleText: String {
        switch viewModel.status {
        case .inProgress:
            return "Turn: \(viewModel.currentPlayer.rawValue)"
        case .draw:
            return "Its draw"
        case .win(let player):
            return "Winner: \(player.rawValue)"
        }
    }
}

struct CellView: View {
    let player: Player?
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.blue)
                .opacity(0.7)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            Text(player?.rawValue ?? "")
                .font(.system(size: 50))
                .bold()
                .foregroundStyle(.white)
                .scaleEffect(player == nil ? 0 : 1)
                .animation(.spring(), value: player)
        }
    }
}
