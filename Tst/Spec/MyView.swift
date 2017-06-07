//
//  MyView.swift
//  MKHState
//
//  Created by Maxim Khatskevich on 1/14/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

import XCEState

//===

final
class MyView { }

//===

extension MyView: Functional_DiscreteSystem
{
    static
    let defaultTransition: Functional.Transition<MyView>.Body? = { (_, m, c) in
        
        DispatchQueue.global().async {
                
            print("Animating")
            m()
            
            //===
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                print("Completing now!")
                c(true)
            }
        }
    }
}
