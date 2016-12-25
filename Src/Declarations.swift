//
//  Declarations.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import UIKit

//===

public
typealias ViewStateId = String

public
typealias   Mutation<TargetView: UIView> = (_ view: TargetView) -> Void

public
typealias Transition<TargetView: UIView> = (_: TransitionParams<TargetView>) -> Void

public
struct TransitionParams<TargetView: UIView>
{
    public
    let mutation: Mutation<TargetView>
    
    public
    let view: TargetView
    
    public
    let completion: TransitionCompletion
}

public
typealias TransitionCompletion = (_ finished: Bool) -> Void
