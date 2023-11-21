import UIKit

struct IntQueue<Element>{
    var elements: [Element] = []

    mutating func enqueue(_ element: Element) {
        elements.insert(element, at: 0)
    }

    mutating func dequeue() -> Element {
        return elements.removeFirst()
    }
    
    mutating func peek() -> Element?{
    
        return elements.first
    }
    
}

var queue1 = IntQueue<Int>()

queue1.enqueue(21)
queue1.enqueue(1)
queue1.enqueue(5)
queue1.enqueue(20)

queue1.dequeue()

var peekElement = queue1.peek()

print(queue1)
