import Foundation

import XCEStaticState

//===

/**
 Keeps track of current object state and manages transitions into new states.
 */
public
final
class Dispatcher<Target: AnyObject>
{
    /**
     Internal queue of scheduled transitions that need to be processed as soon as possible serially (next transition starts right after previous one has been finished).
     
     Every time we add a transition into the queue, we call `processNext()` to start processing scheduled transitions right away.
     */
    var queue = Queue<Transition<Target>.Wrapper>()
    
    /**
     Dispatcher core, holds internal state.
     */
    let core = Core()
    
    /**
     The object for which this dispatcher is managing state.
     */
    public private(set)
    weak
    var target: Target?
    
    /**
     Transition that will be used by default, if it will be requested to apply new state via transition, but NO exact transition will be specified.
     */
    public
    let defaultTransition: Transition<Target>.Body?
    
    /**
     The only initializer.
     
     - Parameters:
     
         - target: Object for which this dispatcher will track current state and manage transitions.
     
         - defaultTransition: Transition that will be used by default, if it will be requested to apply new state via transition, but NO exact transition will be specified.
     
     - Note: It is intentionally `internal` to avoid direct access from outside of this module.
     */
    init(
        for target: Target,
        _ defaultTransition: Transition<Target>.Body? = nil
        )
    {
        self.target = target
        self.defaultTransition = defaultTransition
        
        //===
        
        self.core.state = Core.Ready(current: nil)
    }
}

//===

public
extension Dispatcher
{
    /**
     Applies a new state to `target` object.
     
     - Parameter getState: Closure that returns the new state.
     
     - Returns: Instance of `Pending` transition that eventually allows to schedule transition into the new state on this dispatcher.
     */
    func apply(
        _ getState: @escaping State<Target>.Getter
        ) -> Transition<Target>.Pending
    {
        return Transition<Target>.Pending(
            dispatcher: self,
            defaultTransition: defaultTransition,
            getState: getState
        )
    }
}
