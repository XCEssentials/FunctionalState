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
    
    func apply(
        _ getState: (_: Self.Type) -> State<Self>
        )
    {
        apply(getState, via: nil, nil)
    }
    
    func apply(
        _ getState: (_: Self.Type) -> State<Self>,
        via transition: Transition? = nil,
        _ completion: Completion? = nil
        )
    {
        Utils.apply(getState(Self.self),
                    on: self,
                    via: transition,
                    completion)
    }
}
