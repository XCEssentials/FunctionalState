import Foundation

//===

public
protocol Functional_DiscreteSystem: class
{
    static
    var defaultTransition: Functional.Transition<Self>.Body? { get }
}

//===

public
extension Functional_DiscreteSystem
{
    public
    var state: Functional.Dispatcher<Self>
    {
        let wrapper = Functional.DispatcherWrapper.get(
            for: self,
            with: Self.defaultTransition
        )
        
        //===
        
        return wrapper.dispatcher as! Functional.Dispatcher<Self>
    }
    
    //===
    
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
