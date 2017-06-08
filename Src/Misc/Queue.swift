//
//  Queue.swift
//  State
//
//  Created by Maxim Khatskevich on 5/19/17.
//
//  https://github.com/raywenderlich/swift-algorithm-club/tree/master/Queue
//

import Foundation

//===

struct Queue<T>
{
    fileprivate
    var array = [T]()
    
    var isEmpty: Bool
    {
        return array.isEmpty
    }
    
    var count: Int
    {
        return array.count
    }
    
    var front: T?
    {
        return array.first
    }
    
    mutating
    func enqueue(_ element: T)
    {
        array.append(element)
    }
    
    mutating
    func dequeue() -> T?
    {
        if
            isEmpty
        {
            return nil
        }
        else
        {
            return array.removeFirst()
        }
    }
    
    mutating
    func reset()
    {
        array.removeAll()
    }
}
