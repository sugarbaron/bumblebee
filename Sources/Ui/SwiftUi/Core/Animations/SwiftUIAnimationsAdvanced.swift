//
//  SwiftUIAnimationsAdvanced.swift
//  bumblebee
//
//  Created by sugarbaron on 31.03.2023.
//

import SwiftUI

public func animate<Result>(_ animation: Animation = .default, _ update: () -> Result) -> Result {
    withAnimation(animation, update)
}
