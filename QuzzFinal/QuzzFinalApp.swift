//
//  QuzzFinalApp.swift
//  QuzzFinal
//
//  Created by Javier Morales Galisteo on 7/1/26.
//

import SwiftUI

@main
struct QuzzFinalApp: App {
    
    @State var quizzesModel = QuizzesModel()
    @State var scoresModel = ScoresModel()

    var body: some Scene {
        WindowGroup {
            ListQuizzesView()
                .environment(quizzesModel)
                .environment(scoresModel)
        }
    }
}
