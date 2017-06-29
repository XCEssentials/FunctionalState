import Foundation

//===

extension Dispatcher
{
    /**
     Schedules transition into a new state for processing.
     
     - Parameter task: Transition (wrapped with state getter and completion) that needs to be scheduled.
     */
    func enqueue(_ task: DeferredTransition<Subject>)
    {
        let callOnMain = {
            
            self.queue.enqueue(task)
            
            //===
            
            self.processNext()
        }
        
        //===
        
        Thread.current == Thread.main ?
            callOnMain() : DispatchQueue.main.async(execute: callOnMain)
    }
    
    /**
     Starts processing scheduled transitions, if there teh queue is not empty and it's not processing yet.
     */
    private
    func processNext()
    {
        guard
            let now = internalState as? Ready,
            let (newState, forceTransition, completion) = queue.dequeue(),
            let subject = subject
        else
        {
            return
        }
        
        //===
        
        internalState = InTransition(previous: now.current, next: newState)
        
        //===
        
        let changes: () -> Void
        let transition: Transition<Subject>
        
        if
            now.current == newState
        {
            changes = { newState.onUpdate?(subject) }
            transition = forceTransition ?? newState.onUpdateTransition
        }
        else
        {
            changes = { newState.onSet(subject); newState.onUpdate?(subject) }
            transition = forceTransition ?? newState.onSetTransition
        }
        
        //===
        
        transition(subject, changes){ finished in
            
            self.internalState = Ready(current: newState)
            
            //===
            
            completion?(finished)
            
            //===
            
            self.processNext()
        }
    }
}
