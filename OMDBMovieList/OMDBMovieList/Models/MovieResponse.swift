//
//  MovieResponse.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import Foundation
struct MovieResponse: Codable {
    let Search: [Movie]?
    let totalResults: String?
    let Response: String?
    let Error: String?
    
    enum CodingKeys: String, CodingKey {
        case Search
        case totalResults
        case Response
        case Error
    }
}
