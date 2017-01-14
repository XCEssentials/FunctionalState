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
        let state = State(transition: Hlp.animateDisable) {
            
            $0.alpha = 0.5
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = .gray
        }
    }
}

//=== MARK: Special helpers

enum Hlp
{
    static
    func animateDisable(_ params: TransitionParams) -> Void
    {
        UIView.animate(
            withDuration: 1.0,
            animations: params.mutation,
            completion: params.completion
        )
    }
}
