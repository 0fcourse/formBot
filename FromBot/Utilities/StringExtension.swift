//
//  StringExtension.swift
//  jawaz
//
//  Created by Marwan Aziz on 01/08/2018.
//  Copyright © 2018 Marwan Aziz. All rights reserved.
//

import Foundation
import UIKit
extension String {

    func hasEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }

        return false
    }

    var isAlphanumeric: Bool {
        return isValidCharacters(includeNumbers: true)
    }
    var isAlphabet: Bool {
        return isValidCharacters(includeNumbers: false)
    }

    private func isValidCharacters(includeNumbers: Bool) -> Bool {
        if isEmpty {
            return false
        }
        var alphanumeric = alphabets
        if includeNumbers {
            alphanumeric.append(contentsOf: numbers)
        }
        let lettersSet = NSSet(array: alphanumeric)
        var selfArray = [String]()
        for achar in self {
            selfArray.append("\(achar)")
        }
        let selfSet = NSSet(array: selfArray)
        if selfSet.isSubset(of: lettersSet as! Set<AnyHashable>) {
            return true
        }
        return false
    }
    private var alphabets: [String] {
        var set = UILocalizedIndexedCollation.current().sectionIndexTitles
        set.removeLast()
        let smallEnglishLetters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        set.append(contentsOf: smallEnglishLetters)
        return set
    }

    private var numbers: [String] {
        let numbers = ["0","1","2","3","4","5","6","7","8","9"]
        var allNumbers = numbers
        for num in numbers {
            let arabicNum = NSNumber(value: Int(num)!)
            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            allNumbers.append(formater.string(from: arabicNum)!)
        }
        return allNumbers
    }
}
