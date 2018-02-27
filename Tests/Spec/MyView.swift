import UIKit

import XCEFunctionalState

//---

final
class MyView: UIView, Stateful
{
    let dispatcher = Dispatcher()

    //---

    var color: Int?
}

//---

extension MyView
{
    static
    let animDuration = 0.5

    static
    var specialTransition: Transition<MyView>
    {
        return { _, mutations, completion in

            DispatchQueue.global().async {

                mutations()

                //---

                // emulate animation with non-zero duration
                DispatchQueue.main.asyncAfter(deadline: .now() + animDuration) {

                    print("Completing now!")
                    completion(true)
                }
            }
        }
    }

    // MARK: - States

    static
    func normal() -> State<MyView>
    {
        return state{ _ in

            print("Applying Normal state")
        }
    }

    static
    func disabled(_ opacity: Float) -> State<MyView>
    {
        return state{ _ in

            print("Applying Disabled state")
        }
    }

    static
    func highlighted(_ color: Int) -> State<MyView>
    {
        return onSet {

            print("Applying Highlighted state")

            $0.color = color
        }
        .onUpdate {

            print("Updating Highlighted state")

            $0.color = color
        }
    }
}
