import Foundation

//===

extension Dispatcher
{
    func enqueue(_ task: Transition<Target>.Wrapper)
    {
        queue.enqueue(task)
        
        //===
        
        processNext()
    }
    
    func processNext()
    {
        guard
            let target = target,
            let now = core.state as? States.Ready,
            let task = queue.dequeue() // dequeue after we chaked internalState!
            else
        {
            return
        }
        
        //===
        
        let newState = task.getState(Target.self)
        
        //===
        
        guard
            now.current != newState
            else
        {
            newState.onUpdate(target) // current == newState
            
            //===
            
            return
        }
        
        //===
        
        core.state = States.InTransition(previous: now.current, next: newState)
        
        //===
        
        State.apply(newState, on: target, via: task.transition) {
            
            self.core.state = States.Ready(current: newState)
            
            //===
            
            task.completion?($0)
            
            //===
            
            self.processNext()
        }
    }
}
