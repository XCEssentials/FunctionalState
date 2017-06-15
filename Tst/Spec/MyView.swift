import Foundation

import XCEState

//===

final
class MyView { }

//===

extension MyView: Stateful
{
    static
    let specialTransition: Transition<MyView>.Body = { (_, mutations, completion) in
        
        DispatchQueue.global().async {
                
            print("Animating")
            mutations()
            
            //===
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                print("Completing now!")
                completion(true)
            }
        }
    }
}
