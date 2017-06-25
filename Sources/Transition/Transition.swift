import Foundation

//===

public
typealias Transition<Object: Stateful> = (
    Object,
    @escaping () -> Void,
    @escaping Completion
    ) -> Void
