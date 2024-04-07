import Foundation

struct ValidationResponse: Decodable {
    let accessToken: String
}

enum ValidationError: Error {
    case custom(errorMessage: String)
}

class ValidationService {
    
    public static var requestDomain = "http://localhost:3000"

    static func validateCode(phoneNumber: String, code: String, completion: @escaping (_ result: Result<ValidationResponse, ValidationError>) -> Void) {
        guard let urlString = URL(string: "\(requestDomain)/authentication/validate"),
              let codeInt = Int(code) else { // Преобразование кода в Int
            completion(.failure(.custom(errorMessage: "Invalid URL or code format")))
            return
        }

        let requestBody = ["phone": phoneNumber, "code": codeInt] as [String : Any]
        print("Sending validation request to \(urlString) with body \(requestBody)")
        makeRequest(urlString: urlString, reqBody: requestBody) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.custom(errorMessage: "No data received")))
                    return
                }
                
                do {
                    let validationResponse = try JSONDecoder().decode(ValidationResponse.self, from: data)
                    completion(.success(validationResponse))
                    print("Validation succeeded with response: \(validationResponse)")
                } catch let decodeError {
                    print("Decoding error: \(decodeError)")
                    completion(.failure(.custom(errorMessage: "Failed to decode ValidationResponse")))
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(.custom(errorMessage: "Network request failed: \(error)")))
            }
        }
    }
    
    private static func makeRequest(urlString: URL, reqBody: [String: Any], completion: @escaping (_ result: Result<Data?, Error>) -> Void) {
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: [])
        } catch let serializationError {
            print("Serialization error: \(serializationError)")
            completion(.failure(serializationError))
            return
        }
        
        print("Sending request to \(urlString) with body: \(reqBody)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network request error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response received.")
                completion(.failure(ValidationError.custom(errorMessage: "Invalid response received")))
                return
            }
            
            print("Received HTTP response: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                print("Server returned status code \(httpResponse.statusCode)")
                completion(.failure(ValidationError.custom(errorMessage: "Server returned status code \(httpResponse.statusCode)")))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
