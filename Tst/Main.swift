//
//  Main.swift
//  MKHStateTst
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCTest

import MKHState

//===

class Main: XCTestCase
{
    let aView = MyView()
    
    var ctrl: StateCtrl<MyView>!
    
    //===
    
    func testApplyDirectlyToView()
    {
        let ex = expectation(description: "After All States Apply")
        
        //===
        
        aView.become{ $0.highlighted(.blue) }
        
        //===
        
        aView.become(
            via: MyView.shortAnimation,
            { if $0 { ex.fulfill() } },
            { $0.disabled() })
        
        //===
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExample()
    {
        let ex2 = expectation(description: "Second state applied")
        let ex3 = expectation(description: "Third state applied")
        
        //===
        
        ctrl = StateCtrl(for: aView)
        
        //===
        
        ctrl.enqueue{ $0.highlighted(.blue) }
        
        //===
        
        XCTAssert(ctrl.isReadyForTransition)
        
        //===
        
        ctrl.enqueue(via: MyView.shortAnimation,
                     { if $0 { ex2.fulfill() } },
                     { $0.disabled() })
            .enqueue(via: MyView.shortAnimation,
                     { if $0 { ex3.fulfill() } },
                     { $0.normal(0.6) })
        
        //===
        
        XCTAssert(!ctrl.isReadyForTransition)
        
        //===
        
        waitForExpectations(timeout: 1.5)
    }
}
