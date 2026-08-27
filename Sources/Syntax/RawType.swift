enum RawType: Sendable {
    indirect case function(from: [Self], to: Self)
    case variable(Name)

    case bool
    case nat
    case unit

    case tuple(elements: [Self])
    case record(fields: [(label: Label, rawType: Self)])

    indirect case sum(left: Self, right: Self)
    case variant(cases: [(label: Label, rawType: Self?)])

    indirect case list(Self)
    
    indirect case mu(Name, Self)
    indirect case reference(Self)
    
    case top
    case bottom
    
    case auto
    indirect case forall(variables: [Name], rawType: Self)
}
//
//extension RawType: Equatable {
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        switch (lhs, rhs) {
//        case (.auto, .auto),
//             (.bool, .bool),
//             (.nat, .nat),
//             (.unit, .unit),
//             (.top, .top),
//             (.bottom, .bottom):
//            true
//        case let (.variable(id1), .variable(id2)):
//            id1 == id2
//        case let (.function(from1, to1), .function(from2, to2)):
//            from1 == from2 && to1 == to2
//        case let (.tuple(array1), .tuple(array2)):
//            array1 == array2
//        case let (.record(fields1), .record(fields2)):
//            zip(fields1, fields2).allSatisfy(==)
//        case let (.sum(left1, right1), .sum(left2, right2)):
//            left1 == left2 && right1 == right2
//        case let (.list(type1), .list(type2)):
//            type1 == type2
//        case let (.variant(array1), .variant(array2)):
//            zip(array1, array2).allSatisfy(==)
//        case let (.forall(vars1, type1), .forall(vars2, type2)):
//            vars1 == vars2 && type1 == type2
//        case let (.mu(id1, type1), .mu(id2, type2)):
//            id1 == id2 && type1 == type2
//        case let (.reference(type1), .reference(type2)):
//            type1 == type2
//        default:
//            false
//        }
//    }
//}
//
//extension RawType: Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(erased)
//        
//        switch self {
//        case let .variable(identifier):
//            hasher.combine(identifier)
//        case let .function(from, to):
//            hasher.combine(from)
//            hasher.combine(to)
//        case let .tuple(array):
//            for type in array {
//                hasher.combine(type)
//            }
//        case let .record(array):
//            for (name, type) in array {
//                hasher.combine(name)
//                hasher.combine(type)
//            }
//        case let .sum(left, right):
//            hasher.combine(left)
//            hasher.combine(right)
//        case let .list(type):
//            hasher.combine(type)
//        case let .variant(array):
//            for (name, type) in array {
//                hasher.combine(name)
//                hasher.combine(type)
//            }
//        case let .forall(variables, type):
//            hasher.combine(variables)
//            hasher.combine(type)
//        case let .mu(name, type):
//            hasher.combine(name)
//            hasher.combine(type)
//        case let .reference(type):
//            hasher.combine(type)
//        default:
//            break
//        }
//    }
//    
//    private enum Erased {
//        case auto
//        case bool
//        case nat
//        case unit
//        case top
//        case bottom
//        case variable
//        case function
//        case tuple
//        case record
//        case sum
//        case list
//        case variant
//        case forall
//        case mu
//        case reference
//    }
//}
