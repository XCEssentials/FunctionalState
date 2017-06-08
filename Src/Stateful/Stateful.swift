import Foundation

//===

public
protocol Stateful: class { }

//===

public
extension Stateful
{
    var state: Dispatcher<Self>
    {
        return DispatcherWrapper.get(for: self)
    }
    
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
