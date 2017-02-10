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
    
    //===
    
    @discardableResult
    func apply(
        _ getState: (_: Self.Type) -> State<Self>,
        via transition: GenericTransition? = nil,
        completion: Completion? = nil
        ) -> Self
    {
        Utils.apply(getState(Self.self),
                    on: self,
                    via: transition,
                    completion: completion)
        
        //===
        
        return self
    }
}

//=== MARK: Aliases

public
extension DiscreteSystem
{
    @discardableResult
    func become(
        _ getState: (_: Self.Type) -> State<Self>
        ) -> Self
    {
        return apply(getState,
                     via: nil,
                     completion: nil)
    }
    
    @discardableResult
    func become(
        _ getState: (_: Self.Type) -> State<Self>,
        via transition: GenericTransition? = nil,
        completion: Completion? = nil
        ) -> Self
    {
        return apply(getState,
                     via: transition,
                     completion: completion)
    }
}
