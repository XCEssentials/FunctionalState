//
//  Utils.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/17/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

enum Utils
{
    static
    func apply<Target: AnyObject>(
        _ state: State<Target>,
        on target: Target,
        via transition: GenericTransition? = nil,
        completion: Completion? = nil
        )
    {
        let mutation = { state.mutation(target) }
        
        let transition = transition ?? { $0(); $1(true) }
        
        let completion = completion ?? { _ in }
        
        //===
        
        // actually apply state mutation now:
        
        transition(mutation, completion)
    }
}
