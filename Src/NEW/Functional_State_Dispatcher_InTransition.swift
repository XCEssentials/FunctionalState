import Foundation

//===

extension Functional.State.Dispatcher
{
    struct InTransition: Static_State
    {
        // a transition into a new state is ongoing
        
        let previous: Functional.State<Target>?
        
        let next: Functional.State<Target>
    }
}
