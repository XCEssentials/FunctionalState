//
//  MyView.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

import MKHState

//===

class MyView { }

//===

extension MyView: DiscreteSystem { }

//=== MARK: Special helpers

extension MyView
{
    static
    let shortAnimation: Transition = { (mutation, completion) in
        
        DispatchQueue
            .global()
            .async {
                
                print("Animating")
                mutation()
                
                //===
                
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.5) {
                        
                        print("Completing now!")
                        completion(true)
                    }
            }
    }
}
