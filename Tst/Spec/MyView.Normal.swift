//
//  MyView.Normal.swift
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
    enum Normal
    {
        static
        let state = State() {
            
            $0.alpha = 1.0
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .clear
        }
    }
}
