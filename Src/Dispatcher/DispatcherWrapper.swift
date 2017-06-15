import Foundation

//===

final
class DispatcherWrapper
{
    let dispatcher: AnyObject
    
    //===
    
    private
    init<Target>(with dispatcher: Dispatcher<Target>)
    {
        self.dispatcher = dispatcher
    }
    
    //===
    
    private
    static
    var storage = NSMapTable<AnyObject, DispatcherWrapper>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    //===
    
    public
    static
    func get<Target>(
        for target: Target,
        with defaultTransition: Transition<Target>.Body?
        ) -> Dispatcher<Target>
    {
        if
            let wrapper = storage.object(forKey: target),
            let result = wrapper.dispatcher as? Dispatcher<Target>
        {
            return result
        }
        else
        {
            let result = Dispatcher(for: target, defaultTransition)
            storage.setObject(DispatcherWrapper(with: result), forKey: target)
            
            return result
        }
    }
}
