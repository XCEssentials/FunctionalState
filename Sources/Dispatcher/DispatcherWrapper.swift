import Foundation

//===

/**
 Internal helper data structure that works just as a scope for the `get(...)` function of `Dispatcher`.
 */
fileprivate
enum DispatcherWrapper // scope
{
    /**
     Key-value storage for lazy initializable object-dispatcher pairs. The object is `key`, and its dispatcher is `value`.
     
     - Note: Each dispatcher is saved here without meta data about its `Target` type, due to limitations of the data type of the storage.
     */
    static
    var storage = NSMapTable<AnyObject, AnyObject>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
}

//===

extension Dispatcher
{
    /**
     Designated helper function for accessing lazy-initializable dispatcher for any given object.
     
     - Parameters:
     
         - target: Object for which this dispatcher will track current state and manage transitions.
     
         - defaultTransition: Transition that will be used by default, if it will be requested to apply new state via transition, but NO exact transition will be specified.
     
     - Returns: `Dispatcher` instance for the given `target` object.
     */
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
