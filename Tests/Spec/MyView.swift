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
    enum StateIds: String
    {
        case normal
        case disabled
        case highlighted
    }

    static
    let animDuration = 0.5

    static
    func specialTransition(_ givenCompletion: @escaping Completion) -> Transition<MyView>
    {
        return { _, mutations, completion in

            DispatchQueue.global().async {

                mutations()

                //---

                // emulate animation with non-zero duration
                DispatchQueue.main.asyncAfter(deadline: .now() + animDuration) {

                    print("Completing now!")
                    completion(true)

                    givenCompletion(true)
                }
            }
        }
    }

    // MARK: - States

    func normal()
    {
        onSetOnly(stateId: StateIds.normal.rawValue)
        {
            print("Applying Normal state")
        }
    }

    func disabled(with opacity: Float, via specialTransition: Transition<MyView>? = nil)
    {
        onSetOnly(stateId: StateIds.disabled.rawValue, via: specialTransition)
        {
            print("Applying Disabled state")
        }
    }

    func highlighted(_ color: Int)
    {
        onSet(stateId: StateIds.highlighted.rawValue)
        {
            print("Applying Highlighted state")

            self.color = color
        }
        .onUpdate
        {
            print("Updating Highlighted state")

            self.color = color
        }
    }
}
