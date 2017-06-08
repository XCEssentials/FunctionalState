import Foundation

//===

public
extension Transition
{
    typealias Wrapper = (
        
        getState: State<Target>.Getter,
        
        transition: Transition<Target>.Body?,
        
        completion: Transition.Completion?
    )
}
