import Foundation

import XCEStaticState

//=== MARK: States

public
extension Dispatcher
{
    /**
     Not in transition right now, ready for a new transition
     */
    public
    struct Ready: XCEStaticState.State
    {
        public
        typealias Owner = Dispatcher
        
        /**
         Current object state, or `nil`, if it has not been set yet.
         */
        public
        let current: State<Subject>?
    }
    
    /**
     A transition into a new state is progress.
     */
    public
    struct InTransition: XCEStaticState.State
    {
        public
        typealias Owner = Dispatcher
        
        /**
         The state which was current when transition has been started.
         */
        public
        let previous: State<Subject>?
        
        /**
         The state which will be current when transition will be finieshed.
         */
        public
        let next: State<Subject>
    }
}
