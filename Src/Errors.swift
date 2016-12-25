//
//  Errors.swift
//  MKHViewState
//
//  Created by Maxim Khatskevich on 12/25/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
struct UnfinishedTransition: Error
{
    public
    var localizedDescription: String =
        "Attempt to execute a transition while another transition is in progress."
}
