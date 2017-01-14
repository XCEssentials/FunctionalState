//
//  StateCtrl.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import UIKit

//===

public
final
class StateCtrl<TargetView: UIView>
{
    weak
    var targetView: TargetView?
    
    //===
    
    public fileprivate(set)
    var current: ViewState<TargetView>? = nil
    
    public fileprivate(set)
    var next: ViewState<TargetView>? = nil
    
    public
    var isReadyForTransition: Bool { return next == nil }
    
    //===
    
    public
    init(for view: TargetView)
    {
        self.targetView = view
    }
}

//=== MARK: Apply

extension StateCtrl
{
    func apply(_ newState: ViewState<TargetView>)
    {
        guard
            current != newState
        else
        {
            return // just return without doing anything
        }
        
        //===
        
        guard
            next.map({ $0 != newState }) ?? true
        else
        {
            return // just return without doing anything
        }
        
        //===
        
        /*
         
         Q: What we've checked so far?
         
         A: If we are already in the target state,
         or if we are currently transitioning into that state, then
         no need to do anything at all, and no need to throw an exception.
         
         */
        
        //===
        
        guard
            let targetView = targetView
        else
        {
            return
        }
        
        //===
        
        next = newState
        
        //===
        
        newState.apply(on: targetView) {
            
            if
                $0 // transition finished?
            {
                // YES
                
                self.current = newState
                self.next = nil
            }
            else
            {
                // NO
                
                // most likely transition has been
                // interupted by applying anopther state
            }
        }
    }
}
