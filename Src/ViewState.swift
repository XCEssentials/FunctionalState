//
//  ViewState.swift
//  MKHState
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
    let id: String
    
    let mutation: (_ view: TargetView) -> Void
    
    //===
    
    public
    init(
        id: String = NSUUID().uuidString,
        mutation: @escaping (_ view: TargetView) -> Void
        )
    {
        self.id = id
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
