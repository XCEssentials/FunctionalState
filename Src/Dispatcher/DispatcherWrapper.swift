import Foundation

//===

final
class DispatcherWrapper
{
    let dispatcher: AnyObject
    
    //===
    
    private
    init(with dispatcher: AnyObject)
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
    func get<Target: AnyObject>(
        for target: Target,
        with defaultTransition: Transition<Target>.Body?
        ) -> Dispatcher<Target>
    {
        if
            let wrapper = storage.object(forKey: target)
        {
            return wrapper.dispatcher as! Dispatcher<Target>
        }
        else
        {
            let result = Dispatcher(for: target, defaultTransition)
            storage.setObject(DispatcherWrapper(with: result), forKey: target)
            
            return result
        }
    }
}
