//
//  QuizzesModel.swift
//  Quiz
//
//  Created by Santiago Pavón Gómez on 18/10/24.
//

import Foundation

/// Errores producidos en el modelo de los Quizzes
enum QuizzesModelError: LocalizedError {
    case internalError(msg: String)
    case corruptedDataError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .internalError(let msg):
            return "Error interno: \(msg)"
        case .corruptedDataError:
            return "Recibidos datos corruptos"
        case .unknownError:
            return "No chungo ha pasado"
       }
    }
}

@Observable class QuizzesModel {
    
    // Los datos
    private(set) var quizzes = [QuizItem]()
    
    /* func load() {
        do {
            guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json") else {
                throw QuizzesModelError.internalError(msg: "No encuentro quizzes.json")
            }
            
            let data = try Data(contentsOf: jsonURL)
            
            // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else {
                throw QuizzesModelError.corruptedDataError
            }
            
            self.quizzes = quizzes
            
            print("Quizzes cargados")
        } catch {
            print(error.localizedDescription)
        }
    }
     
     func toggleFavourite(quizId: Int) {
         if let index = quizzes.firstIndex(where: { $0.id == quizId }) {
             quizzes[index].favourite.toggle()
         }
     }
     */
    
    func load() async {
        do {
            let url = URL(string: "https://quiz.dit.upm.es/api/quizzes/random10?token=YOUR_TOKEN")!
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.resourceUnavailable)
            }

            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else {
                throw QuizzesModelError.corruptedDataError
            }
                        
            self.quizzes = quizzes
            
            print("Quizzes cargados")
        } catch {
            print(error)
        }
    }
    
    func toggleFavourite(quizId: Int) async {
        do {
            let url = URL(string: "https://quiz.dit.upm.es/api/users/tokenOwner/favourites/\(quizId)?token=YOUR_TOKEN")!

            var request = URLRequest(url: url)
            
            if let index = quizzes.firstIndex(where: { $0.id == quizId }) {
                request.httpMethod = quizzes[index].favourite ? "DELETE" : "PUT"
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.resourceUnavailable)
            }

            let respuestaHTTP = try JSONDecoder().decode(FavouriteToggleItem.self, from: data)

            if let index = quizzes.firstIndex(where: { $0.id == quizId }) {
                quizzes[index].favourite = respuestaHTTP.favourite
            }

        } catch {
            print(error)
        }
    }
    
}
