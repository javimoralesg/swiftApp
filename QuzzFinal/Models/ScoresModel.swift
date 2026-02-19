//
//  ScoresModel.swift
//  QuzzFinal
//
//  Created by Javier Morales Galisteo on 8/1/26.
//

import Foundation

@Observable class ScoresModel {
    
    private(set) var scores: Set<Int> = []
    private(set) var record: Set<Int> = []
    
    init() {
        if let record = UserDefaults.standard.object(forKey: "record") as? [Int] {
            self.record = Set(record)
        }
    }

    func addScore(quizId: Int) {
        scores.insert(quizId)
        record.insert(quizId)
        
        UserDefaults.standard.set(Array(record), forKey: "record")
    }
    
    func clearScores() {
        scores.removeAll()
    }
}
