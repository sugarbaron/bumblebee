//
//  Rgb.swift
//  bumblebee
//
//  Created by sugarbaron on 29.01.2023.
//

import SwiftUI

// MARK: constructor
/// a color with each component in range `0...255`
public final class Rgb {
    
    public let r: Int
    public let g: Int
    public let b: Int
    public let a: Int
    
    public init(_ r: Int, _ g: Int, _ b: Int, alpha a: Int = 0xFF) {
        self.r = r.restrict(0...0xFF)
        self.g = g.restrict(0...0xFF)
        self.b = b.restrict(0...0xFF)
        self.a = a.restrict(0...0xFF)
    }
    
}

// MARK: interface
extension Rgb : ExpressibleByIntegerLiteral, Equatable, Hashable {
    
    public var hex: Int {
        let r: Int = r << 24
        let g: Int = g << 16
        let b: Int = b << 8
        return r | g | b | a
    }
    
    public var ui: Color {
        let r: Double = r.double / 255.0
        let g: Double = g.double / 255.0
        let b: Double = b.double / 255.0
        let a: Double = a.double / 255.0
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    public convenience init(_ hex: Int) { self.init(integerLiteral: hex) }
    
    public convenience init(integerLiteral hexCode: Int) {
        let color: Rgba = hexCode.color
        self.init(color.r, color.g, color.b, alpha: color.a)
    }
    
    public static func == (lhs: Rgb, rhs: Rgb) -> Bool {
           lhs.r == rhs.r
        && lhs.g == rhs.g
        && lhs.b == rhs.b
        && lhs.a == rhs.a
    }
    
    public func hash(into hasher: inout Hasher) { hasher.combine([r, g, b, a]) }
    
    public static let eyebleed: Rgb = 0xFF10A0FF.rgb
    
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
        guard let decomposed: [CGFloat] = components,
              let r: CGFloat = decomposed.at(0),
              let g: CGFloat = decomposed.at(1),
              let b: CGFloat = decomposed.at(2)
        else { return Rgb(0xFF0000FF) }
        
        let a: CGFloat = decomposed.at(3) ?? 1.0
        return Rgb(Int(r * 0xFF), Int(g * 0xFF), Int(b * 0xFF), alpha: Int(a * 0xFF))
    }
    
}

public extension Int {
    
    var rgb: Rgb {
        let color: Rgba = color
        return Rgb(color.r, color.g, color.b, alpha: color.a)
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
        return Rgb(red, green, blue)
    }
    
}

private extension Int {
    
    var color: Rgba {
        let r: Int = (0xFF000000 & self) >> 24
        let g: Int = (0x00FF0000 & self) >> 16
        let b: Int = (0x0000FF00 & self) >> 8
        let a: Int =  0x000000FF & self
        return (r, g, b, a)
    }
    
}

private typealias Rgba = (r: Int, g: Int, b: Int, a: Int)
