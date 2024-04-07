//
//  loginService.swift
//  EShop AUTH
//
//  Created by Torekhan Mukhtarov on 07.04.2024.
//

import Foundation

enum AuthenticationError: Error {
    case custom(errorMessage: String)
}

class LoginService {

    public static var requestDomain = "http://localhost:3000"

    static func signup(phoneNumber: String, completion: @escaping (Result<Bool, AuthenticationError>) -> Void) {
        guard let urlString = URL(string: "\(requestDomain)/authentication/signup") else {
            print("Invalid URL")
            completion(.failure(.custom(errorMessage: "Invalid URL")))
            return
        }

        makeRequest(urlString: urlString, reqBody: ["phone": phoneNumber]) { result in
            switch result {
            case .success(let data):
                do {
                    let success = try JSONDecoder().decode(Bool.self, from: data!)
                    completion(.success(success))
                } catch {
                    print("Error: Couldn't decode data into Bool: \(error)")
                    completion(.failure(.custom(errorMessage: "Failed to decode response")))
                }
            case .failure(let error):
                print("Network error: \(error)")
                completion(.failure(.custom(errorMessage: "Network request failed")))
            }
        }
    }
    
    private static func makeRequest(urlString: URL, reqBody: [String: Any], completion: @escaping (_ result: Result<Data?, Error>) -> Void) {
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: [])
        } catch {
            print("Error: Could not serialize request body")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request error: \(String(describing: error))")
                completion(.failure(error!))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
