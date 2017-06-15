import Foundation

//===

public
extension Transition
{
    struct Pending
    {
        public
        let dispatcher: Dispatcher<Target>
        
        let defaultTransition: Transition<Target>.Body?
        
        let getState: State<Target>.Getter
    }
}

//===

public
extension Transition.Pending
{
    @discardableResult
    func instantly() -> Dispatcher<Target>
    {
        dispatcher.enqueue((getState, nil, nil))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func viaTransition(
        _ completion: Transition<Target>.Completion? = nil
        ) -> Dispatcher<Target>
    {
        dispatcher.enqueue((getState, defaultTransition, completion))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func via(
        _ transition: @escaping Transition<Target>.Body,
        _ completion: Transition<Target>.Completion? = nil
        ) -> Dispatcher<Target>
    {
        dispatcher.enqueue((getState, transition, completion))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
}
