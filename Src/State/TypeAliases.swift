//
//  TypeAliases.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/17/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
typealias StateGetter<Target: AnyObject> = (_: Target.Type) -> State<Target>

//===

public
typealias Completion = (_ finished: Bool) -> Void

//===

public
typealias Transition<Target: AnyObject> =
    (
    _ target: Target,
    _ mutation: @escaping () -> Void,
    _ completion: @escaping Completion
    ) -> Void

//===

public
typealias StateTransitionTask<Target: AnyObject> = (
    getState: StateGetter<Target>,
    transition: Transition<Target>?,
    completion: Completion?
)
