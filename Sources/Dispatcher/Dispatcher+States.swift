import Foundation

import XCEStaticState

//=== MARK: States

extension Dispatcher
{
    /**
     Not in transition right now, ready for a new transition
     */
    struct Ready: XCEStaticState.State
    {
        typealias Owner = Dispatcher
        
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
        typealias Owner = Dispatcher
        
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
