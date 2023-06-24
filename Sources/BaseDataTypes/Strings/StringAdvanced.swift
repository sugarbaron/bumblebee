//
//  StringAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import UIKit

public extension String {

    init(bytes: [UInt8]) throws {
        guard let string: String = .init(bytes: bytes, encoding: .utf8) else {
            throw Exception("bad encoding")
        }
        self = string
    }
    
    var int: Int? { Int(self) }

    var isNotEmpty: Bool { !(isEmpty) }
    
    func replace(_ sequence: String, with replacement: String) -> String {
        replacingOccurrences(of: sequence, with: replacement)
    }
    
    func without(all sequence: String) -> String { replacingOccurrences(of: sequence, with: "") }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect: CGSize = .init(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect: CGSize = .init(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)

        return ceil(boundingBox.width)
    }

    var toIdentifier: String {
        let trimmedString: FlattenSequence<Array<String>> = self.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedIdentifierString: String = ""

        if arrOfCharacters.count > 0 {
            for i in 0...arrOfCharacters.count-1 {
                modifiedIdentifierString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count) { modifiedIdentifierString.append(" ") }
            }
        }
        return modifiedIdentifierString
    }

    func getString(from lowerInput: String, to upperInput: String) -> String? {
        guard let fromRange = range(of: lowerInput),
              let toRange = range(of: upperInput, options: .backwards),
              fromRange.lowerBound < toRange.lowerBound
        else { return nil }
        return String(self[fromRange.upperBound...toRange.lowerBound]).safePopLast()
    }

    func safePopLast() -> String {
        var string = self
        _ = string.popLast()
        return string
    }

    /**
     * this method converts string like "DEADBEEF" to Data (DE AD BE EF)
     */
    func hexadecimal() throws -> Data {
        let errorDescription = "can't convert string to data"
        let prepared = self.without(all: " ")
        guard (count % 2) == 0 else { throw Exception(errorDescription) }
        var isOk: Bool = true
        var data = Data(capacity: count / 2)
        let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex?.enumerateMatches(in: prepared, range: NSRange(startIndex..., in: prepared)) { match, _, _ in
            guard let match: NSTextCheckingResult = match else { isOk = false; return }
            let byteString: String = (prepared as NSString).substring(with: match.range)
            guard let num: UInt8 = .init(byteString, radix: 16) else { isOk = false; return }
            data.append(num)
        }

        guard isOk, data.count == (prepared.count / 2) else {
            throw Exception(errorDescription)
        }

        return data
    }

    func containsCaseInsensitive(_ substring: String) -> Bool {
        self.range(of: substring, options: .caseInsensitive) != nil
    }
    
    func split(with separator: String) -> [String] { components(separatedBy: separator) }

    var firstLetters: String {
        var filtered: String = self
        filtered.removeAll(where: { $0.isPunctuation } )
        let firstLetters: [Character] = filtered.uppercased().components(separatedBy: " ").compactMap ({ $0.first })
        return String(firstLetters)
    }
    
    var urlDecoded: String? { removingPercentEncoding }
    
    var url: URL? { .init(self) }

}

public extension Optional where Wrapped == String {

    var isNilOrEmpty: Bool { unwrap(self) { $0.isEmpty } ?? true }
    
    var url: URL? { unwrap(self) { $0.url } }

}

public extension Array where Element == String {

    var joined: String { joined(separator: ", ") }

    func joined(by separator: String) -> String { joined(separator: separator) }

}

public extension Array where Element == String? {

    var joined: String { compactMap { $0 }.joined(separator: ", ") }

    func joined(by separator: String) -> String { compactMap { $0 }.joined(separator: separator) }

}
