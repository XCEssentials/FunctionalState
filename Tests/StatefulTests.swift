import XCTest

@testable
import XCEFunctionalState

import XCEStaticState

import XCETesting

//===

class StatefulTests: XCTestCase
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
    
    func testFreshStart()
    {
        let ready =
            
        RXC.value("There is no state transition in progress right now."){
            
            disp.core.state as? Dispatcher<MyView>.Core.Ready
        }
        
        //===
        
        RXC.isNotNil("Dispatcher is ready for transition."){
            
            ready
        }
    }
    
    func testApplyStateInstantly()
    {
        disp.apply{ $0.normal() }.instantly()
        
        //===
        
        let ready =
            
        RXC.value("State has been applied instantly."){
            
            disp.core.state as? Dispatcher<MyView>.Core.Ready
        }
        
        //===
        
        RXC.isTrue("Current state of the target object is 'normal'."){
            
            ready?.current?.identifier == MyView.normal().identifier
        }
    }
    
    func testApplyStateTwice()
    {
        RXC.isNotNil("Target object is set."){
            
            disp.target
        }
        
        //===
        
        RXC.isNil("'color' property of the object has not been set yet."){
            
            disp.target?.color
        }
        
        //===
        
        let initialColorValue = 1
        
        disp.apply{ $0.highlighted(initialColorValue) }.instantly()
        
        //===
        
        RXC.isTrue("'color' property of the object has been set."){
            
            disp.target?.color == initialColorValue
        }
        
        //===
        
        let updatedColorValue = 2
        
        disp.apply{ $0.highlighted(updatedColorValue) }.instantly()
        
        //===
        
        RXC.isTrue("'color' property of the object has been updated."){
            
            disp.target?.color == updatedColorValue
        }
    }
    
    func testDefaultTransition()
    {
        var completionHasBeenCalled = false
        var transitionSucceeded = false
        
        //===
        
        disp.apply{ $0.normal() }.viaTransition{
                
            completionHasBeenCalled = true
            transitionSucceeded = $0
        }
        
        //===
        
        let ready =
            
        RXC.value("State has been applied instantly."){
            
            disp.core.state as? Dispatcher<MyView>.Core.Ready
        }
        
        //===
        
        RXC.isTrue("Current state of the target object is 'normal'."){
            
            ready?.current?.identifier == MyView.normal().identifier
        }
        
        //===
        
        RXC.isTrue("Transition went as expected."){
            
            completionHasBeenCalled && transitionSucceeded
        }
    }
    
    func testCustomTransitionWithDuration()
    {
        let ex = expectation(description: "Transition completed.")
        
        //===
        
        disp.apply{ $0.disabled(0.6) }.via(MyView.specialTransition){
                
            if $0 { ex.fulfill() }
        }
        
        //===
        
        RXC.isTrue("State is being applied via transition."){
            
            disp.core.state is Dispatcher<MyView>.Core.InTransition
        }
        
        //===
        
        waitForExpectations(timeout: MyView.animDuration*2)
        
        //===
        
        RXC.isTrue("Dispatcher is now ready for another transition."){
            
            disp.core.state is Dispatcher<MyView>.Core.Ready
        }
    }
}
