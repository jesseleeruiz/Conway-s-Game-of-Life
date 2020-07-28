//
//  CellModel.swift
//  Game Of LIfe
//
//  Created by Jesse Ruiz on 7/28/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import Foundation

struct Cell {
    var isAlive: Bool = false
    
    static func makeDeadCell() -> Cell {
        return Cell(isAlive: false)
    }
    
    static func makeLiveCell() -> Cell {
        return Cell(isAlive: true)
    }
}
