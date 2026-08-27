extension Name: CustomStringConvertible {
    var description: String {
        value
    }
}

extension Label: CustomStringConvertible {
    var description: String {
        value
    }
}

extension DefaultStringInterpolation {
    /// https://forums.swift.org/t/multi-line-string-nested-indentation-with-interpolation/36933
    mutating func appendInterpolation(indented string: CustomStringConvertible) {
        let indent = String(stringInterpolation: self)
            .reversed()
            .prefix { " \t".contains($0) }
        if indent.isEmpty {
            appendInterpolation(string)
        } else {
            appendLiteral(
                string.description
                    .split(separator: "\n", omittingEmptySubsequences: false)
                    .joined(separator: "\n" + indent)
            )
        }
    }

    mutating func appendInterpolation(lines: Int, _ string: String) {
        if string.isEmpty {
            appendLiteral("\\")
        } else {
            for _ in 1..<lines {
                self.appendLiteral("\n")
            }
            self.appendInterpolation(string)
        }
    }
}

extension Program: CustomStringConvertible {
    var description: String {
        """
        \(declarations.map(String.init(describing:)).joined(separator: "\n\n"))
        """.replacingOccurrences(of: "\\\n", with: "")
    }
}

private func functionReturnAndBody(
    _ returnType: RawType?,
    _ throwTypes: [RawType],
    _ declarations: [Declaration],
    _ returnExpr: Expression
) -> String {
    let returnMark = returnType.map { "-> \($0) " } ?? ""
    let throwMark = throwTypes.isEmpty ? ""
        : "throws \(throwTypes.map(String.init(describing:)).joined(separator: ", ")) "

    let returnString = "return \(returnExpr)"

    let bodyDecls = declarations.lazy
        .map { "\($0)" + "\n" }
        .joined(separator: "")
    let bodyString = "\(bodyDecls)\(returnString)"

    return """
    \(returnMark)\(throwMark){
        \(indented: bodyString)
    }
    """
}

extension Declaration: CustomStringConvertible {
    var description: String {
        switch self {
        case .exceptionType(let type):
            return "exception type = \(type)"

        case .exceptionVariant(let name, let type):
            return "exception variant \(name) : \(type)"

        case .function(
            let name,
            let typeVariables,
            let parameters,
            let returnType,
            let throwTypes,
            let declarations,
            let returnExpression
        ):
            let typeVariables = typeVariables.map(\.description).joined(separator: ", ")

            return """
            \(typeVariables.isEmpty ? "" : "generic ")\
            fn \(name)\(typeVariables.isEmpty ? "" : "[\(typeVariables)]")\
            (\(parameters.map({"\($0.name): \($0.rawType)"}).joined(separator: ", "))) \
            \(functionReturnAndBody(returnType, throwTypes, declarations, returnExpression))
            """
        }
    }
}

extension Pattern: CustomStringConvertible {
    var description: String {
        switch self {
        case .false:
            "false"
            
        case .true:
            "true"
            
        case .unit:
            "unit"
            
        case .zero:
            "0"
            
        case .var(let identifier):
            identifier.description
            
        case .succ(let pattern):
            "succ(\(pattern))"
            
        case .cast(let pattern, let type):
            "\(pattern) cast as \(type)"
            
        case .ascription(let pattern, let type):
            "\(pattern) as \(type)"
            
        case .variant(let identifier, let pattern):
            "<|\(identifier)\(pattern.map {" = \($0)"} ?? "")|>"
            
        case .inl(let pattern):
            "inl(\(pattern))"
            
        case .inr(let pattern):
            "inr(\(pattern))"
            
        case .tuple(let patterns):
            "{\(patterns.map(\.description).joined(separator: ", "))}"
            
        case .record(let patterns):
            "{\(patterns.map { "\($0) = \($1)" }.joined(separator: ", "))}"
            
        case .list(let patterns):
            "[\(patterns.map(\.description).joined(separator: ", "))]"
            
        case .cons(let pattern1, let pattern2):
            "cons(\(pattern1), \(pattern2))"
        }
    }
}

extension RawType: CustomStringConvertible {
    var description: String {
        switch self {
        case .auto: 
            "auto"
            
        case .bool:
            "Bool"
            
        case .nat:
            "Nat"
            
        case .unit:
            "Unit"
            
        case .top:
            "Top"
            
        case .bottom:
            "Bot"

        case let .variable(identifier):
            identifier.description

        case let .function(fromType, toType):
            "fn(\(fromType.map(\.description).joined(separator: ", "))) -> \(toType)"

        case .tuple(let array):
            "{\(array.map(\.description).joined(separator: ", "))}"

        case .record(let array):
            "{\(array.map {"\($0) : \($1)"}.joined(separator: ", "))}"

        case .sum(let left, let right):
            "\(left.code(in: self)) + \(right.code(in: self))"

        case .list(let type):
            "[\(type)]"

        case .variant(let array):
            "<|\(array.map(fieldDecl).joined(separator: ", "))|>"

        case .forall(let variables, let type):
            "forall \(variables.map(\.description).joined(separator: " ")). \(type)"

         case .mu(let identifier, let type):
             "µ \(identifier). \(type)"

        case .reference(let type):
            "&\(type.code(in: self))"
        }
    }
}

private func fieldDecl(for label: Label, and type: some CustomStringConvertible?) -> String {
    guard let type else {
        return label.value
    }
    
    return "\(label) : \(type)"
}

private extension RawType {
    func needsParens(in parent: Self) -> Bool {
        switch (parent, self) {
        case (.sum, .sum),
            (.sum, .function),
            (.sum, .forall),
            (.reference, .sum),
            (.reference, .function),
            (.reference, .forall):
            true
        default:
            false
        }
    }

    func code(in parent: Self) -> String {
        if needsParens(in: parent) {
            return "(\(self))"
        }
        return description
    }
}

extension MemoryAddress: CustomStringConvertible {
    var description: String {
        "<0x\(value)>"
    }
}

extension CanonicalType: CustomStringConvertible {
    var description: String {
        switch self {
        case .auto:
            "auto"
            
        case .bool:
            "Bool"
            
        case .nat:
            "Nat"
            
        case .unit:
            "Unit"
            
        case .top:
            "Top"
            
        case .bottom:
            "Bot"

        case let .variable(identifier):
            identifier.description

        case let .function(fromType, toType):
            "fn(\(fromType.map(\.description).joined(separator: ", "))) -> \(toType)"

        case .tuple(let array):
            "{\(array.map(\.description).joined(separator: ", "))}"

        case .record(let fields):
            "{\(fields.map {"\($0) : \($1)"}.joined(separator: ", "))}"

        case .sum(let left, let right):
            "\(left.code(in: self)) + \(right.code(in: self))"

        case .list(let type):
            "[\(type)]"

        case .variant(let cases):
            "<|\(cases.map(fieldDecl).joined(separator: ", "))|>"

        case .forall(let variables, let type):
            "forall \(variables.map(\.description).joined(separator: " ")). \(type)"

         case .mu(let identifier, let type):
             "µ \(identifier). \(type)"

        case .reference(let type):
            "&\(type.code(in: self))"
        }
    }
}

private extension CanonicalType {
    func needsParens(in parent: Self) -> Bool {
        switch (parent, self) {
        case (.sum, .sum),
            (.sum, .function),
            (.sum, .forall),
            (.reference, .sum),
            (.reference, .function),
            (.reference, .forall):
            true
        default:
            false
        }
    }

    func code(in parent: Self) -> String {
        if needsParens(in: parent) {
            return "(\(self))"
        }
        return description
    }
}
