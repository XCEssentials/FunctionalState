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

//===

class Main: XCTestCase
{
    let aView = MyView()
    
    var disp: Functional.Dispatcher<MyView>!
    
    //===
    
    override
    func setUp()
    {
        super.setUp()
        
        //===
        
        disp = Functional.Dispatcher(for: aView, MyView.shortAnimation)
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
        
        XCTAssert(disp.state.current is Functional.Dispatcher<MyView>.Ready)
        
        
        //===
        
        disp.apply{ $0.disabled() }.viaTransition { if $0 { ex2.fulfill() } }
            .apply{ $0.normal(0.6) }.via(MyView.shortAnimation) { if $0 { ex3.fulfill() } }
        
        //===
        
        XCTAssert(!(disp.state.current is Functional.Dispatcher<MyView>.Ready))
        
        //===
        
        waitForExpectations(timeout: 1.5)
    }
}
