//
//  Tst_Private.swift
//  State
//
//  Created by Maxim Khatskevich on 6/6/17.
//
//

import XCTest

@testable
import XCEState

import XCETesting

//===

class Tst_Private: XCTestCase
{
    func testStates()
    {
        let ctrl = Dispatcher()
        
        //===
        
        RXC.isNotNil("In the beginning, the state is Undefined") {
            
            try? Dispatcher.Undefined.at(ctrl)
        }
        
        //===
        
        ctrl.internalState = Dispatcher.Ready()
        
        //===
        
        RXC.isNotNil("After set state to Ready, the state is actually Ready") {
            
            try? Dispatcher.Ready.at(ctrl)
        }
    }
}
