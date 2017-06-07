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
extension Functional.State
{
    public
    final
    class Dispatcher
    {
        weak
        var target: Target?
        
        var queue = Queue<Functional.Transition<Target>.Wrapper>()
        
        public
        var defaultTransition: Functional.Transition<Target>.Body? = nil
        
        //===
        
        public
        init(
            with target: Target,
            _ defaultTransition: Functional.Transition<Target>.Body? = nil
            )
        {
            self.target = target
            self.defaultTransition = defaultTransition
        }
    }
}

//===

extension Functional.State.Dispatcher: Static_DiscreteSystem { }

//===

public
extension Functional.State.Dispatcher
{
    public
    func apply(
        _ getState: @escaping Functional.State<Target>.Getter
        ) -> Functional.Transition<Target>.Pending
    {
        return Functional.Transition<Target>.Pending(
            dispatcher: self,
            defaultTransition: defaultTransition,
            getState: getState
        )
    }
}

//===

extension Functional.State.Dispatcher
{
    func enqueue(_ task: Functional.Transition<Target>.Wrapper)
    {
        queue.enqueue(task)
        
        //===
        
        processNext()
    }
    
    func processNext()
    {
        guard
            let target = target,
            let now = state.current as? Ready,
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
        
        state.current = InTransition(previous: now.current, next: newState)
        
        //===
        
//        Utils.apply(newState, on: target, via: task.transition) {
//                    
//            self.state.current = Ready(current: newState)
//            
//            //===
//            
//            task.completion?($0)
//            
//            //===
//            
//            self.processNext()
//        }
    }
}
