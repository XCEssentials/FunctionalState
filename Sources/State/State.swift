import Foundation

//===

public
struct State<Object: Stateful>
{
    public
    typealias ObjectMutation = (Object) -> Void
    
    //===

    let identifier: String
    
    //===
    
    let onSetTransition: Transition<Object>
    let onUpdateTransition: Transition<Object>
    
    let onSet: ObjectMutation
    let onUpdate: ObjectMutation?
    
    //===
    
    fileprivate
    init(
        identifier: String,
        onSetTransition: @escaping Transition<Object>,
        onUpdateTransition: @escaping Transition<Object>,
        onSet: @escaping ObjectMutation,
        onUpdate: ObjectMutation?
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
    static
    func state(
        _ identifier: String = #function,
        onSetTransition: Transition<Self>? = nil,
        onUpdateTransition: Transition<Self>? = nil,
        onSet: State<Self>.ObjectMutation?
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
    
    static
    func state(
        _ identifier: String = #function,
        onSetTransition: Transition<Self>? = nil,
        onUpdateTransition: Transition<Self>? = nil,
        onSet: State<Self>.ObjectMutation?,
        onUpdate: @escaping State<Self>.ObjectMutation
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
