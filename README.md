[![GitHub tag](https://img.shields.io/github/tag/XCEssentials/State.svg)](https://github.com/XCEssentials/State/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/XCEState.svg)](https://cocoapods.org/?q=XCEState)
[![CocoaPods](https://img.shields.io/cocoapods/p/XCEState.svg)](https://cocoapods.org/?q=XCEState)
[![license](https://img.shields.io/github/license/XCEssentials/State.svg)](https://opensource.org/licenses/MIT)

## How to install

The recommended way is to install using [CocoaPods](https://cocoapods.org/?q=XCEState).

## How it works

This library allows to turn any object into [discrete system](https://en.wikipedia.org/wiki/Discrete_system) by defining a number of distinct states for any object and then applying these states at any point of time instantly or via transition. Additionally, there is a possibility to record current object state and avoid applying same state twice.

## How to use

A typical use case for this library is for re-configuring instances of `UIView` and its subclasses as your app state changes.

Let's say we have a class that represents a view with a text field where user can input their search keyword and a button that will start the search process when it's tapped:

```swift
class SearchView: UIView
{
  let keyword = UITextField()
  let start = UIButton()
}
```

State is represented by a special type `State` that has one associated generic type `Target`, which defines type of objects to which this state can be applied.

To declare a class as discrete system, declare its conformance to `DiscreteSystem` protocol:

```swift
extension SearchView: DiscreteSystem
{
  // optionally lets declare a type alias
  // to shorten states declaration:
  typealias St = State<SearchView>
}
```

`DiscreteSystem` protocol does not require to implement anything, but exclusively provides access to the following capabilities:

- class level function `state` - to create/declare a state for the class (`State` designated constructor is inaccessible directly);
- instance level function `apply` or `become` (alias) - apply appropriate state to an instance of the class.

To describe a state for a given class, define a class level function (its name will be interpreted as the state name) inside this class that returns an instance of type `State` with generic type `Target` set to this class. Use the `state` function provided by `DiscreteSystem` protocol to create a state. The `state` function expects the only input parameter, which is a closure that will be executed every time when this state will be applied to an appropriate object. The closure gets reference to an instance of `Target` class as the only input parameter.

For example, let's define an `awaiting` state for our `SearchView` class in which both `keyword` text field and `start` button are enabled and available for user input. Note that we can define as many input parameters as we want for the function, and this gives us opportunity to pass any kind of values from the outside into the state configuration closure. See how in the example below we can pass default value for `keyword` field.

```swift
extension SearchView
{
    static
    func awaiting(with keyword: String) -> St
    {
        return state {

            $0.keyword.text = keyword
            $0.keyword.isEnabled = true
            $0.start.isEnabled = true
        }
    }
}
```

Once user has entered search keyword and tapepd `start` button we may want to lock these controls while search is in progress. To do so, we may want to apply a state `locked` on the search view, which may be implemented as follows:

```swift
extension SearchView
{
    static
    func locked() -> St
    {
        return state {

            $0.keyword.isEnabled = false
            $0.start.isEnabled = false
        }
    }
}
```

Later in time, we can always apply any of the states declared inside the class to an instance of this class as follows:

```swift
let transition: Transition<SearchView> = ... // define transition
let view = SearchView()

// ...

view.apply{ $0.awaiting(with: "something") }.instantly() // applies instantly
view.apply{ $0.locked() }.viaTransition(transition) 

```

`Transition` is a special typealias that describes a closure that handles transition between states, it's declared like this:

```swift
typealias Transition<Target: AnyObject> =
    (
    _ target: Target,
    _ mutation: @escaping () -> Void,
    _ completion: @escaping Completion
    ) -> Void
```

Where `Completion` is declared like this:

```swift
typealias Completion = (_ finished: Bool) -> Void
```

To sum it up, it's totally up to developer how to implement transition. When working with `UIView`-based classes, it's common to apply changes with animations, and `Transition` type gives full control over it, allows to use different animations/transitions each time when apply a state, or use the same one all the time.

### State controller

When state is being applied directly to an object, there is no way to check in which state the object is at the moment, so there is no limitations on how many times same state might be applied. It's okay in some cases, but in most cases we would like to avoid applying same state twice, as it may lead to poor UX (especially if we apply it with animation). To achieve that it is necessary to use `StateCtrl` class, that represents state controller.

The recommended way of initializing and storing a state controller is demonstrated below:

```swift
// the recommended way to store state controller is inside its target class
class SearchView: UIView
{
	//...
	
	lazy // lazy declaration allows us to have access to 'self'
    var state: StateCtrl<SearchView> = StateCtrl(for: self)
	
	//...
}
```

We also can define transition that should be used by state controller by default, when we apply a state with transition, but do not provide specific transition explicitly.

```swift
enum Default
{
	static
    func viewAnim<View: UIView>() -> Transition<View>
    {
    	// this is simple fade-in animation of the whole view
    
        return { (view, mutations, completion) in

            view.alpha = 0.0

            //===

            mutations() // this is closure from the state

            //===

            UIView.animate(withDuration: 1.0,
                           animations: { v.alpha = 1.0 },
                           completion: completion)
        }
    }
}

class SearchView: UIView
{
	//...
	
	lazy
    var state: StateCtrl<SearchView> = StateCtrl(for: self, Default.viewAnim())
	
	//...
}
```

After we declared state controller, we can always apply any of the states declared inside the class to an instance of this class as follows:

```swift
let transition: Transition<SearchView> = ... // define a custom transition
let view = SearchView()

// ...

view.state.apply{ $0.awaiting(with: "something") }.instantly()
view.state.apply{ $0.awaiting(with: "something") }.instantly() // no effect
view.state.apply{ $0.locked() }.viaTransition() // with default transition
view.state.apply{ $0.awaiting(with: "after search") }.viaTransition(transition)
```

## Interoperability with Objective-C

To make the result code as concise and self explanatory as possible, while maintaining compile time type safety, this library relies on advanced Swift language features like generics and closure shorthand argument names, so it is NOT intended to be compatible with Objective-C.