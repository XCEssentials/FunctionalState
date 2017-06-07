import Foundation

//===

public
protocol Functional_DiscreteSystem: class { }

//===

public
extension Functional_DiscreteSystem
{
    static
    func state(
        context: String = #function,
        onSet: @escaping Functional.State<Self>.TargetMutation
        ) -> Functional.State<Self>
    {
        return Functional.State("\(self).\(context)", onSet)
    }
    
    static
    func onSet(
        context: String = #function,
        _ onSet: @escaping Functional.State<Self>.TargetMutation
        ) -> Functional.State<Self>.Pending
    {
        return Functional.State<Self>.Pending("\(self).\(context)", onSet)
    }
}
