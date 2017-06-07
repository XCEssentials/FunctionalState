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
        let target = NSObject()
        
        let disp = Dispatcher<NSObject>(with: target)
        
        //===
        
        let ready =
        
        RXC.value("In the beginning, the state is Ready") {
            
            try? Dispatcher<NSObject>.Ready.at(disp)
        }!
        
        //===
        
        RXC.isNil("Current state is undefined") {
            
            return ready.current
        }
        
        
        
//        //===
//        
//        disp.internalState = Dispatcher.Ready(current: nil)
//        
//        //===
//        
//        RXC.isNotNil("After set state to Ready, the state is actually Ready") {
//            
//            try? Dispatcher.Ready.at(disp)
//        }
    }
}
