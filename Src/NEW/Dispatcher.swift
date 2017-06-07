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
class Dispatcher<Target: AnyObject>: InternalStateContainer
{
    var internalState: InternalState = Ready(current: nil)
    
    //===
    
    weak
    var target: Target?
    
    var queue = Queue<StateTransitionTask<Target>>()
    
    public
    var defaultTransition: Transition<Target>? = nil
    
    //===
    
    public
    init(
        with target: Target,
        _ defaultTransition: Transition<Target>? = nil
        )
    {
        self.target = target
        self.defaultTransition = defaultTransition
    }
}

//===

public
extension Dispatcher
{
    public
    func apply(
        _ getState: @escaping StateGetter<Target>
        ) -> PMTransition<Target>
    {
        return PMTransition(
            dispatcher: self,
            defaultTransition: defaultTransition,
            getState: getState
        )
    }
}

//===

extension Dispatcher
{
    func enqueue(_ task: StateTransitionTask<Target>)
    {
        queue.enqueue(task)
        
        //===
        
        processNext()
    }
    
    func processNext()
    {
        guard
            let target = target,
            let now = internalState as? Ready,
            let task = queue.dequeue() // dequeue after we chaked internalState!
        else
        {
            return
        }
        
        //===
        
        let newState = task.getState(Target.self)
        
        //===
        
        guard
            now.current != newState
        else
        {
            newState.onUpdate(target) // current == newState
            
            //===
            
            return
        }
        
        //===
        
        internalState = InTransition(previous: now.current, next: newState)
        
        //===
        
        Utils.apply(newState, on: target, via: task.transition) {
                    
            self.internalState = Ready(current: newState)
            
            //===
            
            task.completion?($0)
            
            //===
            
            self.processNext()
        }
    }
}
