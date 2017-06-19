import Foundation

//===

extension State
{
    /**
     Helper structure that works as mediator in the state declaration when we need to declare state with both `onSet` and `onUpdate` closures.
     
     An instance of this type is being returned by `onSet(...)` static function implemented in 'Stateful' protocol extension. Such technique makes possible nice chainable declarations like this:
     
     ```swift
     class MyView: Stateful {}
     
     extension MyView
     {
         static
         func initialized() -> State<MyView> // defines "initialized" state
         {
             return onSet{
     
                 // on set mutations go here...
             }
             .onUpdate{
     
                 // on update mutations go here...
             }
         }
     }
     
     ```
     */
    public
    struct Pending
    {
        /**
         The key part of the pending state, that holds its `identifier` vlaue and `onSet` closure, but needs to be completed with `onUpdate` closure.
         */
        public
        let partialState: State<Target>
        
        /**
         The only initializer.
         
         - Note: It is intentionally `internal` to avoid direct access from outside of this module.
         
         - Parameters
         
             - identifier: This value will be used as `identifier` for result state.
         
             - onSet: This closure will be used as `onSet` closure of result state.
         
         */
        init(
            _ identifier: String = NSUUID().uuidString,
            _ onSet: @escaping TargetMutation
            )
        {
            self.partialState = State(identifier, onSet)
        }
    }
}

//===

public
extension State.Pending
{
    /**
     Allows to finalize state declaration by adding given `onUpdate` closure to the already captured info.
     
     - Parameter onUpdate: This closure will be used as `onUpdate` closure of result state.
     
     - Returns: State that combines `identifier` and `onSet` from the `Pending` instance and given `onUpdate` closure.
     */
    func onUpdate(
        _ onUpdate: @escaping State<Target>.TargetMutation
        ) -> State<Target>
    {
        return State(
            partialState.identifier,
            partialState.onSet,
            onUpdate)
    }
}
