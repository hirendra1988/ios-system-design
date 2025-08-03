//
//  GameStatus.swift
//  SystemDesign
//
//  Created by Hirendra Sharma on 03/08/25.
//

import Foundation

/// Represents the current status of the game
enum GameStatus: Equatable {
    case inProgress
    case draw
    case win(Player)
}
