import Foundation

//===

/**
 Special container object that represents a single state. `Owner` generic type represents the type to which this state can be applied.
 */
public
struct State<Owner: Stateful>
{
    /**
     Closure that applies mutations to an instance of
     */
    public
    typealias OwnerMutation = (_ object: Owner) -> Void
    
    /**
     Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per state, regardless of the rest of the state internal member values.
     */
    let identifier: String
    
    /**
     Transition that will be used to apply `onSet` mutations.
     */
    let onSetTransition: Transition<Owner>
    
    /**
     Transition that will be used to apply `onUpdate` mutations.
     */
    let onUpdateTransition: Transition<Owner>
    
    /**
     Mutations that must be applied to the owner object to switch into this state from another state, or when current state is "undefined" yet.
     */
    let onSet: OwnerMutation
    
    /**
     Mutations that must be applied to the owner object to re-apply this state - when this state is already current state and it's requested to apply this state again. This might be useful to update some parameters that the state captures from the outer scope when gets called/created, while entire state stays the same.
     */
    let onUpdate: OwnerMutation?
    
    //===
    
    /**
     The only designated constructor, intentionally inaccessible from outer scope to make the static `state(...)` functions of `Stateful` protocol exclusive way of defining states for a given class. Its input parameters are just translated directly into corresponding internal state members.
     */
    fileprivate
    init(
        identifier: String,
        onSetTransition: @escaping Transition<Owner>,
        onUpdateTransition: @escaping Transition<Owner>,
        onSet: @escaping OwnerMutation,
        onUpdate: OwnerMutation?
        )
    {
        self.identifier = identifier
        
        self.onSetTransition = onSetTransition
        self.onUpdateTransition = onUpdateTransition
        
        self.onSet = onSet
        self.onUpdate = onUpdate
    }
}

//===

/**
 Two instances of the same state considered to be equal, regardless of the rest of the state internal member values.
 */
extension State: Equatable
{
    public
    static
    func == (left: State, right: State) -> Bool
    {
        return left.identifier == right.identifier
    }
}

//=== MARK: Initializers

public
extension Stateful
{
    /**
     One of the designated functions to define a state.
     
     - Parameters:
        
        - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per state, regardless of the rest of the state internal member values. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Owner` type while is very convenient for debugging.
     
        - onSetTransition: Transition that will be used to apply `onSet` mutations.
     
        - onUpdateTransition: Transition that will be used to apply `onUpdate` mutations.
     
        - onSet: Mutations that must be applied to the owner object to switch into this state from another state, or when current state is "undefined" yet.
     
     - Returns: State with `Self` as state `Owner` type, made of all the provided input parameters.
     */
    static
    func state(
        _ identifier: String = #function,
        onSetTransition: Transition<Self>? = nil,
        onUpdateTransition: Transition<Self>? = nil,
        onSet: State<Self>.OwnerMutation?
        ) -> State<Self>
    {
        return State(
            identifier: identifier,
            onSetTransition: onSetTransition ?? defaultOnSetTransition,
            onUpdateTransition: onUpdateTransition ?? defaultOnUpdateTransition,
            onSet: onSet ?? { _ in },
            onUpdate: nil
        )
    }
    
    /**
     One of the designated functions to define a state.
     
     - Parameters:
     
         - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per state, regardless of the rest of the state internal member values. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Owner` type while is very convenient for debugging.
         
         - onSetTransition: Transition that will be used to apply `onSet` mutations.
         
         - onUpdateTransition: Transition that will be used to apply `onUpdate` mutations.
         
         - onSet: Mutations that must be applied to the owner object to switch into this state from another state, or when current state is "undefined" yet.
         
         - onUpdate: Mutations that must be applied to the owner object to re-apply this state - when this state is already current state and it's requested to apply this state again. This might be useful to update some parameters that the state captures from the outer scope when gets called/created, while entire state stays the same.
     
     - Returns: State with `Self` as state `Owner` type, made of all the provided input parameters.
     */
    static
    func state(
        _ identifier: String = #function,
        onSetTransition: Transition<Self>? = nil,
        onUpdateTransition: Transition<Self>? = nil,
        onSet: State<Self>.OwnerMutation?,
        onUpdate: @escaping State<Self>.OwnerMutation
        ) -> State<Self>
    {
        return State(
            identifier: identifier,
            onSetTransition: onSetTransition ?? defaultOnSetTransition,
            onUpdateTransition: onUpdateTransition ?? defaultOnUpdateTransition,
            onSet: onSet ?? { _ in },
            onUpdate: onUpdate
        )
    }
}
