//
//  Extensions.swift
//  Quiz
//
//  Created by Santiago Pavón Gómez on 18/10/24.
//

import Foundation

infix operator =+-= : ComparisonPrecedence

extension String {
    
    // Devuelve el string lowered y trimmed
    func loweredTrimmed() -> String {
        self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Compara igualdad despues de lowered y trimmed
    func isLoweredTrimmedEqual(_ str: String) -> Bool {
        self.loweredTrimmed() == str.loweredTrimmed()
    }
    
    // Compara si dos string son mas o menos iguales, o mejor dicho,
    // igualdad despues de lowered y trimmed
    static func =+-= (s1: String, s2: String) -> Bool {
        s1.isLoweredTrimmedEqual(s2)
    }

}
