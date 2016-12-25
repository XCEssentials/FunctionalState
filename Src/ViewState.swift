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

//===

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
