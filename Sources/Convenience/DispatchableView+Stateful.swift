public
extension Stateful where Self: DispatchableView
{
    var state: DispatcherProxy<Self>
    {
        return DispatcherProxy(dispatcher: stateDispatcher, object: self)
    }
}
