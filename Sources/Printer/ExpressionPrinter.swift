private extension Expression {
    var level: Int {
        switch self {
        case .sequence,
             .let,
             .letrec,
             .typeAbstraction:
            0
        case .assign,
             .if: 1
        case .typeAscription,
             .typeCast,
             .abstraction:
            3
        case .variant,
             .match,
             .list:
            3
        case .ref,
             .deref:
            5
        case .application,
             .typeApplication,
             .dotRecord,
             .dotTuple,
             .tuple,
             .record:
            6
        case .cons,
             .head,
             .isEmpty,
             .tail,
             .panic,
             .throw,
             .tryCatch,
             .tryWith:
            6
        case .tryCastAs,
             .inl,
             .inr,
             .succ,
             .pred,
             .isZero:
            6
        case .fix,
             .natRec:
            6
        case .constTrue,
             .constFalse,
             .constUnit,
             .constInt,
             .constMemory,
             .var:
            7
        }
    }

    func code(on level: Int) -> String {
        if self.level < level {
            "(\(self))"
        } else {
            "\(self)"
        }
    }
}

private func patternBinding(pattern: Pattern, expr: Expression) -> String {
    "\(pattern) = \(expr)"
}

private func patternBranch(pattern: Pattern, expr: Expression) -> String {
    "\(pattern) => \(expr)"
}

private func recordBinding(label: Name, expr: Expression) -> String {
    "\(label) = \(expr)"
}

extension Expression: CustomStringConvertible {
    var description: String {
        switch self {
        case .constTrue: 
            "true"
        case .constFalse:
            "false"
        case .constUnit:
            "unit"
        case .constInt(let value):
            value.description
        case .constMemory(let address):
            address.description
        case .var(let identifier):
            identifier.description
        case .sequence(let expression1, let expression2):
            "\(expression1.code(on: 1)); \(expression2)" // code(on: 0) == code
        case .assign(let expression1, let expression2):
            "\(expression1.code(on: 2)) := \(expression2.code(on: 1))"
        case .if(let condition, let then, let `else`):
            "if \(condition.code(on: 1)) then \(then.code(on: 1)) else \(`else`.code(on: 1))"
        case .let(let bindings, let expr):
            "let \(bindings.map(patternBinding).joined(separator: ", ")) in \(expr)"
        case .letrec(let bindings, let expr):
            "letrec \(bindings.map(patternBinding).joined(separator: ", ")) in \(expr)"
        case .typeAbstraction(let vars, let expr):
            "generic[\(vars.map(\.description).joined(separator: ", "))] \(expr)"
        case .typeAscription(let expression, let type):
            // formally in here and in the next one, only type2 allowed, but don't care
            "\(expression.code(on: 3)) as \(type)"
        case .typeCast(let expression, let type):
            "\(expression.code(on: 3)) cast as \(type)"
        case .abstraction(let params, let expression):
            """
            fn(\(params.map({"\($0.name): \($0.type)"}).joined(separator: ", "))) {
                return \(indented: expression)
            }
            """
        case .variant(let identifier, let expression):
            "<|\(identifier)\(expression.map {" = \($0)"} ?? "")|>"
        case .match(let expression, let branches):
            """
            match \(expression.code(on: 2)) {
                \(indented: branches.map(patternBranch).joined(separator: "\n| "))
            }
            """
        case .list(let array):
            "[\(array.map(\.description).joined(separator: ", "))]"
        case .ref(let expression):
            "new(\(expression))"
        case .deref(let expression):
            "*\(expression.code(on: 5))"
        case .application(let callee, let arguments):
            "\(callee.code(on: 6))(\(arguments.map(\.description).joined(separator: ", ")))"
        case .typeApplication(let callee, let typeArguments):
            "\(callee.code(on: 6))[\(typeArguments.map(\.description).joined(separator: ", "))]"
        case .dotRecord(let expression, let identifier):
            "\(expression.code(on: 6)).\(identifier)"
        case .dotTuple(let expression, let int):
            "\(expression.code(on: 6)).\(int)"
        case .tuple(let array):
            "{\(array.map(\.description).joined(separator: ", "))}"
        case .record(let fields):
            "{\(fields.map(recordBinding).joined(separator: ", "))}"
        case .cons(let expression, let expression2):
            "cons(\(expression), \(expression2))"
        case .head(let expression):
            "List::head(\(expression))"
        case .isEmpty(let expression):
            "List::isempty(\(expression))"
        case .tail(let expression):
            "List::tail(\(expression))"
        case .panic: 
            "panic!"
        case .throw(let expression):
            "throw(\(expression))"
        case .tryCatch(let attempted, let pattern, let handler):
            """
            try {
                \(indented: attempted)
            } catch {
                \(pattern) => \(indented: handler)
            }
            """
        case .tryWith(let expression, let fallback):
            """
            try {
                \(indented: expression)
            } with {
                \(indented: fallback)
            }
            """
        case .tryCastAs(let expression, let type, let pattern, let handler, let with):
            """
            try {
                \(indented: expression)
            } cast as \(type) {
                \(pattern) => \(indented: handler)
            } with {
                \(indented: with)
            }
            """
        case .inl(let expression):
            "inl(\(expression))"
        case .inr(let expression):
            "inr(\(expression))"
        case .succ(let expression):
            "succ(\(expression))"
        case .pred(let expression):
            "Nat::pred(\(expression))"
        case .isZero(let expression):
            "Nat::iszero(\(expression))"
        case .fix(let expression):
            "fix(\(expression))"
        case .natRec(let iters, let ini, let step):
            "Nat::rec(\(iters), \(ini), \(step))"
        }
    }
}
