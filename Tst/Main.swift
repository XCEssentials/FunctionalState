//
//  Main.swift
//  MKHViewStateTst
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCTest
import UIKit

//@testable
import MKHViewState

//===

class Main: XCTestCase
{
    let aView = MyView()
    
    //===
    
    func testExample()
    {
        aView.state.apply(MyView.states.highlighted)
        
        //===
        
        XCTAssert(aView.state.isReadyForTransition)
        
        //===
        
        aView.state.apply(MyView.states.disabled)
        
        //===
        
        XCTAssert(!aView.state.isReadyForTransition) // because of animation 1.0 sec.
    }
}

//===

class MyView: UIView
{
    // http://mikebuss.com/2014/06/22/lazy-initialization-swift/

    lazy
    var state: StateCtrl<MyView> =
        { [unowned self] in StateCtrl(self, states.normal) }()
}

//=== MARK: States

extension MyView
{
    typealias State = ViewState<MyView>
    
    static
    let states = (
        
        normal: State() {
            
            $0.alpha = 1.0
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .clear
        },
        
        highlighted: State() {
            
            $0.alpha = 1.0
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .green
        },

        disabled: State(transition: Hlp.animateDisable) {
            
            $0.alpha = 0.5
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = .gray
        }
    )
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
