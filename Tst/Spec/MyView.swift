import Foundation

import XCEState

//===

final
class MyView { }

//===

extension MyView: Stateful
{
    static
    let defaultTransition: Transition<MyView>.Body? = { (_, m, c) in
        
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
