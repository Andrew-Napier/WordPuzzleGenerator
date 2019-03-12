//
//  PuzzlePlacementChecker.swift
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
        
        func getPossibilityArray(forWordLength length : Int) -> [PossibleStart] {
            var array = [PossibleStart]()
            for r in 0..<self.maxSize {
                for c in 0..<self.maxSize {
                    for d in WordDirections.allCases {
                        if isWordFitting(forWordLength: length, row: r, col: c, direction: d) {
                            array.append(PossibleStart(row: r, col: c, direction: d))
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
    
    struct PossibleStart {
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
        
        init(_ input : PossibleStart, intersections intersects : Int) {
            self.col = input.col
            self.row = input.row
            self.direction = input.direction
            self.intersects = intersects
        }
    }
}
