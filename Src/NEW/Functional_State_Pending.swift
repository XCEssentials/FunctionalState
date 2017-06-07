import Foundation

//===

public
extension Functional.State
{
    public
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
extension Functional.State.Pending
{
    func onUpdate(
        _ onUpdate: @escaping TargetMutation
        ) -> Functional.State<Target>
    {
        return Functional.State<Target>(id, onSet, onUpdate)
    }
}
