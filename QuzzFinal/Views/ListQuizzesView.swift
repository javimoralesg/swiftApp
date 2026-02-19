//
//  ListQuizzesView.swift
//  QuzzFinal
//
//  Created by Javier Morales Galisteo on 7/1/26.
//

import SwiftUI

struct ListQuizzesView: View {
    
    @Environment(QuizzesModel.self) var quizzesModel
    @Environment(ScoresModel.self) var scoresModel
    
    @State var soloFavoritos: Bool = false
    @State var soloAcertados: Bool = false

    var body: some View {

        NavigationStack {
            VStack{
                Toggle("Solo favoritos", isOn: $soloFavoritos)
                Toggle("Sin acertar", isOn: $soloAcertados)
            }
            .padding(.bottom, 16)
            .background(Color(red: 147/255, green: 117/255, blue: 115/255))
            
            
            List {
                ForEach(
                    quizzesModel.quizzes.filter{ quiz in
                        (!soloFavoritos || quiz.favourite) && (!soloAcertados || !scoresModel.scores.contains(quiz.id))}
                ) { quiz in
                    NavigationLink {
                        PlayQuizView(quizItem: quiz)
                    } label: {
                        QuizRowView(quizItem: quiz)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 177/255, green: 141/255, blue: 139/255).opacity(0.8))
            .navigationTitle("Quizzes")
            .onAppear{
                guard quizzesModel.quizzes.isEmpty else { return }
                Task{
                    await quizzesModel.load()
                }
            }
            .toolbar(content: {
                ToolbarItem {
                    HStack {
                        Text("\(scoresModel.scores.count) - \(scoresModel.record.count)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                    }
                }
                ToolbarItem {
                    Button("Refresh") {
                        Task {
                            await quizzesModel.load()
                            scoresModel.clearScores()
                        }
                    }
                }
            })
        }
        
    }
}
