//
//  New.swift
//  State
//
//  Created by Maxim Khatskevich on 6/6/17.
//
//

import XCTest

@testable
import XCEState

//===

class New: XCTestCase
{
    func testStates()
    {
        let ctrl = Dispatcher()
        
        do
        {
            try print(Dispatcher.Undefined.at(ctrl))
            
            ctrl.internalState = Dispatcher.Ready()
            
            try print(Dispatcher.Ready.at(ctrl).current)
            try print(ctrl.at(Dispatcher.Ready.self).current)
            
            try Dispatcher.Ready.update(at: ctrl) {
                
                $0.current = 2
            }
            
            try print(Dispatcher.Ready.at(ctrl).current)
        }
        catch
        {
            print(error)
        }
    }
}
