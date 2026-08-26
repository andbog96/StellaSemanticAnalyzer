extension Context {
    func unify(actual: CanonicalType, expected: CanonicalType) throws(UnifyError) -> CanonicalType {
        guard extensions.contains(.typeReconstruction) else {
            guard actual == expected else {
                throw .unexpectedType(actual: actual, expected: expected)
            }

            return actual
        }
        
        let unexpectedTypeError = UnifyError.unexpectedType(actual: actual, expected: expected)
        throw unexpectedTypeError

//        switch (self, expected) {
//        case (.auto, _),
//             (_, .auto):
//            return
//
//        case let (.function(actualFrom, actualTo), .function(expectedFrom, expectedTo)):
//            guard actualFrom.count == expectedFrom.count else {
//                throw unexpectedTypeError
//            }
//
//            for (actual, expected) in zip(actualFrom, expectedFrom) {
//                try actual.unify(with: expected)
//            }
//            try actualTo.unify(with: expectedTo)
//
//        case let (.tuple(actualTuple), .tuple(expectedTuple)):
//            guard actualTuple.count == expectedTuple.count else {
//                throw .unexpectedTupleLength(actual: actualTuple.count, expected: expectedTuple.count, type: self)
//            }
//
//            for (actual, expected) in zip(actualTuple, expectedTuple) {
//                try actual.unify(with: expected)
//            }
//
//        case let (.record(actualRecord), .record(expectedRecord)):
//            break
//            //            guard actualRecord.count == expectedRecord.count else {
//            //                throw .unexpectedType(actualType: actualType, expectedType: expectedType, expression: self)
//            //            }
//            //
//            //            try actualRecord.forEachTry { key, actualValue throws(TypeError) in
//            //                    guard let expectedValue = expectedRecord[key] else {
//            //                        throw .unexpectedType(actualType: actualType, expectedType: expectedType, expression: self)
//            //                    }
//            //
//            //                    try unify(actualType: actualValue, expectedType: expectedValue)
//            //                }
//
//        case let (.sum(actualLeft, actualRight), .sum(expectedLeft, expectedRight)):
//            try actualLeft.unify(with: expectedLeft)
//            try actualRight.unify(with: expectedRight)
//
//        case let (.list(actualList), .list(expectedList)):
//            try actualList.unify(with: expectedList)
//
//        case let (.variant(actualVariants), .variant(expectedVariants)):
//            guard actualVariants.count == expectedVariants.count else {
//                throw unexpectedTypeError
//            }
//
//            for (actualLabel, actualType) in actualVariants {
//                
//            }
//            
////            try tags1.forEachTry { key, actualValue throws(UnifyError) in
//                //                guard let expectedValue = tags2[key] else {
//                //                    throw .unexpectedVariantLabel(label: key, expectedType: expectedType, expression: self)
//                //                }
//                //
//                //                switch (actualValue, expectedValue) {
//                //                case (nil, nil):
//                //                    break
//                //                case let (t1?, t2?):
//                //                    try unify(actualType: t1, expectedType: t2)
//                //                default:
//                //                    throw .unexpectedType(actualType: actualType, expectedType: expectedType, expression: self)
//                //                }
////            }
//
//        default:
//            throw unexpectedTypeError
//        }
    }
}

enum UnifyError: Error {
    case unexpectedTupleLength(actual: Int, expected: Int, type: CanonicalType)
    case unexpectedType(actual: CanonicalType, expected: CanonicalType)
}
