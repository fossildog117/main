//
//  main.swift
//  decrypt
//
//  Created by Nathan Liu on 31/01/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import Foundation
import Darwin

var input = "3961292551731330615108831690847202883016961"

let key = "5554"

var output = ""
let power = 6
var num = Int()

func getRange(cipher: String, var x: String) -> Void {
    
    let range = x.endIndex.advancedBy(Int(cipher)! + power - x.characters.count)..<x.endIndex
    x.removeRange(range)
    
    print(x)
    
    num = x.characters.count
    
    let upperCaseLetters = ["A","B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", " "]
    
    let z = CDouble(x)!/1000000
    let number = CDouble(76 * sin(z * (M_PI/180)))
    
    output = output + upperCaseLetters[Int(round(number))]
    
}

func minus(var word: String, var encryptedText: String) -> String {
    
    let number = String(word.removeAtIndex(word.startIndex))
    
    getRange(number, x: encryptedText)
    
    encryptedText = encryptedText.substringWithRange(Range<String.Index>(start: encryptedText.startIndex.advancedBy(num), end: encryptedText.endIndex.advancedBy(0)))
    
    if word == "" {
        return output
    } else {
        return minus(word, encryptedText: encryptedText)
    }
}

print(minus(key,encryptedText: input))
