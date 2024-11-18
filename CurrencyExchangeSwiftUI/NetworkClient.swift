//
//  NetworkClient.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 03.11.2024.
//

import Foundation

class NetworkClient {
    static let shared = NetworkClient()
    private init() {}
    
    func request<T: Decodable>(_ type: T.Type,
                               url: URL,
                               method: String = "GET",
                               headers: [String: String]? = nil,
                               body: Data? = nil,
                               completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum NetworkConstants  {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
}
