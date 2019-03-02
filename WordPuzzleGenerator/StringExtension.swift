//
//  Word.swift
//  WordPuzzleGenerator
//
//  Created by Andrew Napier on 21/2/19.
//  Copyright © 2019 Andrew Napier. All rights reserved.
//

import Foundation

extension String {
    func getLetter(offset : Int) -> Character {
        if offset < 0 || offset >= self.count {
            return Character("")
        }
        let index = String.Index(encodedOffset: offset)
        return self[index...index].first ?? Character("")
    }
}
