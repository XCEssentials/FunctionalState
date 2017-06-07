//
//  PMTrans.swift
//  State
//
//  Created by Maxim Khatskevich on 6/7/17.
//
//

import Foundation

//===

public
struct PMTransition<Target: AnyObject>
{
    let dispatcher: Dispatcher<Target>
    
    let defaultTransition: Transition<Target>?
    
    let getState: StateGetter<Target>
}

//===

public
extension PMTransition
{
    @discardableResult
    func instantly() -> Dispatcher<Target>
    {
//        dispatcher.enqueue((getState, nil, nil))
//        
//        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func viaTransition(
        _ completion: Completion? = nil
        ) -> Dispatcher<Target>
    {
//        dispatcher.enqueue((getState, defaultTransition, completion))
//        
//        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func via(
        _ transition: @escaping Transition<Target>,
        _ completion: Completion? = nil
        ) -> Dispatcher<Target>
    {
//        dispatcher.enqueue((getState, transition, completion))
//        
//        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
}
