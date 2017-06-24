import Foundation

//===

public
struct State<Object: Stateful>
{
    public
    typealias ObjectMutation = (Object) -> Void
    
    //===
    
    let identifier: String
    
    let onSet: ObjectMutation
    let onUpdate: ObjectMutation?
    
    //===
    
    let onSetTransition: Transition<Object>
    let onUpdateTransition: Transition<Object>
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
extension State
{
    init(
        _ identifier: String = UUID().uuidString,
        onSet: @escaping ObjectMutation
        )
    {
        self.identifier = identifier
        
        self.onSet = onSet
        self.onUpdate = nil

        self.onSetTransition = Transition<Object>.defaultOnSetTransition
        self.onUpdateTransition = Transition<Object>.defaultOnUpdateTransition
    }
    
    init(
        _ identifier: String = UUID().uuidString,
        onSet: @escaping ObjectMutation,
        onUpdate: @escaping ObjectMutation
        )
    {
        self.identifier = identifier
        
        self.onSet = onSet
        self.onUpdate = onUpdate
        
        self.onSetTransition = Transition<Object>.defaultOnSetTransition
        self.onUpdateTransition = Transition<Object>.defaultOnUpdateTransition
    }
    
    init(
        _ identifier: String = UUID().uuidString,
        onSet: @escaping ObjectMutation,
        onUpdate: @escaping ObjectMutation,
        defaultTransition: Transition<Object>
        )
    {
        self.identifier = identifier
        
        self.onSet = onSet
        self.onUpdate = onUpdate
        
        self.onSetTransition = defaultTransition
        self.onUpdateTransition = defaultTransition
    }
    
    init(
        _ identifier: String = UUID().uuidString,
        onSet: @escaping ObjectMutation,
        onUpdate: @escaping ObjectMutation,
        defaultOnSetTransition: Transition<Object>,
        defaultOnUpdateTransition: Transition<Object>
        )
    {
        self.identifier = identifier
        
        self.onSet = onSet
        self.onUpdate = onUpdate
        
        self.onSetTransition = defaultOnSetTransition
        self.onUpdateTransition = defaultOnUpdateTransition
    }
}
