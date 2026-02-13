//
//  Operators.swift
//  ios-x-gps-fleet
//
//  Created by sugarbaron on 15.12.2022.
//

infix operator <~

///
/// ```
/// // syntactic sugar for writing:
/// switch cases {
/// case _ where <condition>: <do something>
/// case _ where <condition>: <do something> 
/// }
/// ```
public let cases: Int = 1

/// ```
/// // syntactic sugar for writing:
/// condition ? run { someExpressionReturningTypeA() } : run { someExpressionReturningTypeB() }
/// // instead of:
/// condition ? { someExpressionReturningTypeA() }() : { someExpressionReturningTypeB() }()
/// ```
public func run<T>(_ logic: () -> T) { _ = logic() }
