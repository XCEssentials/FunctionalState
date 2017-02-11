//
//  DiscreteSystem.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
protocol DiscreteSystem: class { }

//===

public
extension DiscreteSystem
{
    static
    func state(
        context: String = #function,
        mutation: @escaping (_: Self) -> Void
        ) -> State<Self>
    {
        return State("\(self).\(context)", mutation)
    }
}

//=== MARK: Apply

public
extension DiscreteSystem
{
    @discardableResult
    func apply(
        _ getState: @escaping (_: Self.Type) -> State<Self>
        ) -> PendingTransition<Self>
    {
        return
            PendingTransition(
                target: self,
                getState: getState)
    }
}

//=== MARK: Alias

public
extension DiscreteSystem
{
    @discardableResult
    func become(
        _ getState: @escaping (_: Self.Type) -> State<Self>
        ) -> PendingTransition<Self>
    {
        return
            PendingTransition(
                target: self,
                getState: getState)
    }
}
