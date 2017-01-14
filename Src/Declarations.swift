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
struct TransitionParams
{
    public
    let mutation: () -> Void
    
    public
    let completion: (_ finished: Bool) -> Void
}
