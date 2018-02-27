/*
 
 MIT License
 
 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

/**
 Turns any class into [discrete system](https://en.wikipedia.org/wiki/Discrete_system).
 */
public
protocol Stateful: class
{
    var dispatcher: Dispatcher { get }
}

// MARK: - State constructors

public
extension Stateful
{
    /**
     One of the designated functions to define a state.

     - Parameters:

     - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type while is very convenient for debugging.

     - onSetTransition: Transition that will be used to apply `onSet` mutations.

     - onSet: Closure that must be called to apply this state (when this state is NOT current yet, or current state is undefined yet, to make it current).

     - Returns: State with `Self` as state `Subject` type, made of all the provided input parameters.
     */
    func onSetOnly(
        stateId: StateIdentifier = #function,
        via transition: Transition<Self>? = nil,
        _ onSet: @escaping BasicClosure
        )
    {
        let state = State<Self>(
            identifier: stateId,
            onSet: (onSet, transition ?? DefaultTransitions.instant()),
            onUpdate: nil
        )

        dispatcher.queue.enqueue(state.toSomeState(with: self))

        dispatcher.processNext()
    }

    func onSetAndUpdate(
        stateId: StateIdentifier = #function,
        via sameTransition: Transition<Self>? = nil,
        _ onBoth: @escaping BasicClosure
        )
    {
        let state = State<Self>(
            identifier: stateId,
            onSet: (onBoth, sameTransition ?? DefaultTransitions.instant()),
            onUpdate: (onBoth, sameTransition ?? DefaultTransitions.instant())
        )

        dispatcher.queue.enqueue(state.toSomeState(with: self))

        dispatcher.processNext()
    }

    func onSetAndUpdate(
        stateId: StateIdentifier = #function,
        setVia onSetTransition: Transition<Self>? = nil,
        updateVia onUpdateTransition: Transition<Self>? = nil,
        _ onBoth: @escaping BasicClosure
        )
    {
        let state = State<Self>(
            identifier: stateId,
            onSet: (onBoth, onSetTransition ?? DefaultTransitions.instant()),
            onUpdate: (onBoth, onUpdateTransition ?? DefaultTransitions.instant())
        )

        dispatcher.queue.enqueue(state.toSomeState(with: self))

        dispatcher.processNext()
    }
}

//---

public
extension Stateful
{
    /**
     One of the designated functions to define a state.

     - Parameters:

     - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type while is very convenient for debugging.

     - onSetTransition: Transition that will be used to apply `onSet` mutations.

     - onSet: Closure that must be called to apply this state (when this state is NOT current yet, or current state is undefined yet, to make it current).

     - Returns: An intermediate data structure that is used as syntax suger to define a state with both 'onSet' and 'onUpdate' mutations via chainable API. It will keep inside a state value made of all provided parameters (with empty 'onUpdate').
     */
    func onSet(
        stateId: StateIdentifier = #function,
        via transition: Transition<Self>? = nil,
        _ onSet: @escaping BasicClosure
        ) -> PendingState<Self>
    {
        return PendingState(
            host: self,
            stateId: stateId,
            onSetTransition: transition ?? DefaultTransitions.instant(),
            onSetBody: onSet
        )
    }
}

//---

/**
 An intermediate data structure that is used as syntax suger to define a state with both 'onSet' and 'onUpdate' mutations via chainable API.
 */
public
struct PendingState<Subject: Stateful>
{
    fileprivate
    let host: Subject

    fileprivate
    let stateId: StateIdentifier

    fileprivate
    let onSetTransition: Transition<Subject>

    fileprivate
    let onSetBody: BasicClosure
}

public
extension PendingState
{
    /**
     One of the designated functions to define a state.

     - Parameters:

     - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type while is very convenient for debugging.

     - onUpdateTransition: Transition that will be used to apply `onUpdate` mutations.

     - onUpdate: Closure that must be called to apply this state when this state IS already current. This might be useful to update some parameters that the state captures from the outer scope when gets called/created, while entire state stays the same.

     - Returns: State with `Self.Subject` as state `Subject` type, made of all the provided input parameters plus 'identifier' and 'onSet' related values from internal state value.
     */
    func onUpdate(
        via onUpdateTransition: Transition<Subject>? = nil,
        _ onUpdateBody: @escaping BasicClosure
        )
    {
        let state = State<Subject>(
            identifier: stateId,
            onSet: (onSetBody, onSetTransition),
            onUpdate: (onUpdateBody, onUpdateTransition ?? DefaultTransitions.instant())
        )

        host.dispatcher.queue.enqueue(state.toSomeState(with: host))

        host.dispatcher.processNext()
    }
}
