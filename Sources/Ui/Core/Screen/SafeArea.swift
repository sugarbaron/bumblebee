//
//  SafeArea.swift
//  bumblebee
//
//  Created by Олег Мишкин on 25.10.2022.
//

import UIKit

public class SafeArea {

    private static let window = UIApplication.shared.windows.first

    public static var top   : CGFloat { window?.safeAreaInsets.top    ?? 0 }
    public static var bottom: CGFloat { window?.safeAreaInsets.bottom ?? 0 }
    public static var left  : CGFloat { window?.safeAreaInsets.left   ?? 0 }
    public static var right : CGFloat { window?.safeAreaInsets.right  ?? 0 }
    
}
