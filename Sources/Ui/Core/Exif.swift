//
//  Exif.swift
//  bumblebee
//
//  Created by Олег on 17.11.2020.
//

import UIKit

public class Exif { }

public extension Exif {
    
    enum Orientation : Int {
        case up = 1
        case upMirrored = 2
        case down = 3
        case downMirrored = 4
        case right = 5
        case rightMirrored = 6
        case left = 7
        case leftMirrored = 8
        
        public var uiKit: UIImage.Orientation {
            switch self {
            case .up: return .up
            case .down: return .down
            case .left: return .left
            case .right: return .right
            case .upMirrored: return .upMirrored
            case .downMirrored: return .downMirrored
            case .leftMirrored: return .leftMirrored
            case .rightMirrored: return .rightMirrored
            }
        }
        
    }
    
}
