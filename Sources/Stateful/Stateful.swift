import Foundation

//===

/**
 Turns any class into [discrete system](https://en.wikipedia.org/wiki/Discrete_system).
 */
public
protocol Stateful: class { }

//===

public
extension Stateful
{
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
