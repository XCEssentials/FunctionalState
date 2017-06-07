import Foundation

//===

public
extension Functional.Transition
{
    public
    struct Pending
    {
        public
        let dispatcher: Functional.State<Target>.Dispatcher
        
        let defaultTransition: Functional.Transition<Target>.Body?
        
        let getState: Functional.State<Target>.Getter
    }
}

//===

public
extension Functional.Transition.Pending
{
    @discardableResult
    func instantly() -> Functional.State<Target>.Dispatcher
    {
        dispatcher.enqueue((getState, nil, nil))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func viaTransition(
        _ completion: Functional.Transition.Completion? = nil
        ) -> Functional.State<Target>.Dispatcher
    {
        dispatcher.enqueue((getState, defaultTransition, completion))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    @discardableResult
    func via(
        _ transition: @escaping Functional.Transition<Target>.Body,
        _ completion: Completion? = nil
        ) -> Functional.State<Target>.Dispatcher
    {
        dispatcher.enqueue((getState, transition, completion))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
}
