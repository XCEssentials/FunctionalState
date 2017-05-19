//
//  PendingManagedTransition.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 2/11/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
struct PendingManagedTransition<Target: AnyObject>
{
    let state: StateCtrl<Target>
    
    let defaultTransition: Transition<Target>?
    
    let getState: (_: Target.Type) -> State<Target>
}

//===

public
extension PendingManagedTransition
{
    @discardableResult
    func instantly() -> StateCtrl<Target>
    {
        state
            .queue
            .enqueue((getState, nil, nil))
        
        state
            .processNext()
        
        //===
        
        return state
    }
    
    @discardableResult
    func viaTransition(
        _ completion: Completion? = nil
        ) -> StateCtrl<Target>
    {
        state
            .queue
            .enqueue((getState, defaultTransition, completion))
        
        state
            .processNext()
        
        //===
        
        return state
    }
    
    @discardableResult
    func via(
        _ transition: @escaping Transition<Target>,
        _ completion: Completion? = nil
        ) -> StateCtrl<Target>
    {
        state
            .queue
            .enqueue((getState, transition, completion))
        
        state
            .processNext()
        
        //===
        
        return state
    }
}
