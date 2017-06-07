//
//  Dispatcher_Ready.swift
//  State
//
//  Created by Maxim Khatskevich on 6/7/17.
//
//

import Foundation

//===

extension Functional.State.Dispatcher
{
    struct Ready: Static_State
    {
        // a state has been set, ready for a new transition
        
        let current: Functional.State<Target>?
    }
}
