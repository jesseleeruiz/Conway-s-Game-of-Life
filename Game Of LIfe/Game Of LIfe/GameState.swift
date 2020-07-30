//
//  GameState.swift
//  Game Of LIfe
//
//  Created by Jesse Ruiz on 7/28/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import Foundation

struct GameState {
    var cells: [Cell] = []
    
    subscript(index: Int) -> Cell {
        get {
            return cells[index]
        } set {
            cells[index] = newValue
        }
    }
}

extension GameState: Equatable {
    public static func == (lhs: GameState, rhs: GameState) -> Bool {
        for lhsCell in lhs.cells {
            for rhsCell in rhs.cells {
                if lhsCell.isAlive != rhsCell.isAlive {
                    return false
                }
            }
        }
        return true
    }
}
