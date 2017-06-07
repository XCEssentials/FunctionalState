//
//  Dispatcher_Ready.swift
//  State
//
//  Created by Maxim Khatskevich on 6/7/17.
//
//

import Foundation

//===

extension Dispatcher
{
    struct Ready: InternalState
    {
        // a state has been set, ready for a new transition
        
        let current: State<Target>?
    }
}
