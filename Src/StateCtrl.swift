//
//  StateCtrl.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
typealias Transition =
(
    _ mutation: @escaping () -> Void,
    _ completion: @escaping  (_ finished: Bool) -> Void
) -> Void

//===

public
final
class StateCtrl<Target: AnyObject>
{
    weak
    var target: Target?
    
    //===
    
    public fileprivate(set)
    var current: State<Target>? = nil
    
    public fileprivate(set)
    var next: State<Target>? = nil
    
    public
    var isReadyForTransition: Bool { return next == nil }
    
    //===
    
    public
    init(for view: Target)
    {
        self.target = view
    }
}

//=== MARK: Apply

extension StateCtrl
{
    func apply(
        _ newState: State<Target>,
        transition: Transition? = nil
        )
    {
        guard
            current != newState
        else
        {
            return // just return without doing anything
        }
        
        //===
        
        guard
            next.map({ $0 != newState }) ?? true
        else
        {
            return // just return without doing anything
        }
        
        //===
        
        /*
         
         Q: What we've checked so far?
         
         A: If we are already in the target state,
         or if we are currently transitioning into that state, then
         no need to do anything at all, and no need to throw an exception.
         
         */
        
        //===
        
        guard
            let target = target
        else
        {
            return
        }
        
        //===
        
        next = newState
        
        //===
        
        let mutation = { newState.mutation(target) }
        
        let transition = transition ?? { $0(); $1(true) }
        
        //===
        
        transition(mutation) {
            
            if
                $0 // transition finished?
            {
                // YES
                
                self.current = newState
                self.next = nil
            }
            else
            {
                // NO
                
                // most likely transition has been
                // interupted by applying anopther state
            }
        }
    }
}
