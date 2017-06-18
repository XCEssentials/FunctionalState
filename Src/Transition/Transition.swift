import Foundation

//===

/**
 A scope type that holds together types related to transition between states.
 */
public
enum Transition<Target: AnyObject> // scope
{
    /**
     Signature of closure that is being called after transition is complete.
     */
    public
    typealias Completion = (_ finished: Bool) -> Void
    
    /**
     Signature of closure that represents any transition in generic way.
     
     In general, `State` represents "what" while transition represents "how". In other words, state defines exactly mutations to be made while transition defines how to apply these mutations.
     
     That kind of closure/function must call the `mutation` closure during execution (probably, inside animation closure, if the object is UIView-based) to actually perform mutations, and then later call `completion` closure when transition is finised.
     
     - Parameters:
     
         - target: The object to which this transition is being applied.
     
         - mutation: Contains state-specific mutations of the `target`, note that the `target` is supposed to be captured inside `mutation` state on earlier stage.
     
         - completion: Closure that must be called when transition is finished.
     */
    public
    typealias Body = (
        _ target: Target,
        _ mutation: @escaping () -> Void,
        _ completion: @escaping  Completion
        ) -> Void
}
