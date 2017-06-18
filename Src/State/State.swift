import Foundation

/**
 Represents a distinct state that can be applied to any object of `Target` type.
 
 In general, consider each state as a pre-defined configuration for the object; each state defines mutations to be made on the object internal properties when this state is being applied.
 */
public
struct State<Target: AnyObject>
{
    /**
     Closure that serves as a wrapper inside which you can access any of the declared states for given object when applying a state via `Dispatcher`.
     */
    public
    typealias Getter = (_: Target.Type) -> State<Target>
    
    /**
     Closure that declares mutations to be made on `Target` object.
     */
    public
    typealias TargetMutation = (_: Target) -> Void
    
    /**
     Unique identifier that helps to distinct one state from another.
     */
    public
    let identifier: String
    
    /**
     Closure that will be called when the state is being applied after another state, or when current state of the object has not been set yet.
     */
    let onSet: TargetMutation
    
    /**
     Closure that will be called when the state is being re-applied, i.e. on attempt to apply this state when it is already the current state of the object.
     */
    let onUpdate: TargetMutation
    
    /**
     Full version of initializer, allows to explicitly set `onUpdate` closure.
     
     - Note: It is intentionally `internal` to avoid direct access from outside of this module.
     */
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
    
    /**
     Convenience short version of initializer that allows to create a `State` without providing `onUpdate` closure (which is optional for a state); the default `onUpdate` cloure implementation will be set, it does nothing.
     
     - Note: It is intentionally `internal` to avoid direct access from outside of this module.
     */
    init(
        _ identifier: String = NSUUID().uuidString,
        _ onSet: @escaping TargetMutation
        )
    {
        self.identifier = identifier
        self.onSet = onSet
        self.onUpdate = { _ in }
    }
}

//=== MARK: Equatable

extension State: Equatable
{
    /**
     Two instances of `State` considered to be equal if their `identifier` properties are equal, regardless of the content of `onSet` and `onUpdate` closures.
     */
    public
    static
    func == (lhs: State<Target>, rhs: State<Target>) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
}

//=== MARK: Utility

extension State
{
    /**
     Helper function that actually applies given state to given object.
     
     - Note: It is intentionally `internal` to avoid direct access from outside of this module.
     
     - Parameters:
     
         - state: State to be applied to the object.
     
         - target: Object to which we need to apply the `state`.
     
         - transition: Body of transition to be used to translate `target` from current state into new `state`.
     
         - completion: Closure to be called when transition into `state` is finished.
     */
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
