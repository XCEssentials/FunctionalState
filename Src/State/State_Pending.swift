import Foundation

//===

public
extension State
{
    struct Pending
    {
        public
        typealias TargetMutation = (_: Target) -> Void
        
        public
        let id: String
        
        let onSet: TargetMutation
        
        //===
        
        init(
            _ id: String = NSUUID().uuidString,
            _ onSet: @escaping TargetMutation
            )
        {
            self.id = id
            self.onSet = onSet
        }
    }
}

//===

public
extension State.Pending
{
    func onUpdate(
        _ onUpdate: @escaping TargetMutation
        ) -> State<Target>
    {
        return State<Target>(id, onSet, onUpdate)
    }
}
