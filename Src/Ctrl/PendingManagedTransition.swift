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
    let ctrl: StateCtrl<Target>
    
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
        ctrl.enqueue((getState, nil, nil))
        
        ctrl.processNext()
        
        //===
        
        return ctrl
    }
    
    @discardableResult
    func viaTransition(
        _ completion: Completion? = nil
        ) -> StateCtrl<Target>
    {
        ctrl.enqueue((getState, defaultTransition, completion))
        
        ctrl.processNext()
        
        //===
        
        return ctrl
    }
    
    @discardableResult
    func via(
        _ transition: @escaping Transition<Target>,
        _ completion: Completion? = nil
        ) -> StateCtrl<Target>
    {
        ctrl.enqueue((getState, transition, completion))
        
        ctrl.processNext()
        
        //===
        
        return ctrl
    }
}
