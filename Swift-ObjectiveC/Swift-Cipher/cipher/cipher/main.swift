//
//  main.swift
//  cipher
//
//  Created by Nathan Liu on 31/01/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import Foundation
import Darwin

var integerSequence: String = ""
var word1 = "rome"

func convert(number: CDouble) -> Int {
    
    let randomNumber = Int(arc4random_uniform(269))
    let dummy = ((asin(number/76)) * 180/M_PI) + Double((360 * randomNumber))
    let i: Int = Int(dummy)
    output = output + String(Int(round(1000000*dummy)))
    
    return i
    
}

func asciii(var string: String) -> Void {
    
    let firstCharacter = String(string.removeAtIndex(string.startIndex))
    var i: CDouble = 0
    
    let upperCaseLetters = ["A","B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", " "]
    
    let lowerCaseLetters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        
    while (i < CDouble(upperCaseLetters.count)) {
        
        if i < 26 {

            if firstCharacter == lowerCaseLetters[Int(i)] || firstCharacter == upperCaseLetters[Int(i)] {
                let j = convert(i)
                
                if j > 9999 {
                    integerSequence = integerSequence + "5"
                } else if j > 999 {
                    integerSequence = integerSequence + "4"
                } else if j > 99 {
                    integerSequence = integerSequence + "3"
                } else if j > 9 {
                    integerSequence = integerSequence + "2"
                } else {
                    integerSequence = integerSequence + "1"
                }
                
            }
            
        }
        
        if firstCharacter == upperCaseLetters[Int(i)] {
            let j = convert(i)
            if j > 9999 {
                integerSequence = integerSequence + "5"
            } else if j > 999 {
                integerSequence = integerSequence + "4"
            } else if j > 99 {
                integerSequence = integerSequence + "3"
            } else if j > 9 {
                integerSequence = integerSequence + "2"
            } else {
                integerSequence = integerSequence + "1"
            }
            
        }
    
    i++
    
    }
    
}

var output = ""

func minus(var word: String) -> String {
    
    asciii(word)
    word.removeAtIndex(word.startIndex)
    if word == "" {
        let key = integerSequence
        print(key)
        return output
    } else {
    return minus(word)
    }
}

print(minus(word1))
