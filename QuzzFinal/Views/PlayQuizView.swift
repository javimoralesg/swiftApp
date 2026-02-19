//
//  PlayQuizView.swift
//  QuzzFinal
//
//  Created by Javier Morales Galisteo on 7/1/26.
//

import SwiftUI

struct PlayQuizView: View {
    
    var quizItem: QuizItem
    
    @Environment(QuizzesModel.self) var quizzesModel
    @Environment(ScoresModel.self) var scoresModel
    @Environment(\.verticalSizeClass) var vsc
    
    @State var answer: String = ""
    @State var isCorrect: Bool = false
    @State var showAlert: Bool = false
    
    @State var rotationEffect: Double = 0.0
    @State var scaleEffect: Double = 1.0

    var body: some View {
        
        VStack {
            titulo
            if vsc == .compact {
                HStack{
                    attachment
                    VStack{
                        autor
                        respuesta
                    }
                }
            } else {
                VStack{
                    attachment
                    autor
                    respuesta
                }
            }
        }
        .padding(20)
        .navigationTitle("Play Quiz")
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    Task {
                        await quizzesModel.toggleFavourite(quizId: quizItem.id)
                    }
                }) {
                    Image(systemName: quizItem.favourite ? "star.fill" : "star")
                        .foregroundColor(quizItem.favourite ? .yellow : .gray)
                }
            }
        })
    }
    
    var titulo: some View {
        Text(quizItem.question)
            .font(.title2)
            .fontWeight(.bold)
            .lineLimit(4)
    }
    
    var attachment: some View {
        GeometryReader{ geo in
            EasyAsyncImage(url: quizItem.attachment?.url)
                .frame(width: geo.size.width*0.8, height: 250)
                .easyRoundedRectangle()
                .rotationEffect(Angle(degrees: rotationEffect))
                .scaleEffect(CGFloat(scaleEffect))
                .onTapGesture(count: 2) {
                    Task {
                        await showAnswer()
                    }
                    withAnimation {
                        scaleEffect = 0.2
                        rotationEffect+=360
                    } completion: {
                        scaleEffect = 1.0
                    }
                }
        }
    }
    
    var autor: some View {
        HStack {
            Text(quizItem.author?.username ?? quizItem.author?.profileName ?? "Anónimo")
            
            EasyAsyncImage(url: quizItem.author?.photo?.url)
                .easyCircle()
                .frame(width:50, height: 50)
                .contextMenu {
                    Button("Ver respuesta"){
                        Task {
                            await showAnswer()
                        }
                    }
                    Button("Borrar respuesta"){
                        answer = ""
                    }
                }
        }
    }
    
    var respuesta: some View {
        VStack {
            TextField("Escribe tu respuesta", text: $answer)
            
            Button(action: {
                Task {
                    await checkAnswer()
                }
            }) {
                Text("Comprobar")
            }
        }
        .alert(isCorrect ? "!Correcto!" : "!Incorrecto!" ,isPresented: $showAlert) {
            
        } message: {
            Text(isCorrect ? "Eres un crack" : "Sigue intentándolo")
        }
    }
    
    func checkAnswer() async {
        do {
            let escapedUserAnswer = answer.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? answer
            
            let url = URL(string: "https://quiz.dit.upm.es/api/quizzes/\(quizItem.id)/check?answer=\(escapedUserAnswer)&token=YOUR_TOKEN")!

            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.resourceUnavailable)
            }

            let respuestaHTTP = try JSONDecoder().decode(CheckAnswerItem.self, from: data)
            
            isCorrect = respuestaHTTP.result
            
            if isCorrect {
                scoresModel.addScore(quizId: quizItem.id)
            }
            showAlert = true
        } catch {
            print(error)
        }
    }
    
    func showAnswer() async {
        do {
            let url = URL(string: "https://quiz.dit.upm.es/api/quizzes/\(quizItem.id)/answer?token=YOUR_TOKEN")!

            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.resourceUnavailable)
            }

            let respuestaHTTP = try JSONDecoder().decode(ShowAnswerItem.self, from: data)
            
            answer = respuestaHTTP.answer
        } catch {
            print(error)
        }
    }

}
