import Foundation

//===

/**
 Internal container type to put scheduled transition into queue.
 
 Contains:
    
 - targetState: State that's requested to be applied.

 - forceTransition: Transition that must be used to override transitions defined in `targetState` (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.

 - completion: Higher level completion that will be called after transition is complete and current state is set to `targetState`.
 */
typealias DeferredTransition<Owner: Stateful> =
(
    targetState: State<Owner>,
    forceTransition: Transition<Owner>?,
    completion: Completion?
)
