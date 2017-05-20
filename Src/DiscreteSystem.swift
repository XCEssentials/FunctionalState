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
        onSet: @escaping State<Self>.TargetMutation
        ) -> State<Self>
    {
        return State("\(self).\(context)", onSet)
    }
    
    static
    func onSet(
        context: String = #function,
        _ onSet: @escaping State<Self>.TargetMutation
        ) -> PendingState<Self>
    {
        return PendingState("\(self).\(context)", onSet)
    }
}

//=== MARK: Apply

public
extension DiscreteSystem
{
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
