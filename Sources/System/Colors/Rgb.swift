//
//  Rgb.swift
//  bumblebee
//
//  Created by sugarbaron on 29.01.2023.
//

import SwiftUI
import UIKit

// MARK: constructor
/// a color with each component in range `0...255`
public final class Rgb : ExpressibleByIntegerLiteral {
    
    public let r: Int
    public let g: Int
    public let b: Int
    public let a: Int
    
    public init(r: Int, g: Int, b: Int, a: Int = 0xFF) {
        self.r = r.restrict(0...0xFF)
        self.g = g.restrict(0...0xFF)
        self.b = b.restrict(0...0xFF)
        self.a = a.restrict(0...0xFF)
    }
    
    public convenience init(_ hex: Int) { self.init(integerLiteral: hex) }
    
    public convenience init(integerLiteral hex: Int) {
        let color: (r: Int, g: Int, b: Int, a: Int) = hex.color
        self.init(r: color.r, g: color.g, b: color.b, a: color.a)
    }
    
}

// MARK: interface
public extension Rgb {
    
    var hex: Int {
        let r: Int = r << 24
        let g: Int = g << 16
        let b: Int = b << 8
        return r | g | b | a
    }
    
    var ui: Color {
        let r: Double = r.double / 255.0
        let g: Double = g.double / 255.0
        let b: Double = b.double / 255.0
        let a: Double = a.double / 255.0
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    var rrggbb: String { String(format: "%02X", hex >> 8) }
    
    var rrggbbaa: String { String(format: "%02X", hex) }
    
    var uiColor: UIColor { .init(rgb: self) }
    
    static let eyebleed: Rgb = 0xFF10A0FF.rgb
    
}

extension Rgb  : Equatable, Hashable {
    
    public static func == (lhs: Rgb, rhs: Rgb) -> Bool {
           lhs.r == rhs.r
        && lhs.g == rhs.g
        && lhs.b == rhs.b
        && lhs.a == rhs.a
    }
    
    public func hash(into hasher: inout Hasher) { hasher.combine([r, g, b, a]) }
    
}

// MARK: contributions
public extension Color {
    
    var rgb: Rgb { cgColor?.rgb ?? .eyebleed }
    
}

public extension UIColor {
    
    var rgb: Rgb { cgColor.rgb }
    
}

public extension CGColor {
    
    var rgb: Rgb {
        switch numberOfComponents {
        case 1:
            let level: Int = 0xFF * (components?[safe: 0]?.int ?? 0)
            return Rgb(r: level, g: level, b: level, a: 0xFF)
        case 2:
            let level: Int = 0xFF * (components?[safe: 0]?.int ?? 0)
            let alpha: Int = 0xFF * (components?[safe: 1]?.int ?? 0)
            return Rgb(r: level, g: level, b: level, a: alpha)
        case 3:
            let r: Int = 0xFF * (components?[safe: 0]?.int ?? 0)
            let g: Int = 0xFF * (components?[safe: 1]?.int ?? 0)
            let b: Int = 0xFF * (components?[safe: 2]?.int ?? 0)
            return Rgb(r: r, g: g, b: b, a: 0xFF)
        case 4:
            let r: Int = 0xFF * (components?[safe: 0]?.int ?? 0)
            let g: Int = 0xFF * (components?[safe: 1]?.int ?? 0)
            let b: Int = 0xFF * (components?[safe: 2]?.int ?? 0)
            let a: Int = 0xFF * (components?[safe: 3]?.int ?? 0)
            return Rgb(r: r, g: g, b: b, a: a)
        default:
            return Rgb(r: 0, g: 0, b: 0, a: 0)
        }
    }
    
}

public extension UIColor {
    
    convenience init(rgb: Rgb) {
        let r: CGFloat = rgb.r.cgFloat / 0xFF
        let g: CGFloat = rgb.g.cgFloat / 0xFF
        let b: CGFloat = rgb.b.cgFloat / 0xFF
        let a: CGFloat = rgb.a.cgFloat / 0xFF
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}

public extension Int {
    
    var rgb: Rgb {
        let color: (r: Int, g: Int, b: Int, a: Int) = color
        return Rgb(r: color.r, g: color.g, b: color.b, a: color.a)
    }
    
}

public extension String {
    
    var rgb: Rgb? {
        let hex: String = hasPrefix("#") ? String(dropFirst()) : self
        guard hex.count == 6 else { return nil }
        let scanner: Scanner = .init(string: hex)
        var colorCode: UInt64 = 0
        guard scanner.scanHexInt64(&colorCode) else { return nil }
        let red:   Int = .init((colorCode & 0xFF0000) >> 16)
        let green: Int = .init((colorCode & 0x00FF00) >> 8)
        let blue:  Int = .init((colorCode & 0x0000FF))
        return Rgb(r: red, g: green, b: blue, a: 0xFF)
    }
    
}

private extension Int {
    
    var color: (r: Int, g: Int, b: Int, a: Int) {
        let r: Int = (0xFF000000 & self) >> 24
        let g: Int = (0x00FF0000 & self) >> 16
        let b: Int = (0x0000FF00 & self) >> 8
        let a: Int =  0x000000FF & self
        return (r, g, b, a)
    }
    
}
