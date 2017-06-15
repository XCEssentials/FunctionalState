import Foundation

import XCEStaticState

//===

extension Dispatcher
{
    final
    class Core: XCEStaticState.Stateful { }
}

//===

extension Dispatcher.Core
{
    struct Ready: XCEStaticState.State
    {
        // ready for a new transition
        
        let current: State<Target>?
    }
    
    //===
    
    struct InTransition: XCEStaticState.State
    {
        // a transition into a new state is ongoing
        
        let previous: State<Target>?
        
        let next: State<Target>
    }
}
