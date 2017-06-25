import Foundation

//===

/**
 Turns any class into [discrete system](https://en.wikipedia.org/wiki/Discrete_system).
 */
public
protocol Stateful: class
{
    static
    var defaultOnSetTransition: Transition<Self> { get }
    
    static
    var defaultOnUpdateTransition: Transition<Self> { get }
}

//===

public
extension Stateful
{
    static
    var instantTransition: Transition<Self>
    {
        return { $1(); $2(true) }
    }
    
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
    
    /**
     Exclusive way to accessing state dispatcher of `self`. Lazy-initializable, weakly binded with `self`, deallocates automatically when `self` is deallocated.
     
     - Note: Don't be confused. It returns `Dispatcher`, but its name `state` - just for a nicer API like this:
     
     ```swift
     class MyView: Stateful {}
     
     extension MyView
     {
         static
         func initialized() -> State<MyView>
         {
             return state{ ... }
         }
     }
     
     let aView = MyView()
     
     aView.state.apply{ $0.initialized() }.viaTransition()
     ```
     */
    var state: Dispatcher<Self>
    {
        return Dispatcher.get(for: self)
    }
}
