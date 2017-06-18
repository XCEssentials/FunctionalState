import Foundation

//===

extension Dispatcher
{
    /**
     Schedules transition into a new state for processing.
     
     - Parameter task: Transition (wrapped with state getter and completion) that needs to be scheduled.
     */
    func enqueue(_ task: Transition<Target>.Wrapper)
    {
        queue.enqueue(task)
        
        //===
        
        processNext()
    }
    
    /**
     Starts processing scheduled transitions, if it's not processing yet.
     */
    func processNext()
    {
        guard
            let target = target,
            let now = core.state as? Core.Ready,
            let task = queue.dequeue() // dequeue after we chaked internalState!
        else
        {
            return
        }
        
        //===
        
        let newState = task.getState(Target.self)
        
        //===
        
        core.state = Core.InTransition(previous: now.current, next: newState)
        
        //===
        
        let readyForNextTask: Transition.Completion = {
            
            self.core.state = Core.Ready(current: newState)
            
            //===
            
            task.completion?($0)
            
            //===
            
            // in case transition was instant
            DispatchQueue.main.async {
                
                self.processNext()
            }
        }
        
        //===
        
        if
            now.current == newState
        {
            // just update current state
            
            newState.onUpdate(target)
            
            //===
            
            readyForNextTask(true)
        }
        else
        {
            // apply new state
            
            State.apply(
                newState,
                on: target,
                via: task.transition,
                completion: readyForNextTask
            )
        }
    }
}
