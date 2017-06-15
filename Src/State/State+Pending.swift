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
        let identifier: String
        
        let onSet: TargetMutation
        
        //===
        
        init(
            _ identifier: String = NSUUID().uuidString,
            _ onSet: @escaping TargetMutation
            )
        {
            self.identifier = identifier
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
        return State<Target>(identifier, onSet, onUpdate)
    }
}
