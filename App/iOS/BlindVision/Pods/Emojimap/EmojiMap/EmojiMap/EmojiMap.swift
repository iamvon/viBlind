//
//  EmojiMap.swift
//  EmojiMap
//
//  Created by Matias Villaverde on 17.11.17.
//
//

import Foundation

// Mapping of the regular text to emoji characters
public typealias WordToEmojiMapping = [String : [String]]

/// `Match` class keeps information about a single word that can be replaced with an emoji.
public struct Match {
    
    public let string: String
    public let emoji: String
    
    public init(string: String, emoji: String) {
        self.string = string
        self.emoji = emoji
    }
}


/// Tool to get the possible match from a word to an emoji.
open class EmojiMap {
    
    public init() {}
    
    /// Database of emojis in the user language
    lazy var mapping = self.defaultTextToEmojiMapping()
    
    /// Get the match of all the emojis that can represent words of the input string
    ///
    /// - Parameter inputString: String in EN, DE, FR or ES
    /// - Returns: array of Matches that contains the emoji and the word
    public func getMatchesFor(_ inputString: String) -> [Match] {
        
        // Output array.
        var outPut = [Match]()
        
        // Separe the string in words.
        for word in inputString.lowercased().components(separatedBy: " ") {
            
            // Get match searching on emoji db
            if let matches = mapping[word] {
                for mapped in matches {
                    let match = Match(string: word, emoji: mapped)
                    outPut.append(match)
                }
            }
        }
        
        // Return output
        return outPut
    }
    
    /// Search for the emoji db in the current language of the user. Currently supported only EN, DE, FR and ES
    ///
    /// - Returns: Mapping of the regular text to emoji characters
    public func defaultTextToEmojiMapping() -> WordToEmojiMapping {
        
        var mapping: WordToEmojiMapping = [:]
        
        func addKey(_ key: String, value: String, atBeginning: Bool) {
            
            if mapping[key] == nil {
                mapping[key] = []
            }
            
            if atBeginning {
                mapping[key]?.insert(value, at: 0)
            } else {
                mapping[key]?.append(value)
            }
        }
        
        // Order the json in a dictionary
        for (key, value) in emojiDataBase() {
            if let key = key as? String,
                let dictionary = value as? Dictionary<String, AnyObject>,
                let emojiCharacter = dictionary["char"] as? String {
                
                // Dictionary keys from emojis.json have higher priority then keywords.
                // That's why they're added at the beginning of the array.
                addKey(key, value: emojiCharacter, atBeginning: true)
                
                // Keywords have a lower priority than dictionary keys, are added at the end.
                if let keywords = dictionary["keywords"] as? [String] {
                    for keyword in keywords {
                        addKey(keyword.lowercased(), value: emojiCharacter, atBeginning: false)
                    }
                }
            }
        }
        
        return mapping
    }
    
    
    /// Search for the emoji JSON db in main or pod bundle
    ///
    /// - Returns: returns a dictionary with the JSON content.
    func emojiDataBase() -> NSDictionary {
        
        // Language
        let fullLanguage = Locale.preferredLanguages[0]
        var pre = String(fullLanguage.prefix(2))
        pre = "-" + pre
        
        // Search for file in main bundle
        if let file = Bundle(for: EmojiMap.self).path(forResource: "EmojiDataBase.bundle/emojis" + pre, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: file)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDictionary = json as? NSDictionary {
                return jsonDictionary
        }
        
        // Search for file in main bundle
        guard let podfile = Bundle(for: EmojiMap.self).path(forResource: "Emojimap.bundle/emojis" + pre, ofType: "json"),
            let poddata = try? Data(contentsOf: URL(fileURLWithPath: podfile)),
            let podjson = try? JSONSerialization.jsonObject(with: poddata, options: []),
            let podjsonDictionary = podjson as? NSDictionary else {
                print("Error finding the emoji for the language \(pre)")
                return [:]
        }
        return podjsonDictionary
    }
}

