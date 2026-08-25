struct CollectionOfTwo<Element>: Collection {
    let elements: (Element, Element)

    init(_ first: Element, _ second: Element) {
        elements = (first, second)
    }

    var startIndex: Int { 0 }
    var endIndex: Int { 2 }

    subscript(index: Int) -> Element {
        switch index {
        case 0: return elements.0
        case 1: return elements.1
        default: fatalError("Index out of bounds.")
        }
    }
    
    func index(after i: Int) -> Int {
        precondition(i < endIndex, "Can't advance beyond endIndex")
        return i + 1
    }
}
