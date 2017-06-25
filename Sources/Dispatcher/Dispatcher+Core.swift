import Foundation

import XCEStaticState

//===

extension Dispatcher
{
    /**
     Internal data structure that is needed to track internal dispatcher state.
     */
    final
    class Core: XCEStaticState.Stateful { }
}

//=== MARK: States

extension Dispatcher.Core
{
    /**
     Not in transition right now, ready for a new transition
     */
    struct Ready: XCEStaticState.State
    {
        /**
         Current object state, or `nil`, if it has not been set yet.
         */
        let current: State<Object>?
    }
    
    /**
     A transition into a new state is progress.
     */
    struct InTransition: XCEStaticState.State
    {
        /**
         The state which was current when transition has been started.
         */
        let previous: State<Object>?
        
        /**
         The state which will be current when transition will be finieshed.
         */
        let next: State<Object>
    }
}
