//
//  PuzzleBoard.swift
//  WordPuzzleGenerator
//
//  Created by Andrew Napier on 21/2/19.
//  Copyright © 2019 Andrew Napier. All rights reserved.
//

import Foundation

enum PuzzleBoard {
    struct PlacementChecker {
        let maxSize : Int;
        
        init(boardSize : Int) {
            self.maxSize = boardSize
        }
        
        func getPossibilityArray(forWordLength length : Int) -> [StartingPosition] {
            var array = [StartingPosition]()
            for r in 0..<self.maxSize {
                for c in 0..<self.maxSize {
                    for d in WordDirections.allCases {
                        if isWordFitting(forWordLength: length, row: r, col: c, direction: d) {
                            array.append(StartingPosition(row: r, col: c, direction: d))
                        }
                    }
                }
            }
            array.shuffle()
            return array
        }
        
        func isWordFitting(forWordLength length : Int, row r: Int, col c : Int, direction d : WordDirections) -> Bool {
            return
                r + (d.rowDirection() * length) >= 0
                && r + (d.rowDirection() * length) <= maxSize
                && c + (d.colDirection() * length) >= 0
                && c + (d.colDirection() * length) <= maxSize
        }
    }
    
    struct StartingPosition {
        let row : Int
        let col : Int
        let direction : WordDirections
        let intersects : Int
        
        init(row r : Int, col c : Int, direction d : WordDirections) {
            self.col = c
            self.row = r
            self.direction = d
            self.intersects = 0
        }
        
        init(_ input : StartingPosition, intersections intersects : Int) {
            self.col = input.col
            self.row = input.row
            self.direction = input.direction
            self.intersects = intersects
        }
    }
    
    struct PlacementChooser {
        var directionScores : Dictionary<WordDirections, Int>
        
        init(counts c : Dictionary<WordDirections,Int>) {
            directionScores = c
        }
        
        func chooseBestPlacementOption(_ opt1 : StartingPosition,
                                       _ opt2: StartingPosition?) -> StartingPosition {
            guard let safe2 = opt2 else {
                return opt1
            }
            
            if opt1.intersects == safe2.intersects {
                if directionScores[opt1.direction] ?? 0
                    <= directionScores[safe2.direction] ?? 0 {
                    return opt1
                } else {
                    return safe2
                }
            } else {
                if opt1.intersects <= safe2.intersects {
                    return opt1
                } else {
                    return safe2
                }
            }
        }
        
        func display() {
            var output = ""
            for direction in directionScores {
                output = output + "\(direction.key):\(direction.value), "
            }
            print(output)
        }        
    }
    
    struct Board {
        let lettersGrid : Array<Array<Character>>
        
        var blanksRemaining: Int {
            get {
                var count = 0
                let puzzleSize = lettersGrid.count
                for r in 0..<puzzleSize {
                    for c in 0..<puzzleSize {
                        if isEmpty(atRow: r, andCol: c) {
                            count += 1
                        }
                    }
                }
                return count
            }
        }
        
        init(_ puzzleSize : Int) {
            lettersGrid = Array(repeating: Array(repeating: Character("."), count: puzzleSize), count: puzzleSize)
        }
        
        init(_ grid : Array<Array<Character>>) {
            lettersGrid = grid
        }
        
        func addWord(_ word : String, at position : StartingPosition) -> Board {
            var newGrid = lettersGrid

            for i in 0..<word.count {
                let row = position.row + (position.direction.rowDirection() * i)
                let col = position.col + (position.direction.colDirection() * i)
                newGrid[row][col] = word.getLetter(offset: i)
            }
            
            return Board(newGrid)
        }
        
        func blatWord(_ word : String) -> Board {
            var newGrid = lettersGrid
            let puzzleSize = lettersGrid.count

            var i = 0
            for row in 0..<puzzleSize {
                for col in 0..<puzzleSize {
                    if isEmpty(atRow: row, andCol: col) {
                        newGrid[row][col] = word.getLetter(offset: i)
                        i += 1
                    }
                }
            }
            
            return Board(newGrid)
        }
        
        func isEmpty(atRow row : Int, andCol col : Int) -> Bool {
            return lettersGrid[row][col] == "."
        }
        
        func isMatching(_ letter : Character, atRow row : Int, andCol col : Int) -> Bool {
            return lettersGrid[row][col] == letter
        }
        
        func displayGrid() {
            let puzzleSize = lettersGrid.count
            for r in 0..<puzzleSize {
                var row = ""
                for c in 0..<puzzleSize {
                    row.append(" \(lettersGrid[r][c])")
                }
                print("\(row)")
            }
        }
    }
}
