//
//  QuizRowView.swift
//  QuzzFinal
//
//  Created by Javier Morales Galisteo on 7/1/26.
//

import SwiftUI

struct QuizRowView: View {
    
    @Environment(QuizzesModel.self) var quizzesModel
    
    var quizItem: QuizItem
    
    var body: some View {
        
        HStack {
            EasyAsyncImage(url: quizItem.attachment?.url)
                .easyCircle()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(quizItem.question)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(2)
                Text(quizItem.author?.username ?? quizItem.author?.profileName ?? "Anónimo")
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    await quizzesModel.toggleFavourite(quizId: quizItem.id)
                }
            }) {
                Image(systemName: quizItem.favourite ? "star.fill" : "star")
                    .foregroundColor(quizItem.favourite ? .yellow : .gray)
            }
            .buttonStyle(.plain)
        }
        
    }
}
