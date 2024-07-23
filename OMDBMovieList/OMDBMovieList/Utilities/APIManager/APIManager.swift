//
//  APIManager.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func fetchMovies(searchTerm: String, page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let safeSearchTerm = searchTerm.count > 100 ? String(searchTerm.prefix(100)) : searchTerm
        guard let url = URL(string: "\(APIConstants.baseURL)?s=\(safeSearchTerm)&page=\(page)&apikey=\(APIConstants.apiKey)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.invalidURL])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.noDataReceived])))
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
