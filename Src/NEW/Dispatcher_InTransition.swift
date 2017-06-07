//
//  Dispatcher_InTransition.swift
//  State
//
//  Created by Maxim Khatskevich on 6/7/17.
//
//

import Foundation

//===

extension Dispatcher
{
    struct InTransition: InternalState
    {
        // a transition into a new state is ongoing
        
        let previous: State<Target>?
        
        let next: State<Target>
    }
}
