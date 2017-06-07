import Foundation

//===

public
extension Functional.Transition
{
    public
    typealias Wrapper = (
        
        getState: Functional.State<Target>.Getter,
        
        transition: Functional.Transition<Target>.Body?,
        
        completion: Functional.Transition.Completion?
    )
}
