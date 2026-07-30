extension Context {
    func infer(_ expression: borrowing Expression) throws(TypeCheckError) -> CanonicalType {
        switch expression {
        // MARK: - STLC
        case .var(let name):
            return try self[name]
            
        case .abstraction(let parameters, let returnExpression):
            let canonicalParameters = try parameters.canonized() <!> TypeCheckError.canonizeError
            
            let localContext = try overlaid(by: canonicalParameters) <!> { error in
                TypeCheckError.contextError(error, in: .lambda(
                    parameters: parameters,
                    returnExpression: returnExpression
                ))
            }
            
            let returnType = try localContext.infer(returnExpression)
            
            return .function(from: canonicalParameters.map(\.type), to: returnType)
            
        case .application(let callee, let arguments):
            let calleeType = try infer(callee)
            guard case let .function(parameterTypes, returnType) = calleeType else {// TODO: .var(Name)
                throw .notAFunction(actual: calleeType, in: copy expression)
            }
            guard arguments.count == parameterTypes.count else {
                throw .incorrectArgumentsNumber(
                    actual: arguments.count,
                    expected: parameterTypes.count,
                    type: calleeType,
                    in: copy expression
                )
            }
            
            for (argument, parameterType) in zip(arguments, parameterTypes) {
                try check(argument, against: parameterType)
            }
            
            return returnType
            
        // MARK: - Bool
        case .constTrue,
             .constFalse:
            return .bool
            
        case .if(let condition, let then, let `else`):
            try check(condition, against: .bool)
            
            let thenType = try infer(then)
            let elseType = try infer(`else`)
            
            return try thenType.unify(with: elseType) <!> { error in
                TypeCheckError.unifyError(error, in: copy expression)
            }

        // MARK: - Nat
        case .constInt:
            return .nat
            
        case .succ(let expression):
            try check(expression, against: .nat)
            
            return .nat
            
        case .pred(let expression):
            try check(expression, against: .nat)
            
            return .nat
            
        case .isZero(let expression):
            try check(expression, against: .nat)
            
            return .bool
            
        case .natRec(let n, let zero, let step):
            try check(n, against: .nat)
            
            let zeroType = try infer(zero)
            let stepType = try infer(step)

//            return try stepType.unify(
//                with: .function(from: [.nat], to: .function(from: [zeroType], to: zeroType))
//            ) <!> { error in
//                TypeCheckError.unifyError(error, in: copy expression)
//            }

            do {
                return try stepType.unify(
                    with: .function(
                        from: [.nat],
                        to: .function(from: [zeroType], to: zeroType)
                    )
                )
            } catch {
                throw .unifyError(error, in: copy expression)
            }
            
        // MARK: - #unit-type
        case .constUnit:
            return .unit
            
        // MARK: - #pairs, #tuples
        case .tuple(let elements):
            let types = try elements.map(infer)
            
            return .tuple(elements: types)
            
        case .dotTuple(let tuple, let index):
            let tupleType = try infer(tuple)
            
            guard case .tuple(let elements) = tupleType else {
                throw .notATuple(actual: tupleType, in: copy expression)
            }
            
            guard let type = elements[safe: index - 1] else {
                throw .tupleIndexOutOfBounds(index: index, type: tupleType, in: copy expression)
            }
            
            return type

        // MARK: - #records
        case .record(let fields):
            return try CanonicalType.record § Dictionary(
                uniqueKeysWithValues: fields.lazy.map {
                    (key: $0.label, value: $0.expression)
                },
                rejectingDuplicateKeysWith: { duplicates in
                    TypeCheckError.duplicateRecordFields(duplicates, in: copy expression)
                }
            )
            .mapValues(infer)

        case .dotRecord(let record, let label):
            let recordType = try infer(record)
            
            guard case .record(let fields) = recordType else {
                throw .notARecord(actual: recordType, in: copy expression)
            }
            
            guard let type = fields[label] else {
                throw .unexpectedFieldAccess(field: label, type: recordType, in: copy expression)
            }

            return type

        // MARK: - #let-patterns
        case .let(let cases, let expression):
            var localContext = self

            for (pattern, value) in cases {
                let valueType = try localContext.infer(value)
                
                
                
                let bindings = try pattern.match(against: valueType) <!> TypeCheckError.patternMatchError
                localContext.overlay(by: bindings)
            }

            return try localContext.infer(expression)

//        // MARK: - #letrec-bindings
//        indirect case letrec([(pattern: Pattern, expression: Expression)], Expression)
            
            
        default:
            return .auto // TODO: delete
        }
    }
}

extension CanonicalType {
    func checkExhaustiveness(of patterns: [Pattern]) throws(TypeCheckError) {
        
    }
}
