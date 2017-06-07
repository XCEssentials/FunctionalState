//
//  MyView.Normal.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import UIKit

import XCEState

//===

extension MyView
{
    static
    func normal(_ opacity: CGFloat) -> Functional.State<MyView>
    {
        return state { (_) in
            
            print("Applying Normal state")
        }
    }
}
