import Foundation

//===

public
struct State<Target: AnyObject>
{
    public
    typealias Getter = (_: Target.Type) -> State<Target>
    
    public
    typealias TargetMutation = (_: Target) -> Void
    
    //===
    
    public
    let identifier: String
    
    let onSet: TargetMutation
    
    let onUpdate: TargetMutation
    
    //===
    
    init(
        _ identifier: String = NSUUID().uuidString,
        _ onSet: @escaping TargetMutation
        )
    {
        self.identifier = identifier
        self.onSet = onSet
        self.onUpdate = { _ in }
    }
    
    init(
        _ identifier: String = NSUUID().uuidString,
        _ onSet: @escaping TargetMutation,
        _ onUpdate: @escaping TargetMutation
        )
    {
        self.identifier = identifier
        self.onSet = onSet
        self.onUpdate = onUpdate
    }
}

//=== MARK: Equatable

extension State: Equatable
{
    public
    static
    func == (lhs: State<Target>, rhs: State<Target>) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
}

//===

extension State
{
    static
    func apply(
        _ state: State<Target>,
        on target: Target,
        via transition: Transition<Target>.Body? = nil,
        completion: Transition<Target>.Completion? = nil
        )
    {
        let mutation = {
            
            state.onSet(target)
            state.onUpdate(target)
        }
        
        let completion = completion ?? { _ in }
        
        let transition = transition ?? { $1(); $2(true) }
        
        //===
        
        // actually apply state mutation now:
        
        transition(target, mutation, completion)
    }
}
