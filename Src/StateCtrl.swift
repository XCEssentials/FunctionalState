//
//  StateCtrl.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

//public
//typealias Transition =
//(
//    _ mutation: @escaping () -> Void,
//    _ completion: @escaping  (_ finished: Bool) -> Void
//) -> Void

//===

public
final
class StateCtrl<Target: AnyObject>
{
    weak
    var target: Target?
    
    //===
    
    public fileprivate(set)
    var current: State<Target>? = nil
    
    public fileprivate(set)
    var next: State<Target>? = nil
    
    public
    var isReadyForTransition: Bool { return next == nil }
    
    //===
    
    public
    init(for view: Target)
    {
        self.target = view
    }
}

//=== MARK: Apply

extension StateCtrl
{
    func apply(_ getState: (_: Target.Type) -> State<Target>)
    {
        guard
            let target = target
        else
        {
            return
        }
        
        //===
        
        let state = getState(Target.self)
        
        state.mutation(target)
    }
}
