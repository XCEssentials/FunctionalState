//
//  InternalState.swift
//  State
//
//  Created by Maxim Khatskevich on 6/6/17.
//
//

import Foundation

//===

protocol InternalState { }

//===

extension InternalState
{
    static
    func at(_ container: InternalStateContainer) throws -> Self
    {
        if
            let result = container.internalState as? Self
        {
            return result
        }
        else
        {
            throw Errors.WrongInternalState()
        }
    }
    
    static
    func update(
        at container: InternalStateContainer,
        mutation: (inout Self) -> Void
        ) throws
    {
        if
            var result = container.internalState as? Self
        {
            mutation(&result)
            container.internalState = result
        }
        else
        {
            throw Errors.WrongInternalState()
        }
    }
}
