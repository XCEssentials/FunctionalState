//
//  MyView.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import UIKit

import MKHState

//===

class MyView: UIView, DiscreteSystem
{
    typealias St = State<MyView>
    
    //===
    
    lazy
    var stateCtrl: StateCtrl<MyView> = StateCtrl(for: self)
}

//=== MARK: Special helpers

extension MyView
{
    static
    let oneSecondAnimation: Transition =
        {
            UIView.animate(
                withDuration: 1.0,
                animations: $0,
                completion: $1
            )
    }
}
