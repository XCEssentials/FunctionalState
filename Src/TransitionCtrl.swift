//
//  TransitionCtrl.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import UIKit

//===

public
final
class TransitionCtrl<TargetView: UIView>
{
    weak
    var targetView: TargetView?
    
    public private(set)
    var current: ViewState<TargetView>
    
    public private(set)
    var transitioning: (from: ViewState<TargetView>, to: ViewState<TargetView>)? = nil
    
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
            transitioning.map({ $0.to != newState }) ?? true
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
            isReadyForTransition,
            let targetView = targetView
        else
        {
            throw UnfinishedTransition()
        }
        
        //===
        
        transitioning = (from: current, to: newState)
        
        //===
        
        newState.apply(on: targetView) {
            
            if
                $0
            {
                self.current = newState
                self.transitioning = nil
            }
            else
            {
                // no need to do anything,
                // most likely another transition
                // is currently in progress
            }
        }
    }
}

//===

public
extension TransitionCtrl
{
    var isReadyForTransition: Bool { return transitioning == nil }
}
