//
//  Dispatcher.swift
//  State
//
//  Created by Maxim Khatskevich on 6/6/17.
//
//

import Foundation

//===

public
final
class Dispatcher: InternalStateContainer
{
    var internalState: InternalState = Undefined()
    
    //===
    
    public
    init()
    {
        //
    }
}

//===

extension Dispatcher
{
    struct Undefined: InternalState
    {
        // a state never has been set yet
    }
}

//===

extension Dispatcher
{
    struct Ready: InternalState
    {
        // a state has been set, ready for a new transition
        
        // var current: State
    }
}

//===

extension Dispatcher
{
    struct InTransition: InternalState
    {
        // a transition into a new state is ongoing
    }
}
