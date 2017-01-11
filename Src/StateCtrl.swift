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
    
    public private(set)
    var current: ViewState<TargetView>
    
    public private(set)
    var next: ViewState<TargetView>? = nil
    
    //===
    
    public
    init(_ view: TargetView, _ current: ViewState<TargetView>)
    {
        self.targetView = view
        self.current = current
    }
    
    //===
    
    public
    func apply(_ newState: ViewState<TargetView>) throws
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
            isReadyForTransition
        else
        {
            throw UnfinishedTransition()
        }
        
        //===
        
        guard
            let targetView = targetView // must be optional to be weak!
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
        }
    }
}

//===

public
extension StateCtrl
{
    var isReadyForTransition: Bool { return next == nil }
}
