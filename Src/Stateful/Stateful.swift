import Foundation

//===

/**
 Turns any class into [discrete system](https://en.wikipedia.org/wiki/Discrete_system).
 */
public
protocol Stateful: class
{
    /**
     Transition that will be used by default, if it will be requested to apply new state via transition, but NO exact transition will be specified. This value will be used for initializing associated `Dispatcher` object.
     */
    static
    var defaultTransition: Transition<Self>.Body { get }
}

//===

public
extension Stateful
{
    /**
     Default implementation of the `defaultTransition` requirement. It's equivalent of applying new state instantly.
     */
    static
    var defaultTransition: Transition<Self>.Body { return { $1(); $2(true) } }
}

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
        return Dispatcher.get(
            for: self,
            with: Self.defaultTransition
        )
    }
    
    /**
     Designeted metod for declaring state with `onSet` mutation closure only (without `onUpdate`).
     
     - Parameters:
     
         - name: Desired name of the state. This will contribute to the state `identifier`, so it must be unique within type. It's highly recommended to not specify it explicitly so the default implementation will pick up enclosing function name as state name.
     
         - onSet: This closure will be used as `onSet` closure of result state.
     
     - Result: `State` instance that contains `identifier` built with `name`, provided `onSet` closure and empty `onUpdate` closure.
     */
    static
    func state(
        name: String = #function,
        onSet: @escaping State<Self>.TargetMutation
        ) -> State<Self>
    {
        return State(stateIdentifier(with: name), onSet)
    }
    
    /**
     Designeted metod for declaring state with both `onSet` and `onUpdate` mutation closures.
     
     - Parameters:
     
         - name: Desired name of the state. This will contribute to the state `identifier`, so it must be unique within type. It's highly recommended to not specify it explicitly so the default implementation will pick up enclosing function name as state name.
     
         - onSet: This closure will be used as `onSet` closure of result state.
     
     - Returns: Instance of `Pending` state that eventually allows to define `State` instance that contains `identifier` built with `name`, provided `onSet` and `onUpdate` closures.
     */
    static
    func onSet(
        name: String = #function,
        _ onSet: @escaping State<Self>.TargetMutation
        ) -> State<Self>.Pending
    {
        return State.Pending(stateIdentifier(with: name), onSet)
    }
}

//===

private
extension Stateful
{
    /**
     Generates designeted state identifier, which supposed to be globally unique within current module.
     
     - Parameter name: State name or description, must be unique within type.
     */
    static
    func stateIdentifier(with name: String) -> String
    {
        return String(reflecting: self) + "." + name
    }
}
