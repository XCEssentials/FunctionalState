//
//  ViewState.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import UIKit

//===

public
final
class ViewState<TargetView: UIView>
{
    let id: ViewStateId
    
    let transition: Transition<TargetView>
    
    let mutation: Mutation<TargetView>
    
    //===
    
    public
    init(
        id: ViewStateId = NSUUID().uuidString,
        transition: @escaping Transition<TargetView> = { $0.mutation($0.view); $0.completion(true) },
        mutation: @escaping Mutation<TargetView>
        )
    {
        self.id = id
        self.transition = transition
        self.mutation = mutation
    }
}

//=== MARK: Equatable

// https://www.andrewcbancroft.com/2015/07/01/every-swift-value-type-should-be-equatable/

extension ViewState: Equatable { }

public
func ==<LView: UIView, RView: UIView>(lhs: ViewState<LView>, rhs: ViewState<RView>) -> Bool
{
    return lhs.id == rhs.id
}

//=== MARK: Apply

extension ViewState
{
    func apply(
        on view: TargetView,
        completion: @escaping TransitionCompletion
        )
    {
        transition(
            TransitionParams(
                mutation: mutation,
                view: view,
                completion: completion))
    }
}
