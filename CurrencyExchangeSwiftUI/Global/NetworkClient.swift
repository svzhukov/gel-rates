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
    
    func request<T: Decodable>(
                               url: URL,
                               method: Constants.Network.Method = Constants.Network.Method.get,
                               headers: [String: String]? = nil,
                               body: Data? = nil,
                               completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let dataReceived = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
        
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: dataReceived, options: [])
                if let dictionary = jsonObject as? [String: Any] {
                    print(dictionary)
                }
                
                let decodedObject = try JSONDecoder().decode(T.self, from: dataReceived)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
