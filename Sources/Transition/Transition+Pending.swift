import Foundation

//===

public
extension Transition
{
    /**
     Intermediate data structure that temporary hodls data that is necessary to apply a new state via transition or instantly.
     
     An instance of this type is being returned by `apply(...)` function of `Dispatcher` object. Such technique makes possible nice chainable calls like this:
     
     ```swift
     class MyView: Stateful {}
     
     extension MyView
     {
         static
         func initialized() -> State<MyView> // defines "initialized" state
         {
             return state{
     
                 // on set mutations go here...
             }
         }
     }
     
     let aView = MyView()
     
     aView.state.apply{ $0.initialized() }.instantly()
     // or...
     aView.state.apply{ $0.initialized() }.viaTransition()
     // etc...
     
     ```
     */
    struct Pending
    {
        /**
         Dispatcher object that manages this transition.
         */
        public
        let dispatcher: Dispatcher<Target>
        
        /**
         Transition that will be used by default, if it will be requested to apply new state via transition, but NO exact transition will be specified.
         */
        let defaultTransition: Transition<Target>.Body?
        
        /**
         Closure that returns the new state.
         */
        let getState: State<Target>.Getter
    }
}

//===

public
extension Transition.Pending
{
    /**
     Schedules intant transition into the new state.
     
     - Returns: Reference to the `Dispatcher` object where this `Pending` instance was originated.
     */
    @discardableResult
    func instantly() -> Dispatcher<Target>
    {
        dispatcher.enqueue((getState, nil, nil))
        
        dispatcher.processNext()
        
        //===
        
        return dispatcher
    }
    
    /**
     Schedules transition into the new state using `defaultTransition`.
     
     - Parameter completion: Closure that must be called after transition is finished.
     
     - Returns: Reference to the `Dispatcher` object where this `Pending` instance was originated.
     */
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
    
    /**
     Schedules transition into the new state using explicitly specified transition.
     
     - Parameters:
     
         - transition: Transition that must be used to apply new state.
     
         - completion: Closure that must be called after transition is finished.
     
     - Returns: Reference to the `Dispatcher` object where this `Pending` instance was originated.
     */
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
