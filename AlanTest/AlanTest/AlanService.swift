//
//  AlanService.swift
//  AlanTest
//
//  Created by 윤태한 on 4/22/25.
//

import Foundation

class AlanService {
    static let shared = AlanService()

    private let apiKey = "5d9dc365-c82e-478b-ac78-c29554c44e22"
    private let baseURL = "https://alan.estsoft.ai/api/v1/question"

    
    private let clientID = UUID().uuidString

    func sendCommand(_ userText: String, completion: @escaping (String?) -> Void) {
        
        guard let encodedQuestion = userText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?content=\(encodedQuestion)&client_id=\(clientID)") else {
            completion("API URL 오류")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let reply = json["content"] as? String {
                completion(reply)
            } else {
                completion("Alan 응답 오류")
            }
        }.resume()
    }
}

