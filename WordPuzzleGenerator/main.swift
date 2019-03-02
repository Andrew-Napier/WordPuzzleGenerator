//
//  main.swift
//  WordPuzzleGenerator
//
//  Created by Andrew Napier on 11/2/19.
//  Copyright © 2019 Andrew Napier. All rights reserved.
//

import Foundation

print("Hello, World!")
let puzzleSize = 11
let wordList = ["EDITION",
                "DESIGN",
                "DIRECTION",
                "MAGAZINE",
                "COMPANION",
                "GROUPS",
                "MEMBERS"]

enum WordDirections : CaseIterable {
    case north, northeast,east,southeast,south,southwest,west,northwest
    
    func rowDirection() -> Int {
        switch self {
        case .northeast, .northwest, .north:
            return -1
            
        case .south, .southeast, .southwest:
            return +1
        default:
            return 0
        }
    }
    
    func colDirection() -> Int {
        switch self {
        case .northwest, .west, .southwest:
            return -1
            
        case .northeast, .east, .southeast:
            return 1
            
        default:
            return 0
        }
    }
}

var lettersGrid = Array(repeating: Array(repeating: Character("."), count: puzzleSize), count: puzzleSize)
var placeGenerator = PuzzleBoard.PlacementChecker(boardSize: puzzleSize)

for word in wordList {
    var spotForWord = false
    let lengthOfWord = word.count
    let possibles = placeGenerator.getPossibilityArray(forWordLength: lengthOfWord)
    for possibility in possibles {
        spotForWord = true
        for i in 0..<lengthOfWord {
            let c = word.getLetter(offset: i)
            let row = possibility.row + (possibility.direction.rowDirection() * i)
            let col = possibility.col + (possibility.direction.colDirection() * i)
            
            if lettersGrid[row][col] != "." &&
                lettersGrid[row][col] != c {
                spotForWord = false
                break
            }
        }
        if spotForWord {
            for i in 0..<lengthOfWord {
                let row = possibility.row + (possibility.direction.rowDirection() * i)
                let col = possibility.col + (possibility.direction.colDirection() * i)
                lettersGrid[row][col] = word.getLetter(offset: i)
            }
            break
        }
    }
}


// print grid...
for r in 0..<puzzleSize {
    var row = ""
    for c in 0..<puzzleSize {
        row.append(lettersGrid[r][c])
    }
    print("\(row)")
}
