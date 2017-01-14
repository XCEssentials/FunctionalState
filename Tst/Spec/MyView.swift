//
//  MyView.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import UIKit

import MKHViewState

//===

class MyView: UIView, DiscreteSystem
{
    typealias State = ViewState<MyView>
    
    //===
    
    lazy
    var stateCtrl: StateCtrl<MyView> = StateCtrl(for: self)
}
