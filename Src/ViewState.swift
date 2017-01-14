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
struct TransitionParams
{
    public
    let mutation: () -> Void
    
    public
    let completion: (_ finished: Bool) -> Void
}

//===

public
final
class ViewState<TargetView: UIView>
{
    let id: String
    
    let transition: (_: TransitionParams) -> Void
    
    let mutation: (_ view: TargetView) -> Void
    
    //===
    
    public
    init(
        id: String = NSUUID().uuidString,
        transition: @escaping (_: TransitionParams) -> Void = { $0.mutation(); $0.completion(true) },
        mutation: @escaping (_ view: TargetView) -> Void
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
func ==<LView: UIView, RView: UIView>(
    lhs: ViewState<LView>,
    rhs: ViewState<RView>
    ) -> Bool
{
    return lhs.id == rhs.id
}

//=== MARK: Apply

extension ViewState
{
    func apply(
        on view: TargetView,
        completion: @escaping (_ finished: Bool) -> Void
        )
    {
        transition(
            TransitionParams(
                mutation: { self.mutation(view) },
                completion: completion))
    }
}
