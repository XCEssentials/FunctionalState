import Foundation

//===

extension Static
{
    enum DiscreteSystem // scope
    {
        public
        enum Errors // scope
        {
            public
            struct WrongState: Error { }
        }
    }
}

//===

public
protocol Static_DiscreteSystem: class { }

//===

public
extension Static_DiscreteSystem
{
    public
    var state: Static.State.Wrapper
    {
        return Static.State.Wrapper.get(for: self)
    }
    
    //===
    
    public
    func at<Input: Static_State>(
        _: Input.Type
        ) throws -> Input
    {
        if
            let result = state.current as? Input
        {
            return result
        }
        else
        {
            throw Static.DiscreteSystem.Errors.WrongState()
        }
    }
    
    //===
    
    public
    func update<Input: Static_State>(
        _: Input.Type,
        mutation: (inout Input) -> Void
        ) throws
    {
        if
            var result = state.current as? Input
        {
            mutation(&result)
            state.current = result
        }
        else
        {
            throw Static.DiscreteSystem.Errors.WrongState()
        }
    }
}
