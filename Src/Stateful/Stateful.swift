import Foundation

//===

public
protocol Stateful: class
{
    static
    var defaultTransition: Transition<Self>.Body { get }
}

//===

public
extension Stateful
{
    // default implementation
    
    static
    var defaultTransition: Transition<Self>.Body { return { $1(); $2(true) } }
}

//===

public
extension Stateful
{
    // don't be confused,
    // this is jsut for a nice call API like:
    //
    // aView.state.apply{ $0.newState() }.viaTransition()
    
    var state: Dispatcher<Self>
    {
        return Dispatcher.get(
            for: self,
            with: Self.defaultTransition
        )
    }
}

//===

public
extension Stateful
{
    // below are helpers for decalring state mutations
    
    //===
    
    static
    func state(
        context: String = #function,
        onSet: @escaping State<Self>.TargetMutation
        ) -> State<Self>
    {
        return State("\(self).\(context)", onSet)
    }
    
    //===

    static
    func onSet(
        context: String = #function,
        _ onSet: @escaping State<Self>.TargetMutation
        ) -> State<Self>.Pending
    {
        return State<Self>.Pending("\(self).\(context)", onSet)
    }
}
