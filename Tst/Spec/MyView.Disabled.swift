//
//  MyView.Disabled.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import UIKit

import MKHState

//===

extension MyView
{
    static
    func disabled() -> State<MyView>
    {
        return state { (_) in
            
            print("Applying Disabled state")
        }
    }
}
