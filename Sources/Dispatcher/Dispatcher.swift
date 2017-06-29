import Foundation

import XCEStaticState

internal
protocol InternalStateful: XCEStaticState.Stateful { }

/**
 Keeps track of current object state and manages transitions into new states.
 */
public
final
class Dispatcher<Subject: Stateful>
{
    /**
     Internal queue of scheduled transitions that need to be processed as soon as possible serially (next transition starts right after previous one has been finished).
     
     Every time we add a transition into the queue, we call `processNext()` to start processing scheduled transitions right away.
     */
    var queue = Queue<DeferredTransition<Subject>>()
    
    /**
     Holds internal state.
     */
    public internal(set)
    var internalState: Any
    
    /**
     The object for which this dispatcher is managing state.
     */
    public private(set)
    weak
    var subject: Subject?
    
    /**
     The only initializer.
     
     - Parameter object: Object for which this dispatcher will track current state and manage transitions.
     */
    public
    init(for subject: Subject)
    {
        self.subject = subject
        
        //===
        
        self.internalState = Ready(current: nil)
    }
}

//===

public
extension Dispatcher
{
    /**
     Schedules transition into a given state (target state).
     
     - Parameters:
     
        - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.
     
        - stateGetter: Closure that returns state (target state) which needs to be applied to `self.subject` object
     
     - Returns: Reference to self to support chaining calls.
     */
    @discardableResult
    func apply(
        via forceTransition: Transition<Subject>? = nil,
        _ stateGetter: @autoclosure () -> State<Subject>
        ) -> Dispatcher<Subject>
    {
        enqueue((
            stateGetter(),
            forceTransition,
            nil
        ))
        
        //===
        
        return self
    }
    
    /**
     Schedules transition into a given state (target state).
     
     - Parameters:
     
        - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.

        - stateGetter: Closure that returns state (target state) which needs to be applied to `self.subject` object

        - completion: Higher level completion that will be called after transition is complete and current state is set to target state.
     
     - Returns: Reference to self to support chaining calls.
     */
    @discardableResult
    func apply(
        via forceTransition: Transition<Subject>? = nil,
        _ stateGetter: @autoclosure () -> State<Subject>,
        completion: @escaping Completion
        ) -> Dispatcher<Subject>
    {
        enqueue((
            stateGetter(),
            forceTransition,
            completion
        ))
        
        //===
        
        return self
    }
    
    /**
     Schedules transition into a given state (target state).
     
     - Parameters:
     
         - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.
         
         - stateGetter: Closure that returns state (target state) which needs to be applied to `self.subject` object
     
     - Returns: Reference to self to support chaining calls.
     */
    @discardableResult
    func apply(
        via forceTransition: Transition<Subject>? = nil,
        _ stateGetter: (Subject.Type) -> State<Subject>
        ) -> Dispatcher<Subject>
    {
        enqueue((
            stateGetter(Subject.self),
            forceTransition,
            nil
        ))
        
        //===
        
        return self
    }
    
    /**
     Schedules transition into a given state (target state).
     
     - Parameters:
     
        - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.
     
        - stateGetter: Closure that returns state (target state) which needs to be applied to `self.subject` object
     
        - completion: Higher level completion that will be called after transition is complete and current state is set to target state.
     
     - Returns: Reference to self to support chaining calls.
     */
    @discardableResult
    func apply(
        via forceTransition: Transition<Subject>? = nil,
        _ stateGetter: (Subject.Type) -> State<Subject>,
        completion: @escaping Completion
        ) -> Dispatcher<Subject>
    {
        enqueue((
            stateGetter(Subject.self),
            forceTransition,
            completion
        ))
        
        //===
        
        return self
    }
}
