//
//  LogAssembly.swift
//  Bumblebee
//
//  Created by sugarbaron on 20.10.2022.
//

import Swinject

public extension Log { final class Assembly { } }

extension Log.Assembly : Swinject.Assembly {

    public func assemble(container: Container) { container.singleton(Log.Engine?.self) { Log.constructEngine() } }

}
