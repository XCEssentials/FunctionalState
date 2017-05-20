//
//  State.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
struct State<Target: AnyObject>
{
    public
    typealias TargetMutation = (_: Target) -> Void
    
    let id: String
    
    let onSet: TargetMutation
    
    let onUpdate: TargetMutation
    
    //===
    
    init(
        _ id: String = NSUUID().uuidString,
        _ onSet: @escaping TargetMutation
        )
    {
        self.id = id
        self.onSet = onSet
        self.onUpdate = { _ in }
    }
    
    init(
        _ id: String = NSUUID().uuidString,
        _ onSet: @escaping TargetMutation,
        _ onUpdate: @escaping TargetMutation
        )
    {
        self.id = id
        self.onSet = onSet
        self.onUpdate = onUpdate
    }
}

//=== MARK: Equatable

// https://www.andrewcbancroft.com/2015/07/01/every-swift-value-type-should-be-equatable/

extension State: Equatable { }

public
func ==<LTarget: AnyObject, RTarget: AnyObject>(
    lhs: State<LTarget>,
    rhs: State<RTarget>
    ) -> Bool
{
    return lhs.id == rhs.id
}
