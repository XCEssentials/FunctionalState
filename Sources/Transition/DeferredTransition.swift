import Foundation

//===

typealias DeferredTransition<Object: Stateful> =
(
    State<Object>, // targetState
    Transition<Object>?,
    Completion?
)
