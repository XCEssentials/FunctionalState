import Foundation

//===

public
extension Static
{
    enum State { } // scope
}

//===

public
protocol Static_State { }

//===

public
extension Static_State
{
    static
    var id: String { return "\(self)" }
}
