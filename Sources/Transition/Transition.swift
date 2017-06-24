import Foundation

//===

public
struct Transition<Object: Stateful>
{
    let prepare: ((Object) -> Void)?
    let execute: (_ changes: () -> Void, Completion) -> Void
    let complete: ((Object) -> Void)?
    let description: String
}

//=== MARK: Helpers

public
extension Transition
{
    static
    var defaultOnSetTransition: Transition<Object>
    {
        return Transition<Object>.instant
    }
    
    static
    var defaultOnUpdateTransition: Transition<Object>
    {
        return Transition<Object>.instant
    }
    
    static
    var instant: Transition<Object>
    {
        return Transition(
            prepare: nil,
            execute: { $0(); $1(true) },
            complete: nil,
            description: "Instant"
        )
    }
}
