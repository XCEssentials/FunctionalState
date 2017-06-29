import XCTest

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
        
        disp = Dispatcher(for: aView)
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
            
            disp.internalState as? Dispatcher<MyView>.Ready
        }
        
        //===
        
        RXC.isNotNil("Dispatcher is ready for transition."){
            
            ready
        }
    }
    
    func testApplyStateInstantly()
    {
        disp.apply{ $0.normal() }
        
        //===
        
        let ready =
            
        RXC.value("State has been applied instantly."){
            
            disp.internalState as? Dispatcher<MyView>.Ready
        }
        
        //===
        
        RXC.isTrue("Current state of the target object is 'normal'."){
            
            ready?.current == MyView.normal()
        }
    }
    
    func testApplyStateTwice()
    {
        RXC.isNotNil("Target object is set."){
            
            disp.object
        }
        
        //===
        
        RXC.isNil("'color' property of the object has not been set yet."){
            
            disp.object?.color
        }
        
        //===
        
        let initialColorValue = 1
        
        disp.apply{ $0.highlighted(initialColorValue) }
        
        //===
        
        RXC.isTrue("'color' property of the object has been set."){
            
            disp.object?.color == initialColorValue
        }
        
        //===
        
        let updatedColorValue = 2
        
        disp.apply{ $0.highlighted(updatedColorValue) }
        
        //===
        
        RXC.isTrue("'color' property of the object has been updated."){
            
            disp.object?.color == updatedColorValue
        }
    }

    func testDefaultTransition()
    {
        var completionHasBeenCalled = false
        var transitionSucceeded = false
        
        //===
        
        disp.apply(MyView.normal()){ finished in
            
            completionHasBeenCalled = true
            transitionSucceeded = finished
        }
        
        //===
        
        let ready =
            
        RXC.value("State has been applied instantly."){
            
            disp.internalState as? Dispatcher<MyView>.Ready
        }
        
        //===
        
        RXC.isTrue("Current state of the target object is 'normal'."){
            
            ready?.current == MyView.normal()
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
        
//        disp.apply(
//            via: MyView.specialTransition,
//            { $0.disabled(0.6) },
//            completion: { if $0 { ex.fulfill() } }
//        )
        
//        disp.apply(
//            via: MyView.specialTransition,
//            MyView.disabled(0.6),
//            completion: { if $0 { ex.fulfill() } }
//        )
        
        disp.apply(via: MyView.specialTransition, MyView.disabled(0.6)) {
            
            if $0 { ex.fulfill() }
        }
        
        //===
        
        RXC.isTrue("State is being applied via transition."){
            
            disp.internalState is Dispatcher<MyView>.InTransition
        }
        
        //===
        
        waitForExpectations(timeout: MyView.animDuration*2)
        
        //===
        
        RXC.isTrue("Dispatcher is now ready for another transition."){
            
            disp.internalState is Dispatcher<MyView>.Ready
        }
    }
}
