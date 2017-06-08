import Foundation

import XCEStaticState

//===

public
final
class Dispatcher<Target: AnyObject>
{
    var queue = Queue<Transition<Target>.Wrapper>()
    
    let core = States()
    
    //===
    
    public private(set)
    weak
    var target: Target?
    
    public
    let defaultTransition: Transition<Target>.Body?
    
    //===
    
    init(
        for target: Target,
        _ defaultTransition: Transition<Target>.Body? = nil
        )
    {
        self.target = target
        self.defaultTransition = defaultTransition
        
        //===
        
        self.core.state = States.Ready(current: nil)
    }
}

//===

public
extension Dispatcher
{
    public
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
