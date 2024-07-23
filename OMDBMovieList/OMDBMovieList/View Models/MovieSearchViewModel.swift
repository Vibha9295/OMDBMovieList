//
//  MovieSearchViewModel.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//


import Foundation
import Combine

class MovieSearchViewModel: ObservableObject {
    
    @Published var movies = [Movie]()
    @Published var errorMessage: String?
    
    private var totalResults = 0
    private var currentPage = 1
    private var isLoading = false
    private var searchTerm = "all"
    
    func fetchMovies(searchTerm: String = "all", page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        
        APIManager.shared.fetchMovies(searchTerm: searchTerm, page: page) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movieResponse):
                    if movieResponse.Response == "True" {
                        self?.totalResults = Int(movieResponse.totalResults ?? "0") ?? 0
                        if page == 1 {
                            self?.movies = movieResponse.Search ?? []
                        } else {
                            self?.movies.append(contentsOf: movieResponse.Search ?? [])
                        }
                        self?.currentPage = page
                    } else {
                        self?.handleAPIError(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: movieResponse.Error ?? ErrorMessages.unknownError]))
                    }
                case .failure(let error):
                    self?.handleAPIError(error: error)
                }
            }
        }
    }
    
    func loadNextPage() {
        if isLoading { return }
        fetchMovies(searchTerm: searchTerm, page: currentPage + 1)
    }
    
    func search(for term: String) {
        searchTerm = term.isEmpty ? "all" : term
        currentPage = 1
        fetchMovies(searchTerm: searchTerm, page: currentPage)
    }
    
    private func handleAPIError(error: Error) {
        print("API Error: \(error.localizedDescription)")
        
        let userFriendlyMessage: String
        
        if let urlError = error as? URLError {
            userFriendlyMessage = ErrorMessages.noDataReceived
        } else {
            userFriendlyMessage = ErrorMessages.decodeError
        }
        
        DispatchQueue.main.async {
            self.errorMessage = userFriendlyMessage
        }
    }
}
