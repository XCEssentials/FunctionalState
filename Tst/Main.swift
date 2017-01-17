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
    func testExample()
    {
        let aView = MyView()
        
        let ctrl = StateCtrl(for: aView)
        
        //===
        
        // aView.apply{ $0.highlighted(.blue) }
        ctrl.apply{ $0.highlighted(.blue) }
        
        //===
        
        XCTAssert(ctrl.isReadyForTransition)
        
        //===

        // aView.apply({ $0.disabled() }, via: MyView.oneSecondAnimation)
        ctrl.apply({ $0.disabled() }, via: MyView.oneSecondAnimation)
        
        //===
        
        // not ready, because of animation 1.0 sec.
        XCTAssert(!ctrl.isReadyForTransition)
    }
}
