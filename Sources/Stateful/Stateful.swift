import Foundation

//===

/**
 Turns any class into [discrete system](https://en.wikipedia.org/wiki/Discrete_system).
 */
public
protocol Stateful: class
{
    /**
     Designated storage for state dispatcher.
     
     - Note: Don't be confused. Its type is `Dispatcher`, but its name `state` - just for a nicer API like this:
     
     ```swift
     class MyView: Stateful
     {
         private(set)
         lazy
         var state: Dispatcher<MyView> = Dispatcher(for: self)
     }
     
     extension MyView
     {
        static
        func initialized() -> State<MyView>
        {
            return state{ ... }
        }
     }
     
     let aView = MyView()
     
     aView.state.apply{ $0.initialized() }
     ```
     */
    var state: Dispatcher<Self> { get }
    
    /**
     Transition that will be used as `onSetTransition` in each state related to this class, if no other transition is specified explicitly.
     */
    static
    var defaultOnSetTransition: Transition<Self> { get }
    
    /**
     Transition that will be used as `onUpdateTransition` in each state related to this class, if no other transition is specified explicitly.
     */
    static
    var defaultOnUpdateTransition: Transition<Self> { get }
}

//=== MARK: Helpers

public
extension Stateful
{
    /**
     Helper constructor of transition that applies mutations instantly and calls completion right away, synchronously.
     */
    static
    var instantTransition: Transition<Self>
    {
        return { $1(); $2(true) }
    }
}

//=== MARK: Default implementations

public
extension Stateful
{
    static
    var defaultOnSetTransition: Transition<Self>
    {
        return instantTransition
    }
    
    static
    var defaultOnUpdateTransition: Transition<Self>
    {
        return instantTransition
    }
}
