import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Int)
    case decodingFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let code):
            return "Request Error: \(code)"
        case .decodingFailed:
            return "Unable to decode data"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

class NetworkService {
    
    ///Reusable GET
    func fetch<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.requestFailed((response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            do {
                let decoder = try JSONDecoder().decode(T.self, from: data)
                return decoder
            } catch {
                throw NetworkError.decodingFailed
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
