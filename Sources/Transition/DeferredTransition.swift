import Foundation

//===

typealias DeferredTransition<Object: Stateful> =
(
    targetState: State<Object>,
    transition: Transition<Object>?,
    completion: Completion?
)
