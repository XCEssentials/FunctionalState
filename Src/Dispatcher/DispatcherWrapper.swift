import Foundation

//===

fileprivate
enum DispatcherWrapper // scope
{
    static
    var storage = NSMapTable<AnyObject, AnyObject>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
}

//===

public
extension Dispatcher
{
    public
    static
    func get(
        for target: Target,
        with defaultTransition: Transition<Target>.Body?
        ) -> Dispatcher<Target>
    {
        if
            let dispatcher = DispatcherWrapper.storage.object(forKey: target),
            let result = dispatcher as? Dispatcher<Target>
        {
            return result
        }
        else
        {
            let result = Dispatcher(for: target, defaultTransition)
            DispatcherWrapper.storage.setObject(result, forKey: target)
            
            return result
        }
    }
}
