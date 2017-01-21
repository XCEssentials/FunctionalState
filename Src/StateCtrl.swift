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
    
    var queue: [(Transition?, Completion?, StateGetter<Target>)] = []
    
    public
    var defaultTransition: Transition? = nil
    
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

public
extension StateCtrl
{
    func apply(
        via transition: Transition? = nil,
        _ completion: Completion? = nil,
        _ getState: (_: Target.Type) -> State<Target>
        )
    {
        guard
            let target = target
        else
        {
            return
        }
        
        //===
        
        let newState = getState(Target.self)
        
        //===
        
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
        
        next = newState
        
        //===
        
        Utils
            .apply(
                newState,
                on: target,
                via: (transition ?? defaultTransition),
                {
                    if
                        $0 // transition finished?
                    {
                        // YES
                        
                        self.current = newState
                        self.next = nil
                        
                        //===
                        
                        completion?($0)
                        
                        //===
                        
                        self.applyNext()
                    }
                    else
                    {
                        // NO
                        
                        // most likely transition has been
                        // interupted by applying another state
                        
                        //===
                        
                        completion?($0)
                        
                        //===
                        
                        self.resetQueue()
                    }
                })
    }
    
    @discardableResult
    func enqueue(
        via transition: Transition? = nil,
        _ completion: Completion? = nil,
        _ getState: @escaping (_: Target.Type) -> State<Target>
        ) -> StateCtrl<Target>
    {
        if
            isReadyForTransition
        {
            apply(via: transition, completion, getState)
        }
        else
        {
            queue.append((transition, completion, getState))
        }
        
        //===
        
        return self
    }
}

//===

extension StateCtrl
{
    func applyNext()
    {
        if
            isReadyForTransition,
            queue.count > 0
        {
            let q = queue.removeFirst()
            
            apply(via: q.0, q.1, q.2)
        }
    }
    
    func resetQueue()
    {
        queue.removeAll()
    }
}
