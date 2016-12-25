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
            let targetView = targetView,
            isReadyForTransition
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
                self.transitioning = nil
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
