import Foundation

//===

public
extension Static
{
    public
    enum State { } // scope
}

//===

public
protocol Static_State { }

//===

public
extension Static_State
{
    public
    static
    var id: String { return "\(self)" }
}
