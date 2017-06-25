import Foundation

import XCEStaticState

//===

/**
 Keeps track of current object state and manages transitions into new states.
 */
public
final
class Dispatcher<Object: Stateful>
{
    /**
     Internal queue of scheduled transitions that need to be processed as soon as possible serially (next transition starts right after previous one has been finished).
     
     Every time we add a transition into the queue, we call `processNext()` to start processing scheduled transitions right away.
     */
    var queue = Queue<DeferredTransition<Object>>()
    
    /**
     Dispatcher core, holds internal state.
     */
    let core = Core()
    
    /**
     The object for which this dispatcher is managing state.
     */
    public private(set)
    weak
    var object: Object?
    
    /**
     The only initializer.
     
     - Parameters:
     
         - target: Object for which this dispatcher will track current state and manage transitions.
     
         - defaultTransition: Transition that will be used by default, if it will be requested to apply new state via transition, but NO exact transition will be specified.
     
     - Note: It is intentionally `internal` to avoid direct access from outside of this module.
     */
    init(for object: Object)
    {
        self.object = object
        
        //===
        
        self.core.state = Core.Ready(current: nil)
    }
}

//===

public
extension Dispatcher
{
    func apply(
        via forceTransition: Transition<Object>? = nil,
        _ stateGetter: @autoclosure () -> State<Object>
        )
    {
        enqueue((
            stateGetter(),
            forceTransition,
            nil
        ))
    }
    
    func apply(
        via forceTransition: Transition<Object>? = nil,
        _ stateGetter: @autoclosure () -> State<Object>,
        completion: @escaping Completion
        )
    {
        enqueue((
            stateGetter(),
            forceTransition,
            completion
        ))
    }
    
    func apply(
        via forceTransition: Transition<Object>? = nil,
        _ stateGetter: (Object.Type) -> State<Object>
        )
    {
        enqueue((
            stateGetter(Object.self),
            forceTransition,
            nil
        ))
    }
    
    func apply(
        via forceTransition: Transition<Object>? = nil,
        _ stateGetter: (Object.Type) -> State<Object>,
        completion: @escaping Completion
        )
    {
        enqueue((
            stateGetter(Object.self),
            forceTransition,
            completion
        ))
    }
}
