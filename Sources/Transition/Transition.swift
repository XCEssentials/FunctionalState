import Foundation

//===

/**
 Closure/function that implements transition into a new state.
 
 - Parameters:
 
     - stateOwner: Object-owner of the state.
 
     - mutations: Mutations/statements that must be performed exactly once in order to complete transition into the new state.
 
     - completion: Completion closure; must be called on MAIN trhead/queue after `mutations` closure has been executed.
 */
public
typealias Transition<Owner: Stateful> = (
    _ stateOwner: Owner,
    _ mutations: @escaping () -> Void,
    _ completion: @escaping Completion
    ) -> Void
