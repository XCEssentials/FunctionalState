import Foundation

//===

public
enum Transition<Target: AnyObject>
{
    public
    typealias Completion = (_ finished: Bool) -> Void
    
    //===
    
    public
    typealias Body = (
        _ target: Target,
        _ mutation: @escaping () -> Void,
        _ completion: @escaping  Completion
        ) -> Void
}
