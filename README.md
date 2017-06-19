[![GitHub tag](https://img.shields.io/github/tag/XCEssentials/FunctionalState.svg)](https://github.com/XCEssentials/FunctionalState/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/XCEFunctionalState.svg)](https://cocoapods.org/?q=XCEFunctionalState)
[![CocoaPods](https://img.shields.io/cocoapods/p/XCEFunctionalState.svg)](https://cocoapods.org/?q=XCEFunctionalState)
[![license](https://img.shields.io/github/license/XCEssentials/FunctionalState.svg)](https://opensource.org/licenses/MIT)

# Introduction

Turn any object into discrete system and describe its states declaratively.



# How to install

The recommended way is to install using [CocoaPods](https://cocoapods.org/?q=XCEFunctionalState):

```ruby
pod 'XCEFunctionalState', '~> 2.7'
```



# How it works

This library allows to turn any object into [discrete system](https://en.wikipedia.org/wiki/Discrete_system) by defining a number of distinct states and then applying these states instantly or via transition.



# How to use

A typical use case for this library is for re-configuring instances of `UIView` and its subclasses as your app state changes.



## State

Each state of a given object is represented by two closures. Each of these closures gets an instance of the object as input parameter and supposed to make mutations on internal object members. All such mutations together define a distinct state of the object.

First closure - `onSet` -  is required and declares mutations that must be made when the object transitions into the state. Second closure - `onUpdate` - is optional and declares mutations that must be made when the object transitions into the state and when the same state it is being applied again.



## Stateful

Let's say we have a class that represents a view with a text field where user can input their search keyword and a button that will start the search process when it's tapped:

```swift
class SearchView: UIView
{
  let keyword = UITextField()
  let start = UIButton()
}
```

To declare this class as discrete system, declare its conformance to `Stateful` protocol:

```swift
extension SearchView: Stateful
{
  // optionally lets declare a type alias
  // to shorten states declaration:
  typealias St = State<SearchView>
}
```

`Stateful` protocol does not require to implement anything, but exclusively provides access to special helper members that allow to declare and later apply states.

To describe a state for a given class, define a class level function (its name will be interpreted as the state name) inside this class that returns a `State` for this class.

For example, let's define `awaiting` state for our `SearchView` class in which both `keyword` text field and `start` button are enabled and available for user input. Note that we can define as many input parameters as we want for the function, and this gives us opportunity to pass any kind of values from the outside into the state configuration closure. See how in the example below we can pass default value for `keyword` field.

```swift
extension SearchView
{
    static
    func awaiting(with keyword: String) -> St
    {
        return state{

            $0.keyword.text = keyword
            $0.keyword.isEnabled = true
            $0.start.isEnabled = true
        }
    }
}
```

Once user has entered search keyword and tapepd `start` button we may want to lock these controls while search is in progress. To do so, we may want to apply a state `locked` on the search view, which may be declared as follows:

```swift
extension SearchView
{
    static
    func locked() -> St
    {
        return state{

            $0.keyword.isEnabled = false
            $0.start.isEnabled = false
        }
    }
}
```

Later in time, we can apply any of the states declared for the class to an instance of this class as follows:

```swift
let transition: Transition<SearchView>.Body = ... // define transition
let view = SearchView()

view.state.apply{ $0.awaiting(with: "something") }.instantly()
view.state.apply{ $0.awaiting(with: "something") }.instantly() // no effect
view.state.apply{ $0.locked() }.viaTransition() // with default transition
view.state.apply{ $0.awaiting(with: "after search") }.viaTransition(transition)
```

It's totally up to developer how to implement transition. When working with `UIView`-based classes, it's common to apply changes with animations, and `Transition` typealias gives full control over it.

We also can define transition that should be used by default when we apply a state with transition, but do not provide specific transition explicitly.

```swift
class SearchView: UIView
{
	//...
	
    static
    var defaultTransition: Transition<SearchView>.Body = {
    	
    	(view, mutations, completion) in

        view.alpha = 0.0

        //===

        mutations() // this is closure from the state

        //===

        UIView.animate(
        	withDuration: 1.0,
            animations: { v.alpha = 1.0 },
            completion: completion
        )
    }
	
	//...
}
```

The listing above demonstrates  default trnasition that hides whole view, then applies mutations from the new state, and then fades in whole view with animation, making it visible again. Alternatively, we could put `mutations()` call inside `animations` closure of the `UIView.animate(…)` call to animate actual mutations during fade-in animation, if so desired.

# Interoperability with Objective-C

To make the result code as concise and self explanatory as possible, as well as to maintaining compile time type safety, this library relies on advanced Swift language features like generics and closure shorthand argument names, so it is NOT intended to be compatible with Objective-C.