import XCTest

@testable
import XCEFunctionalState

import XCETesting

//===

class StatefulTests: XCTestCase
{
    var aView: MyView!
    
    //===
    
    override
    func setUp()
    {
        super.setUp()
        
        //---
        
        aView = MyView()
    }
    
    //===

    override
    func tearDown()
    {
        aView = nil
        
        //---
        
        super.tearDown()
    }
    
    //===

    func testFreshStart()
    {
        let ready =
            
        Assert("There is no state transition in progress right now.").isNotNil(
            
            self.aView.dispatcher.internalState as? Dispatcher.Ready
        )
        
        //---
        
        Assert("Dispatcher is ready for transition.").isNotNil(
            
            ready
        )
    }
    
    //===

    func testApplyStateInstantly()
    {
        aView.apply << MyView.normal()
        
        //---
        
        let ready =
            
        Assert("State has been applied instantly.").isNotNil(
            
            self.aView.dispatcher.internalState as? Dispatcher.Ready
        )
        
        //---
        
        Assert("Current state of the target object is 'normal'.").isTrue(
            
            ready?.current == MyView.normal().identifier
        )
    }
    
    //===

    func testApplyStateTwice()
    {
        Assert("'color' property of the object has not been set yet.").isNil(
            
            self.aView.color
        )
    
        //---
        
        let initialColorValue = 1
        
        aView.apply{ $0.highlighted(initialColorValue) }
        
        //---
        
        Assert("'color' property of the object has been set.").isTrue(
            
            self.aView.color == initialColorValue
        )
        
        //---
        
        let updatedColorValue = 2
        
        aView.apply{ $0.highlighted(updatedColorValue) }
        
        //---
        
        Assert("'color' property of the object has been updated.").isTrue(
            
            self.aView.color == updatedColorValue
        )
    }
    
    //===

    func testDefaultTransition()
    {
        var completionHasBeenCalled = false
        var transitionSucceeded = false
        
        //---
        
        aView.apply(state: MyView.normal()){ finished in

            completionHasBeenCalled = true
            transitionSucceeded = finished
        }
        
        //---
        
        let ready =
            
        Assert("State has been applied instantly.").isNotNil(
            
            self.aView.dispatcher.internalState as? Dispatcher.Ready
        )
    
        //---
        
        Assert("Current state of the target object is 'normal'.").isTrue(
            
            ready?.current == MyView.normal().identifier
        )
        
        //---
        
        Assert("Transition went as expected.").isTrue(
            
            completionHasBeenCalled && transitionSucceeded
        )
    }
    
    //===

    func testCustomTransitionWithDuration()
    {
        let ex = expectation(description: "Transition completed.")
        
        //---
        
        aView.apply(
            via: MyView.specialTransition,
            state: { $0.disabled(0.6) },
            completion: { if $0 { ex.fulfill() } }
        )
        
        //---
        
        Assert("State is being applied via transition.").isTrue(
            
            self.aView.dispatcher.internalState is Dispatcher.InTransition
        )
        
        //---
        
        waitForExpectations(timeout: MyView.animDuration*2)
        
        //---
        
        Assert("Dispatcher is now ready for another transition.").isTrue(

            self.aView.dispatcher.internalState is Dispatcher.Ready
        )
    }
}
