/**
 Completion block that gets the only `Bool` parameter, that indicates whatever related process has been finished or not.
 */
public
typealias Completion = (Bool) -> Void

//=== MARK: Prefixed aliases for all public top-level types

public
typealias FSTCompletion = Completion

public
typealias FSTState<Owner: Stateful> = State<Owner>

public
typealias FSTTransition<Owner: Stateful> = Transition<Owner>

public
typealias FSTDispatcher<Subject: Stateful> = Dispatcher<Subject>

public
typealias FSTStateful = Stateful
