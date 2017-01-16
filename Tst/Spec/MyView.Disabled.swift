//
//  MyView.Disabled.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import UIKit

import MKHViewState

//===

extension MyView
{
    enum Disabled
    {
        static
        let state = State() {
            
            $0.alpha = 0.5
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = .gray
        }
    }
}
