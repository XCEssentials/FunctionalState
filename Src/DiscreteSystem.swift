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
        via transition: Transition? = nil,
        _ completion: Completion? = nil,
        _ getState: (_: Self.Type) -> State<Self>
        ) -> Self
    {
        Utils.apply(getState(Self.self),
                    on: self,
                    via: transition,
                    completion)
        
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
        via transition: Transition? = nil,
        _ completion: Completion? = nil,
        _ getState: (_: Self.Type) -> State<Self>
        ) -> Self
    {
        return apply(via: transition, completion, getState)
    }
}
