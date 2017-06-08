import UIKit

import XCEState

//===

extension MyView
{
    static
    func normal(_ opacity: CGFloat) -> State<MyView>
    {
        return state { (_) in
            
            print("Applying Normal state")
        }
    }
}
