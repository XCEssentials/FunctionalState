//
//  MyView.Highlighted.swift
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
    func highlighted(_ color: UIColor) -> State<MyView>
    {
        return state { (_) in
            
            print("Applying Highlighted state")
        }
    }
}
