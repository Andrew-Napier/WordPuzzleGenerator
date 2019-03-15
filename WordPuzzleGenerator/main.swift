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

enum WordError : Error {
    case failedToWord
}

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

var lettersGrid = PuzzleBoard.Board(puzzleSize)
var placeGenerator = PuzzleBoard.PlacementChecker(boardSize: puzzleSize)
var wordGenerator = WordGenerator()

var wordsFitted = 1
var rejects = [String]()

for word in wordGenerator.getWordsInDescendingLength() {
    var spotForWord = false
    let lengthOfWord = word.count
    var bestPossible : PuzzleBoard.StartingPosition?

    let possibles = placeGenerator.getPossibilityArray(forWordLength: lengthOfWord)
    for possibility in possibles {
        spotForWord = true
        
        var intersects = 0
        for i in 0..<lengthOfWord {
            let c = word.getLetter(offset: i)
            let row = possibility.row + (possibility.direction.rowDirection() * i)
            let col = possibility.col + (possibility.direction.colDirection() * i)
            
            if lettersGrid.isMatching(c, atRow: row, andCol: col){
                intersects += 1
            } else if !lettersGrid.isEmpty(atRow: row, andCol: col) {
                spotForWord = false
            }
        }
        if spotForWord && (intersects > bestPossible?.intersects ?? -1) {
            bestPossible = PuzzleBoard.StartingPosition(possibility, intersections: intersects)
        }
    }
    
    if let placement = bestPossible {
        lettersGrid = lettersGrid.addWord(word, at: placement)
        print("-\(wordsFitted) \(word) ") //\(placement.intersects)")
        wordsFitted += 1
    } else {
        rejects.append(word)
    }
}

let correctLength = lettersGrid.blanksRemaining
var possibleBlats = rejects.filter { (sampleWord) -> Bool in
    return sampleWord.count == correctLength
}
if possibleBlats.count > 0 {
    guard let wordToBlat = possibleBlats.randomElement() else {
        throw WordError.failedToWord
    }
    
    lettersGrid = lettersGrid.blatWord(wordToBlat)
    lettersGrid.displayGrid()
} else {
    print("We were left with \(correctLength) spots, and no words of that length")
    lettersGrid.displayGrid()
}

// print grid...
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
