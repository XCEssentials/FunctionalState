//
//  DiscreteSystem.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
protocol DiscreteSystem: class
{
    associatedtype Target: AnyObject
    
    var stateCtrl: StateCtrl<Target> { get }
}

//===

public
extension DiscreteSystem
{
    func apply(_ newState: State<Target>,
               transition: Transition? = nil)
    {
        stateCtrl.apply(newState, transition: transition)
    }
}
