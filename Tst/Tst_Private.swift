//
//  Main.swift
//  MKHStateTst
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCTest

@testable
import XCEState

import XCEStaticState

//===

class Tst_Private: XCTestCase
{
    let aView = MyView()
    
    var disp: Dispatcher<MyView>!
    
    //===
    
    override
    func setUp()
    {
        super.setUp()
        
        //===
        
        disp = Dispatcher(for: aView, MyView.defaultTransition)
    }
    
    override
    func tearDown()
    {
        disp = nil
        
        //===
        
        super.tearDown()
    }
    
    func testExample()
    {
        let ex2 = expectation(description: "Second state applied")
        let ex3 = expectation(description: "Third state applied")
        
        //===
        
        // applying twice same state to check update block execution
        
        disp.apply{ $0.highlighted(.blue) }.instantly()
            .apply{ $0.highlighted(.blue) }.instantly()
        
        //===
        
        XCTAssert(disp.core.state is Dispatcher<MyView>.States.Ready)
        
        //===
        
        disp.apply{ $0.disabled() }
            .viaTransition{
                
                if $0 { ex2.fulfill() }
            }
            
            .apply{ $0.normal(0.6) }
            .via(MyView.specialTransition){
                
                if $0 { ex3.fulfill() }
            }
        
        //===
        
        XCTAssert(!(disp.core.state is Dispatcher<MyView>.States.Ready))
        
        //===
        
        waitForExpectations(timeout: 1.5)
    }
}
