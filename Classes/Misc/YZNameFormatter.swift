/*
The MIT License (MIT)
Copyright (c) 2015 Yichi Zhang
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation
import UIKit
import AddressBook

@objc open class YZNameFormatter : NSObject {
    
    @objc open func nameFrom(_ string:String, error:AutoreleasingUnsafeMutablePointer<NSError?>? = nil) throws -> YZName {
        let name = YZName()
        
        let fullName = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        var nameWithOutPrefix = fullName
        
        var regexPatternString:String
        var a:[String]
        var addtionalPatternString:String
        
        a = [ "mr", "mrs", "ms", "miss", "dr" ]
        addtionalPatternString = a.joined(separator: "|")
        
        // ((.*)Prof(\S)*\s|(Miss|Mrs|Mr|Dr)\s)
        regexPatternString = "((.*)Prof(\\S)*\\s|(\(addtionalPatternString))\\s)"
        
        var regex = try NSRegularExpression(pattern: regexPatternString, options: NSRegularExpression.Options.caseInsensitive)

        regex.enumerateMatches(
            in: fullName as String,
            options: NSRegularExpression.MatchingOptions(),
            range: fullName.range(of: fullName as String),
            using: { (result:NSTextCheckingResult?, flags:NSRegularExpression.MatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                name.prefix = fullName.substring(with: result!.range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                nameWithOutPrefix = (fullName as String).replacingOccurrences(of: name.prefix, with: "", options: NSString.CompareOptions()).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                stop.pointee = true
                return
        })
        
        a = ["vere","von","van","de","del","della","di","da","pietro","vanden","du","st.","st","la","ter"]
        addtionalPatternString = a.joined(separator: "|")
        
        regexPatternString = "\\s(\(addtionalPatternString))\\s"

        regex = try NSRegularExpression(pattern: regexPatternString, options: NSRegularExpression.Options.caseInsensitive)

        regex.enumerateMatches(
            in: nameWithOutPrefix as String,
            options: NSRegularExpression.MatchingOptions(),
            range: nameWithOutPrefix.range(of: nameWithOutPrefix as String),
            using: { (result:NSTextCheckingResult?, flags:NSRegularExpression.MatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                name.lastName = nameWithOutPrefix.substring(from: result!.range.location).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                name.firstName = (nameWithOutPrefix as String).replacingOccurrences(of: name.lastName, with: "", options: NSString.CompareOptions()).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                stop.pointee = true
                return
        })
        
        if name.lastName.isEmpty == true {
            // No "Van Den Acker" style last name is found
            // Look for "Hall-Van Den Acker" style last name
            
            // \s\w*-\w*\s
            regexPatternString = "\\s\\w*-\\w*\\s"
            
            regex = try NSRegularExpression(pattern: regexPatternString, options: NSRegularExpression.Options.caseInsensitive)
            
            regex.enumerateMatches(
                in: nameWithOutPrefix as String,
                options: NSRegularExpression.MatchingOptions(),
                range: nameWithOutPrefix.range(of: nameWithOutPrefix as String),
                using: { (result:NSTextCheckingResult?, flags:NSRegularExpression.MatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    name.lastName = nameWithOutPrefix.substring(from: result!.range.location).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    name.firstName = (nameWithOutPrefix as String).replacingOccurrences(of: name.lastName, with: "", options:NSString.CompareOptions()).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    stop.pointee = true
                    return
            })
        }
        
        if name.lastName.isEmpty == true {
            // No "Van Den Acker" or "Hall-Van Den Acker" style last name is found
            
            let lastWhiteSpaceRange = nameWithOutPrefix.range(of: " ", options: NSString.CompareOptions.backwards)
            
            if lastWhiteSpaceRange.location == NSNotFound {
                if name.prefix.isEmpty == true {
                    // If no prefix is found, and no space is found, the string is probably first name only
                    name.firstName = nameWithOutPrefix as String
                } else {
                    // If a prefix is found, and no space is found in the rest of the name, the string is probably
                    // a combination of prefix and last name, e.g. something like "Mr McLean"
                    name.lastName = nameWithOutPrefix as String
                }
            } else {
                // A space is found. Take the portion behind the space as the last name and the rest as the first name.
                name.firstName = nameWithOutPrefix.substring(to: lastWhiteSpaceRange.location)
                name.lastName = nameWithOutPrefix.substring(from: NSMaxRange(lastWhiteSpaceRange))
            }
        }
        
        return name
    }
}

@objc open class YZName : NSObject {
    @objc open var prefix = ""
    @objc open var firstName = ""
    @objc open var lastName = ""
}
