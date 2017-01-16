//
//  MyView.Highlighted.swift
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
    enum Highlighted
    {
        static
        let state = St() {
            
            $0.alpha = 1.0
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .green
        }
    }
}
