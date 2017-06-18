import Foundation

//===

extension Transition
{
    /**
     Internal helper data structure (tuple) that represents transition into new state. It's used for storing scheduled transitions in a queue inside `Dispatcher` object.
     */
    typealias Wrapper = (
        
        /**
         Closure that returns the new state.
         */
        getState: State<Target>.Getter,
        
        /**
         Transition that must be used to apply new state.
         */
        transition: Transition<Target>.Body?,
        
        /**
         Closure that must be called after transition is finished.
         */
        completion: Transition.Completion?
    )
}
