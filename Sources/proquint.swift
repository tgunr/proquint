//
//  main.swift
//  proquint
//
//  Created by Dave Carlton on 1/11/24.
//

//  This file is part of proquint: http://github.com/dsw/proquint .
// See License.txt for copyright and terms of use.

import Foundation

// Map uints to consonants.
let uint2consonant: [Character] = [
    "b", "d", "f", "g",
    "h", "j", "k", "l",
    "m", "n", "p", "r",
    "s", "t", "v", "z"
]

// Map uints to vowels.
let uint2vowel: [Character] = [
    "a", "i", "o", "u"
]

func uint2quint(quint: inout [Character], i: UInt32, sepChar: Int) {
    var j: UInt32 = 0
    var k: UInt32 = i
    func append(_ x: Character) {
        quint.append(x)
    }
    
    func handleConsonant() {
        j = k & 0xF0000000
        k <<= 4
        j >>= 28
        append(uint2consonant[Int(j)])
    }
    
    func handleVowel() {
        j = k & 0xC0000000
        k <<= 2
        j >>= 30
        append(uint2vowel[Int(j)])
    }
    
    handleConsonant()
    handleVowel()
    handleConsonant()
    handleVowel()
    handleConsonant()
    
    if sepChar != 0 {
        append(Character(UnicodeScalar(sepChar)!))
    }
    
    handleConsonant()
    handleVowel()
    handleConsonant()
    handleVowel()
    handleConsonant()
}

func quint2uint(quint: String) -> UInt32 {
    var res: UInt32 = 0
    
    for c in quint {
        switch c {
        // consonants
        case "b": res <<= 4; res += 0
        case "d": res <<= 4; res += 1
        case "f": res <<= 4; res += 2
        case "g": res <<= 4; res += 3
        case "h": res <<= 4; res += 4
        case "j": res <<= 4; res += 5
        case "k": res <<= 4; res += 6
        case "l": res <<= 4; res += 7
        case "m": res <<= 4; res += 8
        case "n": res <<= 4; res += 9
        case "p": res <<= 4; res += 10
        case "r": res <<= 4; res += 11
        case "s": res <<= 4; res += 12
        case "t": res <<= 4; res += 13
        case "v": res <<= 4; res += 14
        case "z": res <<= 4; res += 15
        // vowels
        case "a": res <<= 2; res += 0
        case "i": res <<= 2; res += 1
        case "o": res <<= 2; res += 2
        case "u": res <<= 2; res += 3
        // separators
        default: break
        }
    }
    
    return res
}

func my_atoi(base: Int, s: String) -> UInt32 {
    let sOrig = s
    var ret: UInt32 = 0
    
    for c in s {
        var value = -1
        
        switch c {
        // decimal digits
        case "0": value = 0
        case "1": value = 1
        case "2": value = 2
        case "3": value = 3
        case "4": value = 4
        case "5": value = 5
        case "6": value = 6
        case "7": value = 7
        case "8": value = 8
        case "9": value = 9
        case "a", "A": value = 10
        case "b", "B": value = 11
        case "c", "C": value = 12
        case "d", "D": value = 13
        case "e", "E": value = 14
        case "f", "F": value = 15
        // illegal characters
        default:
            fatalError("Illegal character in uint-word '\(sOrig)': '\(c)'.")
        }
        
        if value < 0 {
            fatalError("This cannot happen.")
        }
        if value >= base {
            fatalError("Numbers of base \(base) may not contain the digit '\(c)': '\(sOrig)'.")
        }
        
        ret *= UInt32(base)
        ret += UInt32(value)
    }
    
    return ret
}

public func toQuint(_ i: UInt32) -> String {
    var quint: [Character] = []
    uint2quint(quint: &quint, i: i, sepChar: Int("-".unicodeScalars.first!.value))
    return String(quint)
}

public func convertNumber(base: Int, s: String) {
    let n = my_atoi(base: base, s: s)
    let quint = toQuint(n)
    print(quint, terminator: " ")
}

public func fromQuint(_ s: String) -> UInt32 {
    let uint0 = quint2uint(quint: s)
    return uint0
}

public func convertQuint(s: String) {
    let uint0 = fromQuint(s)
    print("x\(String(uint0, radix: 16)) ", terminator: "")
}

func main(argc: Int32, argv: [String]) {
    var argc = argc
    var argv = argv
    
    argc -= 1
    argv.removeFirst()
    
    for s in argv {
        if s.isEmpty {
            continue
        }
        
        if s.hasPrefix("0") {
            fatalError("Do not lead input strings with a zero.\nFor decimal, trim leading zeros.\nFor hex, lead with an 'x'.\nWe do not process octal.")
        } else if s.hasPrefix("x") || s.hasPrefix("X") {
            convertNumber(base: 16, s: String(s.dropFirst()))
        } else if s.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
            convertNumber(base: 10, s: s)
        } else {
            convertQuint(s: s)
        }
    }
    
    print("")
}

// main(argc: CommandLine.argc, argv: Array(CommandLine.arguments))

