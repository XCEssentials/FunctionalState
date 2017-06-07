//
//  Tst_Private.swift
//  State
//
//  Created by Maxim Khatskevich on 6/6/17.
//
//

import XCTest

import XCEState
import XCETesting

//===

class Tst_Public: XCTestCase
{
    let aView = MyView()
    
    //===
    
    func testExample()
    {
        let ex2 = expectation(description: "Second state applied")
        let ex3 = expectation(description: "Third state applied")
        
        //===
        
        // applying twice same state to check update block execution
        
        aView
            .state
            .apply{ $0.highlighted(.blue) }.instantly()
            .apply{ $0.highlighted(.blue) }.instantly()
        
        //===
        
        aView
            .state
            
            .apply{ $0.disabled() }
            .viaTransition { if $0 { ex2.fulfill() } }
            
            .apply{ $0.normal(0.6) }
            .via(MyView.defaultTransition!) { if $0 { ex3.fulfill() } }
        
        //===
        
        waitForExpectations(timeout: 1.5)
    }
}
