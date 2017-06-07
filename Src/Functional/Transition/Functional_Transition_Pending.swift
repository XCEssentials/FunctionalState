import Foundation

//===

public
extension Functional.Transition
{
    struct Pending
    {
        public
        let dispatcher: Functional.Dispatcher<Target>
        
        let defaultTransition: Functional.Transition<Target>.Body?
        
        let getState: Functional.State<Target>.Getter
    }
}

//===

public
extension Functional.Transition.Pending
{
    @discardableResult
    func instantly() -> Functional.Dispatcher<Target>
    {
        dispatcher.enqueue((getState, nil, nil))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func viaTransition(
        _ completion: Functional.Transition.Completion? = nil
        ) -> Functional.Dispatcher<Target>
    {
        dispatcher.enqueue((getState, defaultTransition, completion))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func via(
        _ transition: @escaping Functional.Transition<Target>.Body,
        _ completion: Functional.Transition<Target>.Completion? = nil
        ) -> Functional.Dispatcher<Target>
    {
        dispatcher.enqueue((getState, transition, completion))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
}
