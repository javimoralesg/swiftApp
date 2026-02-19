//
//  CheckAnswerItem.swift
//  QuzzFinal
//
//  Created by Javier Morales Galisteo on 8/1/26.
//

import Foundation

struct CheckAnswerItem: Codable {
    let quizId: Int
    let answer: String
    var result: Bool
}
