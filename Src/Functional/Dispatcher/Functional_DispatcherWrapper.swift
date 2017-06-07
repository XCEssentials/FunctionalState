import Foundation

//===

extension Functional
{
    final
    class DispatcherWrapper
    {
        let dispatcher: AnyObject
        
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
            with defaultTransition: Functional.Transition<Target>.Body? = nil
            ) -> DispatcherWrapper
        {
            if
                let result = storage.object(forKey: target)
            {
                return result
            }
            else
            {
                let disp = Dispatcher(for: target, defaultTransition)
                let result = DispatcherWrapper(with: disp)
                storage.setObject(result, forKey: target)
                
                return result
            }
        }
    }
}
