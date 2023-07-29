//
//  UIScreenAdvanced.swift
//  bumblebee
//
//  Created by Олег Мишкин on 04.08.2022.
//

import UIKit

extension UIScreen {

    public static var size: CGSize { main.bounds.size  }

    public static var center: CGPoint { CGPoint(x: size.w * 0.5, y: size.h * 0.5) }

    public static var isPortrait : Bool { size.h > size.w }

    public static var isLandscape: Bool { isPortrait == false }

    public static var greaterSide: CGFloat { max(size.w, size.h) }

    public static var lowerSide: CGFloat { min(size.w, size.h) }

    public static var orientation: Orientation {
        let orientation: UIScreen.Orientation = Orientation(UIDevice.current.orientation)
        if orientation == .unknown { return isPortrait ? .portrait : .landscape }
        return orientation
    }
    
}

extension UIScreen {
    
    public enum Orientation {
        case unknown
        case landscape
        case portrait
        
        public init(_ deviceOrientation: UIDeviceOrientation) {
            guard deviceOrientation != .unknown else { self = .unknown; return }
            self = (deviceOrientation == .portrait || deviceOrientation == .portraitUpsideDown)
                ? .portrait
                : .landscape
        }
        
        public var isPortrait: Bool { self == .portrait }
        
        public var isLandscape: Bool { self == .landscape }
        
    }
    
}
