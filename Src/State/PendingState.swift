//
//  PendingState.swift
//  State
//
//  Created by Maxim Khatskevich on 5/20/17.
//
//

import Foundation

//===

public
struct PendingState<Target: AnyObject>
{
    public
    typealias TargetMutation = (_: Target) -> Void
    
    let id: String
    
    let onSet: TargetMutation
    
    //===
    
    init(
        _ id: String = NSUUID().uuidString,
        _ onSet: @escaping TargetMutation
        )
    {
        self.id = id
        self.onSet = onSet
    }
}

//===

public
extension PendingState
{
    func onUpdate(_ onUpdate: @escaping TargetMutation) -> State<Target>
    {
        return State<Target>(id, onSet, onUpdate)
    }
}
