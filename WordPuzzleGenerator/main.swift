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
var wordList = ["EDITION",
                "DESIGN",
                "DIRECTION",
                "MAGAZINE",
                "COMPANION",
                "GROUPS",
                "MEMBERS",
                "PRECISE",
"DRUMMER", "PAINTING",
"EASY",
"WHAT",
"COMMIT","MODERN","RUIN", "RECORD", "TEMPLE", "MONK", "BOWL", "CAVE",
"BELOW", "COMPLETE", "CONSTANT", "DERIVES", "DOUBT", "EARLY", "EVERY", "FEED", "FEELING", "ILLEGAL", "ISOLATE", "ITEM", "MODIFYING", "MONEY", "PARALLEL", "PLEASING", "REGARDED", "SEEMING", "SHARING", "TRULY", "UNLIKELY", "UPPER"
]

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

wordList.sort { (word1, word2) -> Bool in
    return word1.lengthOfBytes(using: .ascii) >
        word2.lengthOfBytes(using: String.Encoding.ascii)
}
var wordsFitted = 1

for word in wordList {
    var spotForWord = false
    let lengthOfWord = word.count
    var bestPossible : PuzzleBoard.PossibleStart?

    let possibles = placeGenerator.getPossibilityArray(forWordLength: lengthOfWord)
    for possibility in possibles {
        spotForWord = true
        
        var intersects = 0
        for i in 0..<lengthOfWord {
            let c = word.getLetter(offset: i)
            let row = possibility.row + (possibility.direction.rowDirection() * i)
            let col = possibility.col + (possibility.direction.colDirection() * i)
            
            if lettersGrid[row][col] == c {
                intersects += 1
            } else if lettersGrid[row][col] != "." {
                spotForWord = false
            }
        }
        if spotForWord && (intersects > bestPossible?.intersects ?? -1) {
            bestPossible = PuzzleBoard.PossibleStart(possibility, intersections: intersects)
        }
    }
    
    if let placement = bestPossible {
        for i in 0..<lengthOfWord {
            let row = placement.row + (placement.direction.rowDirection() * i)
            let col = placement.col + (placement.direction.colDirection() * i)
            lettersGrid[row][col] = word.getLetter(offset: i)
        }
        print("-\(wordsFitted) \(word) \(placement.direction)")
        wordsFitted += 1
        break
    }
}


// print grid...
var blanksCount = 0
for r in 0..<puzzleSize {
    var row = ""
    for c in 0..<puzzleSize {
        row.append(" \(lettersGrid[r][c])")
        if lettersGrid[r][c] == "." {
            blanksCount+=1
        }
    }
    print("\(row)")
}
print(blanksCount)
/*
if let wordsFilePath = Bundle.main.path(forResource: "web2", ofType: nil) {
    do {
        let wordsString = try String(contentsOfFile: wordsFilePath)
        
        let wordLines = wordsString.components(separatedBy: .newlines)
        
        let randomLine = wordLines[numericCast(arc4random_uniform(numericCast(wordLines.count)))]
        
        print(randomLine)
        
    } catch { // contentsOfFile throws an error
        print("Error: \(error)")
    }
}
*/
