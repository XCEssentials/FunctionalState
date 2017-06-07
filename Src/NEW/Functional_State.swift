import Foundation

//===

public
extension Functional
{
    public
    struct State<Target: AnyObject>
    {
        public
        typealias Getter = (_: Target.Type) -> State<Target>
   
        public
        typealias TargetMutation = (_: Target) -> Void
     
        //===
        
        public
        let id: String
        
        let onSet: TargetMutation
        
        let onUpdate: TargetMutation
        
        //===
        
        init(
            _ id: String = NSUUID().uuidString,
            _ onSet: @escaping TargetMutation
            )
        {
            self.id = id
            self.onSet = onSet
            self.onUpdate = { _ in }
        }
        
        init(
            _ id: String = NSUUID().uuidString,
            _ onSet: @escaping TargetMutation,
            _ onUpdate: @escaping TargetMutation
            )
        {
            self.id = id
            self.onSet = onSet
            self.onUpdate = onUpdate
        }
    }
}

//=== MARK: Equatable

// https://www.andrewcbancroft.com/2015/07/01/every-swift-value-type-should-be-equatable/

extension Functional.State: Equatable { }

public
func ==<LTarget: AnyObject, RTarget: AnyObject>(
    lhs: Functional.State<LTarget>,
    rhs: Functional.State<RTarget>
    ) -> Bool
{
    return lhs.id == rhs.id
}

//===

extension Functional.State
{
    static
    func apply(
        _ state: Functional.State<Target>,
        on target: Target,
        via transition: Functional.Transition<Target>.Body? = nil,
        completion: Functional.Transition<Target>.Completion? = nil
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
