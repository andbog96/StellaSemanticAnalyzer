enum Expression: Sendable {
    // MARK: - STLC
    case `var`(Name)
    indirect case abstraction(parameters: [(name: Name, rawType: RawType)], returnExpression: Expression)
    indirect case application(calle: Expression, arguments: [Expression])
    
    // MARK: - Bool
    case constTrue
    case constFalse
    indirect case `if`(condition: Expression, then: Expression, else: Expression)
    
    // MARK: - Nat
    case constInt(Int)
    indirect case succ(n: Expression)
    indirect case pred(n: Expression)
    indirect case isZero(n: Expression)
    indirect case natRec(n: Expression, zero: Expression, step: Expression)
    
    // MARK: - #unit-type
    case constUnit
    
    // MARK: - #pairs, #tuples
    case tuple(elements: [Expression])
    indirect case dotTuple(Expression, index: Int)

    // MARK: - #records
    case record(fields: [(label: Label, value: Expression)])
    indirect case dotRecord(Expression, Label)

    // MARK: - #let-patterns
    indirect case `let`(cases: [(pattern: Pattern, value: Expression)], inExpression: Expression)

    // MARK: - #letrec-bindings
    indirect case letrec(cases: [(pattern: Pattern, value: Expression)], inExpression: Expression)

    // MARK: - #type-ascriptions
    indirect case typeAscription(value: Expression, asRawType: RawType)

    // MARK: - #sum-types
    indirect case inl(left: Expression)
    indirect case inr(right: Expression)

    // MARK: - #variants
    indirect case variant(Label, data: Expression?)
    indirect case match(Expression, cases: [(pattern: Pattern, value: Expression)])

    // MARK: - #lists
    case list(elements: [Expression])
    indirect case cons(head: Expression, tail: Expression)
    indirect case head(list: Expression)
    indirect case tail(list: Expression)
    indirect case isEmpty(list: Expression)

    // MARK: - #fixpoint-combinator
    indirect case fix(generator: Expression)

    // MARK: - #sequencing
    indirect case sequence(first: Expression, second: Expression)

    // MARK: - #references
    case constMemory(MemoryAddress)
    indirect case reference(Expression)
    indirect case dereference(Expression)
    indirect case assign(variable: Expression, assignee: Expression)
    
    // MARK: - #panic
    case panic
    
    // MARK: - #exceptions
    indirect case `throw`(exception: Expression)
    indirect case tryWith(attempted: Expression, fallback: Expression)
    indirect case tryCatch(attempted: Expression, Pattern, handler: Expression)
    
    // MARK: - #type-cast
    indirect case typeCast(value: Expression, asRawType: RawType)

    // MARK: - #try-cast-as, #type-cast-patterns
    indirect case tryCastAs(Expression, asRawType: RawType, Pattern, Expression, with: Expression)

    // MARK: - #universal-types
    indirect case typeAbstraction([Name], Expression)
    indirect case typeApplication(Expression, [RawType])
}

//extension Expression: Equatable {
//    static func == (lhs: Expression, rhs: Expression) -> Bool {
//        switch (lhs, rhs) {
//        case let (.var(l), .var(r)):
//            l == r
//        case let (.abstraction(lp, le), .abstraction(rp, re)):
//            lp == rp && le == re
//        case let (.application(lf, la), .application(rf, ra)):
//            lf == rf && la == ra
//        
//        case (.constTrue, .constTrue):
//            true
//        case (.constFalse, .constFalse):
//            true
//        case let (.if(lc, lt, le), .if(rc, rt, re)):
//            lc == rc && lt == rt && le == re
//            
//        case let (.constInt(l), .constInt(r)):
//            l == r
//        case let (.succ(l), .succ(r)):
//            l == r
//        case let (.pred(l), .pred(r)):
//            l == r
//        case let (.isZero(l), .isZero(r)):
//            l == r
//        case let (.natRec(l1, l2, l3), .natRec(r1, r2, r3)):
//            l1 == r1 && l2 == r2 && l3 == r3
//            
//        case (.constUnit, .constUnit):
//            true
//            
//        case let (.tuple(l), .tuple(r)):
//            l == r
//        case let (.dotTuple(le, li), .dotTuple(re, ri)):
//            le == re && li == ri
//            
//        case let (.record(l), .record(r)):
//            l.count == r.count && zip(l, r).allSatisfy(==)
//        case let (.dotRecord(le, li), .dotRecord(re, ri)):
//            le == re && li == ri
//            
//        case let (.let(lb, le), .let(rb, re)):
//            lb.count == rb.count && zip(lb, rb).allSatisfy(==) && le == re
//            
//        case let (.letrec(lb, le), .letrec(rb, re)):
//            lb.count == rb.count && zip(lb, rb).allSatisfy(==) && le == re
//            
//        case let (.typeAscription(le, lt), .typeAscription(re, rt)):
//            le == re && lt == rt
//            
//        case let (.inl(l), .inl(r)):
//            l == r
//        case let (.inr(l), .inr(r)):
//            l == r
//            
//        case let (.list(l), .list(r)):
//            l == r
//        case let (.cons(l1, l2), .cons(r1, r2)):
//            l1 == r1 && l2 == r2
//        case let (.head(l), .head(r)):
//            l == r
//        case let (.tail(l), .tail(r)):
//            l == r
//        case let (.isEmpty(l), .isEmpty(r)):
//            l == r
//            
//        case let (.variant(li, le), .variant(ri, re)):
//            li == ri && le == re
//        case let (.match(le, lc), .match(re, rc)):
//            le == re && lc.count == rc.count && zip(lc, rc).allSatisfy(==)
//            
//        case let (.fix(l), .fix(r)):
//            l == r
//            
//        case let (.sequence(l1, l2), .sequence(r1, r2)):
//            l1 == r1 && l2 == r2
//            
//        case let (.ref(l), .ref(r)):
//            l == r
//        case let (.deref(l), .deref(r)):
//            l == r
//        case let (.assign(l1, l2), .assign(r1, r2)):
//            l1 == r1 && l2 == r2
//        case let (.constMemory(l), .constMemory(r)):
//            l == r
//            
//        case (.panic, .panic):
//            true
//            
//        case let (.throw(l), .throw(r)):
//            l == r
//        case let (.tryWith(l1, l2), .tryWith(r1, r2)):
//            l1 == r1 && l2 == r2
//        case let (.tryCatch(le, lp, lh), .tryCatch(re, rp, rh)):
//            le == re && lp == rp && lh == rh
//            
//        case let (.typeCast(le, lt), .typeCast(re, rt)):
//            le == re && lt == rt
//            
//        case let (.tryCastAs(le, lt, lp, lh, lw), .tryCastAs(re, rt, rp, rh, rw)):
//            le == re && lt == rt && lp == rp && lh == rh && lw == rw
//            
//        case let (.typeAbstraction(li, le), .typeAbstraction(ri, re)):
//            li == ri && le == re
//        case let (.typeApplication(le, lt), .typeApplication(re, rt)):
//            le == re && lt == rt
//            
//        default:
//            false
//        }
//    }
//}
