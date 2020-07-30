//
//  Game.swift
//  Game Of LIfe
//
//  Created by Jesse Ruiz on 7/29/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import Foundation

typealias GameStateObserver = ((GameState) -> Void)?

class Game {
    let width: Int
    let height: Int
    var currentState: GameState
    var generation: Int = 0
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        let cells = Array(repeating: Cell.makeDeadCell(), count: width * height)
        currentState = GameState(cells: cells)
    }
    
    func addStateObserver(_ observer: GameStateObserver) {
        observer?(generateInitialState())
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            observer?(self.iterate())
        }
    }
    
    func setInitialState(_ state: GameState) {
        currentState = state
    }
    
    func reset() {
        self.generateInitialState()
    }
    
    @discardableResult func generateInitialState() -> GameState {
        let maxItems  = width*height - 1
        let initialStatePoints = self.generateRandom(between: 0...maxItems, count: maxItems/8)
        
        for point in initialStatePoints {
            currentState[point] = Cell.makeLiveCell()
        }
        return self.currentState
    }
    
    private func generateRandom(between range: ClosedRange<Int>, count: Int) -> [Int] {
        return Array(0...count).map { _ in
            Int.random(in: range)
        }
    }
    
    func iterate() -> GameState {
        var nextState = currentState
        for i in 0...width - 1 {
            for j in 0...height - 1 {
                let positionInTheArray = j*width + i
                nextState[positionInTheArray] = Cell(isAlive: state(x: i, y: j))
            }
        }
        self.currentState = nextState
        generation += 1
        return nextState
    }
    
    func state(x: Int, y: Int) -> Bool {
        let numberOfAliveNeighbors = aliveNeighborsCountAt(x: x, y: y)
        let position = x + y*width
        
        let wasPreviouslyAlive = currentState[position].isAlive
        if wasPreviouslyAlive {
            return numberOfAliveNeighbors == 2 || numberOfAliveNeighbors == 3
        } else {
            return numberOfAliveNeighbors == 3
        }
    }
    
    func aliveNeighborsCountAt(x: Int, y: Int) -> Int {
        var numberOfAliveNeighbors = 0
        for i in x-1...x+1 {
            for j in y-1...y+1 {
                if (i == x && y == j) || (i >= width) || (i < 0) || (j < 0) { continue }
                
                let index = j*width + i
                
                guard index >= 0 && index < width*height else { continue }
                if currentState[index].isAlive {
                    numberOfAliveNeighbors += 1
                }
            }
        }
        return numberOfAliveNeighbors
    }
}
