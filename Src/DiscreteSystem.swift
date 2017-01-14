//
//  DiscreteSystem.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import UIKit

//===

public
protocol DiscreteSystem: class
{
    associatedtype TargetView: UIView
    
    var stateCtrl: StateCtrl<TargetView> { get }
}

//===

public
extension DiscreteSystem
{
    func apply(_ newState: ViewState<TargetView>)
    {
        stateCtrl.apply(newState)
    }
}
