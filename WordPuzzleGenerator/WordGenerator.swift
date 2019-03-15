//
//  WordGenerator.swift
//  WordPuzzleGenerator
//
//  Created by Andrew Napier on 15/3/19.
//  Copyright © 2019 Andrew Napier. All rights reserved.
//

import Foundation

struct WordGenerator {
    let words = ["EDITION",
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
                    "BELOW", "COMPLETE", "CONSTANT", "DERIVES", "DOUBT", "EARLY", "EVERY", "FEED", "FEELING", "ILLEGAL", "ISOLATE", "ITEM", "MODIFYING", "MONEY", "PARALLEL", "PLEASING", "REGARDED", "SEEMING", "SHARING", "TRULY", "UNLIKELY", "UPPER",
                    "ABSOLUTELY",
                    //"ACCEPTED",
        "ACCLAIMED",
        //"ACCOMPLISH",
        "ACCOMPLISHMENT",
        "ACHIEVEMENT",
        "ACTION",
        "ADMIRE",
        "ADORABLE",
        "ADVENTURE",
        //"AFFIRMATIVE",
        "AFFLUENT",
        //2345678901
        "AGREEABLE",
        "AMAZING",
        "ANGELIC",
        //"APPEALING",
        "AWESOME"
    ]

    func getWordsInDescendingLength() -> [String] {
        var listCopy = self.words
        listCopy.sort { (word1, word2) -> Bool in
            return word1.count > word2.count
        }
        return listCopy
    }
}
