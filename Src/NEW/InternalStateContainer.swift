//
//  InternalStateContainer.swift
//  State
//
//  Created by Maxim Khatskevich on 6/6/17.
//
//

import Foundation

//===

protocol InternalStateContainer: AnyObject
{
    var internalState: InternalState { get set }
}

//===

extension InternalStateContainer
{
    func at<Input: InternalState>(_ state: Input.Type) throws -> Input
    {
        return try Input.at(self)
    }
}
