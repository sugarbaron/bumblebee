//
//  DataAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public extension Data {

    var string: String? { String(data: self, encoding: .utf8) }

    func string(encoding: String.Encoding) -> String? { String(data: self, encoding: encoding) }

    var hexString: String? { (self as NSData).hexString }
}

@objc
public extension NSData {

    var hexString: String? {
        guard self.count > 0 else { return nil }

        let charBuffer = [UInt8] (self as Data)
        var stringBuffer: String = .init()

        charBuffer.forEach { stringBuffer.append(String(format: "%02x", $0)) }

        return stringBuffer
    }

}
